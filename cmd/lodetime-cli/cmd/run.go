package cmd

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/fatih/color"
	"github.com/spf13/cobra"
	"gopkg.in/yaml.v3"
)

var runCmd = &cobra.Command{
	Use:   "run",
	Short: "Start the LodeTime runtime",
	Run: func(cmd *cobra.Command, args []string) {
		lodeDir := findLodeTimeRoot()
		if lodeDir == "" {
			color.Red("Not in a LodeTime project (no .lodetime/ directory found)")
			os.Exit(1)
		}

		projectRoot := filepath.Dir(lodeDir)

		endpoint := resolveEndpoint(runtimeEndpoint, lodeDir)
		if endpoint != "" {
			if _, err := fetchStatus(endpoint, false, statusTimeout); err == nil {
				color.Green("Runtime already running at %s", endpoint)
				return
			} else if !errors.Is(err, errConnect) {
				color.Red("Runtime detected but status failed: %v", err)
				os.Exit(1)
			}
		}

		engine := resolveEngine(runtimeEngine, lodeDir)
		if engine == "" {
			if inDevcontainer() {
				engine = "devcontainer"
			} else {
				engine = "docker"
			}
		}

		switch engine {
		case "devcontainer":
			mixCmd := exec.Command("mix", "run", "--no-halt")
			mixCmd.Dir = projectRoot
			mixCmd.Stdout = os.Stdout
			mixCmd.Stderr = os.Stderr

			color.Cyan("Starting LodeTime runtime (devcontainer)...")
			if err := mixCmd.Run(); err != nil {
				color.Red("Runtime exited: %v", err)
				os.Exit(1)
			}
			return

		case "docker":
			if !dockerAvailable() {
				color.Red("Docker is required for host runtime boot in Phase 1.")
				os.Exit(1)
			}

			image := "lodetime-runtime:local"
			container := "lodetime-runtime"
			color.Cyan("Building runtime image (%s)...", image)
			buildCmd := exec.Command("docker", "build", "-t", image, projectRoot)
			buildCmd.Stdout = os.Stdout
			buildCmd.Stderr = os.Stderr
			if err := buildCmd.Run(); err != nil {
				color.Red("Docker build failed: %v", err)
				os.Exit(1)
			}

			color.Cyan("Starting runtime container (%s)...", container)
			runCmd := exec.Command(
				"docker", "run",
				"--rm",
				"--name", container,
				"-v", fmt.Sprintf("%s:/app", projectRoot),
				"-w", "/app",
				image,
			)
			runCmd.Stdout = os.Stdout
			runCmd.Stderr = os.Stderr
			if err := runCmd.Run(); err != nil {
				color.Red("Docker run failed: %v", err)
				os.Exit(1)
			}
			return

		default:
			color.Red("Unknown runtime engine: %s", engine)
			os.Exit(1)
		}
	},
}

func inDevcontainer() bool {
	if os.Getenv("DEVCONTAINER") != "" || os.Getenv("REMOTE_CONTAINERS") != "" || os.Getenv("VSCODE_REMOTE_CONTAINERS") != "" || os.Getenv("CODESPACES") != "" {
		return true
	}

	// Weak signal: devcontainer workspace path
	if _, err := os.Stat(filepath.Join(string(filepath.Separator), "workspaces")); err == nil {
		return true
	}

	return false
}

func dockerAvailable() bool {
	_, err := exec.LookPath("docker")
	return err == nil
}

func resolveEngine(flagValue, lodeDir string) string {
	if flagValue != "" {
		return strings.ToLower(flagValue)
	}

	if lodeDir != "" {
		if engine, ok := engineFromConfig(filepath.Join(lodeDir, "config.yaml")); ok {
			return engine
		}
	}

	if configDir, err := os.UserConfigDir(); err == nil {
		configPath := filepath.Join(configDir, "lode", "config.yaml")
		if engine, ok := engineFromConfig(configPath); ok {
			return engine
		}
	}

	return ""
}

func engineFromConfig(path string) (string, bool) {
	data, err := os.ReadFile(path)
	if err != nil {
		return "", false
	}

	var config map[string]any
	if err := yaml.Unmarshal(data, &config); err != nil {
		return "", false
	}

	if runtime, ok := config["runtime"].(map[string]any); ok {
		if engine, ok := runtime["engine"].(string); ok && engine != "" {
			return strings.ToLower(engine), true
		}
	}
	if engine, ok := config["runtime_engine"].(string); ok && engine != "" {
		return strings.ToLower(engine), true
	}
	if engine, ok := config["engine"].(string); ok && engine != "" {
		return strings.ToLower(engine), true
	}

	return "", false
}
