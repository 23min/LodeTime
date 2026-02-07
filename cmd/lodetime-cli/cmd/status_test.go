package cmd

import (
	"bufio"
	"fmt"
	"net"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func TestFetchStatusParsesJSONL(t *testing.T) {
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("listen: %v", err)
	}
	defer listener.Close()

	done := make(chan error, 1)
	go func() {
		conn, err := listener.Accept()
		if err != nil {
			done <- err
			return
		}
		defer conn.Close()

		reader := bufio.NewReader(conn)
		line, err := reader.ReadString('\n')
		if err != nil {
			done <- err
			return
		}
		if !strings.Contains(line, "\"cmd\":\"status\"") {
			done <- fmt.Errorf("expected status command, got: %s", strings.TrimSpace(line))
			return
		}

		response := `{"ok":true,"data":{"mode":"connected","runtime_state":"running","graph":{"component_count":2,"contract_count":1}}}`
		_, _ = conn.Write([]byte(response + "\n"))
		done <- nil
	}()

	payload, err := fetchStatus(listener.Addr().String(), false, time.Second)
	if err != nil {
		t.Fatalf("fetchStatus error: %v", err)
	}

	if payload["mode"] != "connected" {
		t.Fatalf("expected mode connected, got %v", payload["mode"])
	}

	graph := mapValue(payload["graph"])
	if formatValue(graph["component_count"]) != "2" {
		t.Fatalf("expected component_count 2, got %v", graph["component_count"])
	}
	if formatValue(graph["contract_count"]) != "1" {
		t.Fatalf("expected contract_count 1, got %v", graph["contract_count"])
	}

	if err := <-done; err != nil {
		t.Fatalf("server error: %v", err)
	}
}

func TestBuildOfflineStatus(t *testing.T) {
	tempDir := t.TempDir()
	lodeDir := filepath.Join(tempDir, ".lodetime")
	if err := os.MkdirAll(filepath.Join(lodeDir, "components"), 0o755); err != nil {
		t.Fatalf("mkdir components: %v", err)
	}
	if err := os.MkdirAll(filepath.Join(lodeDir, "contracts"), 0o755); err != nil {
		t.Fatalf("mkdir contracts: %v", err)
	}

	config := `current_phase: 2
zones:
  core:
    paths: [lib/]
  docs:
    paths: [docs/]
triggers:
  file_system:
    ignore: ["_build/**", "deps/**"]
`
	if err := os.WriteFile(filepath.Join(lodeDir, "config.yaml"), []byte(config), 0o644); err != nil {
		t.Fatalf("write config: %v", err)
	}

	if err := os.WriteFile(filepath.Join(lodeDir, "components", "a.yaml"), []byte("id: a\n"), 0o644); err != nil {
		t.Fatalf("write component a: %v", err)
	}
	if err := os.WriteFile(filepath.Join(lodeDir, "components", "b.yaml"), []byte("id: b\n"), 0o644); err != nil {
		t.Fatalf("write component b: %v", err)
	}
	if err := os.WriteFile(filepath.Join(lodeDir, "contracts", "c.yaml"), []byte("id: c\n"), 0o644); err != nil {
		t.Fatalf("write contract c: %v", err)
	}

	payload, err := buildOfflineStatus(lodeDir, true)
	if err != nil {
		t.Fatalf("buildOfflineStatus error: %v", err)
	}

	if payload["mode"] != "offline" {
		t.Fatalf("expected mode offline, got %v", payload["mode"])
	}
	if payload["source"] != "offline" {
		t.Fatalf("expected source offline, got %v", payload["source"])
	}
	if formatValue(payload["phase"]) != "2" {
		t.Fatalf("expected phase 2, got %v", payload["phase"])
	}

	graph := mapValue(payload["graph"])
	if formatValue(graph["component_count"]) != "2" {
		t.Fatalf("expected component_count 2, got %v", graph["component_count"])
	}
	if formatValue(graph["contract_count"]) != "1" {
		t.Fatalf("expected contract_count 1, got %v", graph["contract_count"])
	}

	summary := mapValue(payload["config_summary"])
	if formatValue(summary["watched_paths_count"]) != "2" {
		t.Fatalf("expected watched_paths_count 2, got %v", summary["watched_paths_count"])
	}
	if formatValue(summary["ignored_paths_count"]) != "2" {
		t.Fatalf("expected ignored_paths_count 2, got %v", summary["ignored_paths_count"])
	}
}

func TestRenderStatusHumanConnected(t *testing.T) {
	payload := map[string]any{
		"mode":            "connected",
		"runtime_state":   "running",
		"phase":           1,
		"runtime_version": "0.1.0",
		"graph": map[string]any{
			"component_count": 2,
			"contract_count":  1,
		},
		"last_error": map[string]any{
			"count":        0,
			"last_message": nil,
		},
	}

	output := renderStatusHuman(payload, false, false)
	if !strings.Contains(output, "Mode: connected") {
		t.Fatalf("expected mode line, got: %s", output)
	}
	if !strings.Contains(output, "Runtime State: running") {
		t.Fatalf("expected runtime state line, got: %s", output)
	}
	if !strings.Contains(output, "Phase: 1") {
		t.Fatalf("expected phase line, got: %s", output)
	}
	if !strings.Contains(output, "component_count: 2") {
		t.Fatalf("expected component_count line, got: %s", output)
	}
	if !strings.Contains(output, "contract_count: 1") {
		t.Fatalf("expected contract_count line, got: %s", output)
	}
}

func TestRenderStatusJSONOfflineOmitsRuntimeFields(t *testing.T) {
	payload := map[string]any{
		"mode":            "offline",
		"source":          "offline",
		"runtime_state":   "running",
		"runtime_version": "0.1.0",
		"last_error": map[string]any{
			"count": 1,
		},
		"graph": map[string]any{
			"component_count": 1,
			"contract_count":  1,
		},
	}

	output, err := renderStatusJSON(payload, false, true)
	if err != nil {
		t.Fatalf("renderStatusJSON error: %v", err)
	}
	if strings.Contains(output, "runtime_state") {
		t.Fatalf("expected runtime_state omitted, got: %s", output)
	}
	if strings.Contains(output, "runtime_version") {
		t.Fatalf("expected runtime_version omitted, got: %s", output)
	}
	if strings.Contains(output, "last_error") {
		t.Fatalf("expected last_error omitted, got: %s", output)
	}
}
