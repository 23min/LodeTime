package cmd

import (
	"bufio"
	"fmt"
	"io"
	"net"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestCheckCommandSuccess(t *testing.T) {
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

		response := `{"ok":true,"data":{"mode":"connected"}}`
		_, _ = conn.Write([]byte(response + "\n"))
		done <- nil
	}()

	tempDir := t.TempDir()
	if err := os.MkdirAll(filepath.Join(tempDir, ".lodetime"), 0o755); err != nil {
		t.Fatalf("mkdir .lodetime: %v", err)
	}

	oldWd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	if err := os.Chdir(tempDir); err != nil {
		t.Fatalf("chdir: %v", err)
	}
	defer func() {
		_ = os.Chdir(oldWd)
	}()

	oldEndpoint := runtimeEndpoint
	runtimeEndpoint = listener.Addr().String()
	defer func() {
		runtimeEndpoint = oldEndpoint
	}()

	oldStdout := os.Stdout
	r, w, err := os.Pipe()
	if err != nil {
		t.Fatalf("pipe: %v", err)
	}
	os.Stdout = w

	checkCmd.Run(checkCmd, []string{})

	_ = w.Close()
	os.Stdout = oldStdout

	output, err := io.ReadAll(r)
	if err != nil {
		t.Fatalf("read output: %v", err)
	}
	if !strings.Contains(string(output), "Runtime reachable.") {
		t.Fatalf("expected success output, got: %s", string(output))
	}

	if err := <-done; err != nil {
		t.Fatalf("server error: %v", err)
	}
}
