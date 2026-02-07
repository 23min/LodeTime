package cmd

import (
	"bufio"
	"encoding/json"
	"errors"
	"fmt"
	"net"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/spf13/cobra"
	"gopkg.in/yaml.v3"
)

const (
	defaultEndpoint = "127.0.0.1:9998"
	statusTimeout   = 2 * time.Second
)

var (
	statusConnected bool
	statusOffline   bool
	statusAuto      bool
	statusJSON      bool
)

var (
	errConnect  = errors.New("connect")
	errProtocol = errors.New("protocol")
	errResponse = errors.New("response")
)

type statusMode string

const (
	modeAuto      statusMode = "auto"
	modeConnected statusMode = "connected"
	modeOffline   statusMode = "offline"
)

type socketResponse struct {
	Ok    bool                 `json:"ok"`
	Data  map[string]any       `json:"data"`
	Error *socketResponseError `json:"error"`
}

type socketResponseError struct {
	Code    string `json:"code"`
	Message string `json:"message"`
}

var statusCmd = &cobra.Command{
	Use:   "status",
	Short: "Show project status",
	Long:  "Shows the current status of your LodeTime project.",
	Run: func(cmd *cobra.Command, args []string) {
		lodeDir := findLodeTimeRoot()
		if lodeDir == "" {
			fmt.Fprintln(os.Stderr, "Not in a LodeTime project (no .lodetime/ directory found)")
			os.Exit(1)
		}

		mode, err := resolveStatusMode(statusConnected, statusOffline, statusAuto)
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}

		var payload map[string]any
		offline := false

		switch mode {
		case modeConnected:
			payload, err = fetchStatus(resolveEndpoint(runtimeEndpoint, lodeDir), verbose, statusTimeout)
			if err != nil {
				fmt.Fprintln(os.Stderr, "Connected status failed:", err)
				os.Exit(1)
			}

		case modeOffline:
			payload, err = buildOfflineStatus(lodeDir, verbose)
			offline = true
			if err != nil {
				fmt.Fprintln(os.Stderr, "Offline status failed:", err)
				os.Exit(1)
			}

		case modeAuto:
			payload, err = fetchStatus(resolveEndpoint(runtimeEndpoint, lodeDir), verbose, statusTimeout)
			if err != nil {
				if errors.Is(err, errConnect) {
					fmt.Fprintln(os.Stderr, "Warning: runtime not reachable, using offline mode")
					payload, err = buildOfflineStatus(lodeDir, verbose)
					offline = true
					if err != nil {
						fmt.Fprintln(os.Stderr, "Offline status failed:", err)
						os.Exit(1)
					}
				} else {
					fmt.Fprintln(os.Stderr, "Connected status failed:", err)
					os.Exit(1)
				}
			}
		}

		payload = ensureMode(payload, offline)

		if statusJSON {
			output, err := renderStatusJSON(payload, verbose, offline)
			if err != nil {
				fmt.Fprintln(os.Stderr, "Failed to render JSON:", err)
				os.Exit(1)
			}
			fmt.Println(output)
			return
		}

		fmt.Print(renderStatusHuman(payload, verbose, offline))
	},
}

func init() {
	statusCmd.Flags().BoolVar(&statusConnected, "connected", false, "require runtime connection")
	statusCmd.Flags().BoolVar(&statusOffline, "offline", false, "read .lodetime/ directly")
	statusCmd.Flags().BoolVar(&statusAuto, "auto", true, "auto-detect mode (default)")
	statusCmd.Flags().BoolVar(&statusJSON, "json", false, "output JSON only")
}

func resolveStatusMode(connected, offline, auto bool) (statusMode, error) {
	if connected && offline {
		return "", fmt.Errorf("choose only one of --connected or --offline")
	}
	if connected {
		return modeConnected, nil
	}
	if offline {
		return modeOffline, nil
	}
	if auto {
		return modeAuto, nil
	}
	return "", fmt.Errorf("mode required; use --auto, --connected, or --offline")
}

func ensureMode(payload map[string]any, offline bool) map[string]any {
	if payload == nil {
		payload = map[string]any{}
	}

	if _, ok := payload["mode"]; !ok {
		if offline {
			payload["mode"] = string(modeOffline)
		} else {
			payload["mode"] = string(modeConnected)
		}
	}
	if offline {
		payload["source"] = "offline"
	}

	return payload
}

func resolveEndpoint(flagValue, lodeDir string) string {
	if flagValue != "" {
		return flagValue
	}
	if env := os.Getenv("LODE_RUNTIME_ENDPOINT"); env != "" {
		return env
	}

	if lodeDir != "" {
		if endpoint, ok := endpointFromConfig(filepath.Join(lodeDir, "config.yaml")); ok {
			return endpoint
		}
	}

	if configDir, err := os.UserConfigDir(); err == nil {
		configPath := filepath.Join(configDir, "lode", "config.yaml")
		if endpoint, ok := endpointFromConfig(configPath); ok {
			return endpoint
		}
	}

	return defaultEndpoint
}

func endpointFromConfig(path string) (string, bool) {
	data, err := os.ReadFile(path)
	if err != nil {
		return "", false
	}

	var config map[string]any
	if err := yaml.Unmarshal(data, &config); err != nil {
		return "", false
	}

	if runtime, ok := config["runtime"].(map[string]any); ok {
		if endpoint, ok := runtime["endpoint"].(string); ok && endpoint != "" {
			return endpoint, true
		}
	}
	if endpoint, ok := config["runtime_endpoint"].(string); ok && endpoint != "" {
		return endpoint, true
	}
	if endpoint, ok := config["endpoint"].(string); ok && endpoint != "" {
		return endpoint, true
	}

	return "", false
}

func fetchStatus(endpoint string, verbose bool, timeout time.Duration) (map[string]any, error) {
	conn, err := net.DialTimeout("tcp", endpoint, timeout)
	if err != nil {
		return nil, fmt.Errorf("%w: %v", errConnect, err)
	}
	defer conn.Close()

	_ = conn.SetDeadline(time.Now().Add(timeout))

	request := map[string]any{
		"cmd":     "status",
		"verbose": verbose,
	}
	payload, err := json.Marshal(request)
	if err != nil {
		return nil, fmt.Errorf("%w: %v", errProtocol, err)
	}

	if _, err := conn.Write(append(payload, '\n')); err != nil {
		return nil, fmt.Errorf("%w: %v", errProtocol, err)
	}

	reader := bufio.NewReader(conn)
	line, err := reader.ReadString('\n')
	if err != nil {
		return nil, fmt.Errorf("%w: %v", errProtocol, err)
	}

	var response socketResponse
	if err := json.Unmarshal([]byte(strings.TrimSpace(line)), &response); err != nil {
		return nil, fmt.Errorf("%w: %v", errProtocol, err)
	}

	if !response.Ok {
		if response.Error != nil {
			return nil, fmt.Errorf("%w: %s: %s", errResponse, response.Error.Code, response.Error.Message)
		}
		return nil, fmt.Errorf("%w: unknown error", errResponse)
	}

	if response.Data == nil {
		response.Data = map[string]any{}
	}

	return response.Data, nil
}

func buildOfflineStatus(lodeDir string, verbose bool) (map[string]any, error) {
	config, err := loadConfig(lodeDir)
	if err != nil {
		return nil, err
	}

	componentCount, err := countYamlFiles(filepath.Join(lodeDir, "components"))
	if err != nil {
		return nil, err
	}
	contractCount, err := countYamlFiles(filepath.Join(lodeDir, "contracts"))
	if err != nil {
		return nil, err
	}

	payload := map[string]any{
		"mode":   string(modeOffline),
		"source": "offline",
		"graph": map[string]any{
			"component_count": componentCount,
			"contract_count":  contractCount,
		},
	}

	if verbose {
		if summary := buildConfigSummary(config); summary != nil {
			payload["config_summary"] = summary
		}
	}

	return payload, nil
}

func loadConfig(lodeDir string) (map[string]any, error) {
	configPath := filepath.Join(lodeDir, "config.yaml")
	data, err := os.ReadFile(configPath)
	if err != nil {
		return nil, err
	}

	var config map[string]any
	if err := yaml.Unmarshal(data, &config); err != nil {
		return nil, err
	}

	return config, nil
}

func countYamlFiles(dir string) (int, error) {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return 0, err
	}

	count := 0
	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}
		if filepath.Ext(entry.Name()) == ".yaml" {
			count++
		}
	}

	return count, nil
}

func buildConfigSummary(config map[string]any) map[string]any {
	summary := map[string]any{}
	if profile, ok := config["active_profile"].(string); ok && profile != "" {
		summary["active_profile"] = profile
	}

	if watched := countWatchedPaths(config); watched >= 0 {
		summary["watched_paths_count"] = watched
	}

	if ignored := countIgnoredPaths(config); ignored >= 0 {
		summary["ignored_paths_count"] = ignored
	}

	if len(summary) == 0 {
		return nil
	}

	return summary
}

func countWatchedPaths(config map[string]any) int {
	zones, ok := config["zones"].(map[string]any)
	if !ok {
		return -1
	}

	total := 0
	for _, zone := range zones {
		zoneMap, ok := zone.(map[string]any)
		if !ok {
			continue
		}
		paths, ok := zoneMap["paths"].([]any)
		if !ok {
			continue
		}
		total += len(paths)
	}

	return total
}

func countIgnoredPaths(config map[string]any) int {
	triggers, ok := config["triggers"].(map[string]any)
	if !ok {
		return -1
	}
	fileSystem, ok := triggers["file_system"].(map[string]any)
	if !ok {
		return -1
	}
	ignore, ok := fileSystem["ignore"].([]any)
	if !ok {
		return -1
	}

	return len(ignore)
}

func renderStatusJSON(payload map[string]any, verbose bool, offline bool) (string, error) {
	if !verbose {
		delete(payload, "config_summary")
		delete(payload, "queue")
		delete(payload, "last_check")
		delete(payload, "tools")
		delete(payload, "errors")
		if graph, ok := payload["graph"].(map[string]any); ok {
			delete(graph, "hash")
			delete(graph, "last_change_at")
		}
	}
	if offline {
		delete(payload, "runtime_state")
		delete(payload, "runtime_version")
		delete(payload, "last_error")
	}

	data, err := json.MarshalIndent(payload, "", "  ")
	if err != nil {
		return "", err
	}

	return string(data), nil
}

func renderStatusHuman(payload map[string]any, verbose bool, offline bool) string {
	builder := &strings.Builder{}

	mode := stringValue(payload["mode"], "unknown")
	fmt.Fprintln(builder, "LodeTime Status")
	fmt.Fprintf(builder, "Mode: %s\n", mode)

	if source, ok := payload["source"]; ok {
		fmt.Fprintf(builder, "Source: %s\n", formatValue(source))
	}

	if !offline {
		fmt.Fprintf(builder, "Runtime State: %s\n", stringValue(payload["runtime_state"], "n/a"))
		fmt.Fprintf(builder, "Runtime Version: %s\n", stringValue(payload["runtime_version"], "n/a"))
	}

	writeSection(builder, "Graph", []sectionField{
		{key: "component_count", value: mapValue(payload["graph"])["component_count"]},
		{key: "contract_count", value: mapValue(payload["graph"])["contract_count"]},
	})

	if !offline {
		lastError := mapValue(payload["last_error"])
		writeSection(builder, "Last Error", []sectionField{
			{key: "count", value: lastError["count"]},
			{key: "last_at", value: lastError["last_at"]},
			{key: "last_message", value: lastError["last_message"]},
		})
	}

	if verbose {
		if offline {
			if summary := mapValue(payload["config_summary"]); len(summary) > 0 {
				writeSection(builder, "Config Summary", []sectionField{
					{key: "active_profile", value: summary["active_profile"]},
					{key: "watched_paths_count", value: summary["watched_paths_count"]},
					{key: "ignored_paths_count", value: summary["ignored_paths_count"]},
				})
			}
			return builder.String()
		}

		queue := mapValue(payload["queue"])
		writeSection(builder, "Queue", []sectionField{
			{key: "pending_count", value: queue["pending_count"]},
			{key: "oldest_age", value: queue["oldest_age"]},
			{key: "last_checkpoint_at", value: queue["last_checkpoint_at"]},
		})

		graph := mapValue(payload["graph"])
		writeSection(builder, "Graph Details", []sectionField{
			{key: "hash", value: graph["hash"]},
			{key: "last_change_at", value: graph["last_change_at"]},
		})

		lastCheck := mapValue(payload["last_check"])
		writeSection(builder, "Last Check", []sectionField{
			{key: "status", value: lastCheck["status"]},
			{key: "at", value: lastCheck["at"]},
			{key: "warnings_open", value: lastCheck["warnings_open"]},
		})

		configSummary := mapValue(payload["config_summary"])
		writeSection(builder, "Config Summary", []sectionField{
			{key: "active_profile", value: configSummary["active_profile"]},
			{key: "watched_paths_count", value: configSummary["watched_paths_count"]},
			{key: "ignored_paths_count", value: configSummary["ignored_paths_count"]},
		})

		tools := mapValue(payload["tools"])
		writeSection(builder, "Tools", []sectionField{
			{key: "enabled", value: tools["enabled"]},
			{key: "last_run", value: tools["last_run"]},
		})

		errorsSection := mapValue(payload["errors"])
		writeSection(builder, "Errors by Process", []sectionField{
			{key: "by_process", value: errorsSection["by_process"]},
		})
	}

	return builder.String()
}

type sectionField struct {
	key   string
	value any
}

func writeSection(builder *strings.Builder, title string, fields []sectionField) {
	fmt.Fprintln(builder)
	fmt.Fprintln(builder, title)
	for _, field := range fields {
		fmt.Fprintf(builder, "  %s: %s\n", field.key, formatValue(field.value))
	}
}

func mapValue(value any) map[string]any {
	if value == nil {
		return map[string]any{}
	}
	if m, ok := value.(map[string]any); ok {
		return m
	}
	return map[string]any{}
}

func stringValue(value any, fallback string) string {
	if value == nil {
		return fallback
	}
	if str, ok := value.(string); ok {
		if str == "" {
			return fallback
		}
		return str
	}
	return formatValue(value)
}

func formatValue(value any) string {
	if value == nil {
		return "n/a"
	}
	switch v := value.(type) {
	case string:
		if v == "" {
			return "n/a"
		}
		return v
	case fmt.Stringer:
		return v.String()
	default:
		return fmt.Sprintf("%v", value)
	}
}
