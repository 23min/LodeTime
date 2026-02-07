package cmd

import (
	"bytes"
	"encoding/json"
	"errors"
	"net"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func TestIntegrationStatusConnected(t *testing.T) {
	if os.Getenv("LODE_INTEGRATION") != "1" {
		t.Skip("set LODE_INTEGRATION=1 to run integration tests")
	}
	if _, err := exec.LookPath("mix"); err != nil {
		t.Skip("mix not available")
	}
	if portOpen(defaultEndpoint) {
		t.Skip("runtime already running on 127.0.0.1:9998")
	}

	repoRoot, err := repoRootFromCwd()
	if err != nil {
		t.Fatalf("repo root: %v", err)
	}

	runtimeCmd := exec.Command("mix", "run", "--no-halt")
	runtimeCmd.Dir = repoRoot
	var runtimeOutput bytes.Buffer
	runtimeCmd.Stdout = &runtimeOutput
	runtimeCmd.Stderr = &runtimeOutput

	if err := runtimeCmd.Start(); err != nil {
		t.Fatalf("start runtime: %v", err)
	}
	defer stopProcess(t, runtimeCmd)

	if err := waitForEndpoint(defaultEndpoint, 5*time.Second); err != nil {
		t.Fatalf("runtime not ready: %v\n%s", err, runtimeOutput.String())
	}

	cliCmd := exec.Command("go", "run", ".", "status", "--connected", "--json")
	cliCmd.Dir = filepath.Join(repoRoot, "cmd", "lodetime-cli")
	cliCmd.Env = append(os.Environ(), "LODE_RUNTIME_ENDPOINT="+defaultEndpoint)
	output, err := cliCmd.CombinedOutput()
	if err != nil {
		t.Fatalf("lode status failed: %v\n%s", err, string(output))
	}

	var payload map[string]any
	if err := json.Unmarshal(bytes.TrimSpace(output), &payload); err != nil {
		t.Fatalf("invalid JSON output: %v\n%s", err, string(output))
	}
	if payload["mode"] != "connected" {
		t.Fatalf("expected mode connected, got %v", payload["mode"])
	}
	graph, ok := payload["graph"].(map[string]any)
	if !ok {
		t.Fatalf("expected graph payload, got %v", payload["graph"])
	}
	if !numberGreaterThanZero(graph["component_count"]) {
		t.Fatalf("expected component_count > 0, got %v", graph["component_count"])
	}
	if !numberGreaterThanZero(graph["contract_count"]) {
		t.Fatalf("expected contract_count > 0, got %v", graph["contract_count"])
	}
}

func repoRootFromCwd() (string, error) {
	cwd, err := os.Getwd()
	if err != nil {
		return "", err
	}

	current := cwd
	for {
		if _, err := os.Stat(filepath.Join(current, ".lodetime")); err == nil {
			return current, nil
		}
		parent := filepath.Dir(current)
		if parent == current {
			return "", errors.New(".lodetime not found")
		}
		current = parent
	}
}

func portOpen(endpoint string) bool {
	conn, err := net.DialTimeout("tcp", endpoint, 150*time.Millisecond)
	if err != nil {
		return false
	}
	_ = conn.Close()
	return true
}

func waitForEndpoint(endpoint string, timeout time.Duration) error {
	deadline := time.Now().Add(timeout)
	for time.Now().Before(deadline) {
		conn, err := net.DialTimeout("tcp", endpoint, 150*time.Millisecond)
		if err == nil {
			_ = conn.Close()
			return nil
		}
		time.Sleep(150 * time.Millisecond)
	}
	return errors.New("timeout waiting for endpoint")
}

func stopProcess(t *testing.T, cmd *exec.Cmd) {
	if cmd.Process == nil {
		return
	}

	_ = cmd.Process.Signal(os.Interrupt)
	done := make(chan error, 1)
	go func() {
		done <- cmd.Wait()
	}()

	select {
	case <-time.After(2 * time.Second):
		_ = cmd.Process.Kill()
		_ = cmd.Wait()
	case <-done:
	}
}

func numberGreaterThanZero(value any) bool {
	switch v := value.(type) {
	case int:
		return v > 0
	case int64:
		return v > 0
	case float64:
		return v > 0
	case string:
		return strings.TrimSpace(v) != "" && v != "0"
	default:
		return false
	}
}
