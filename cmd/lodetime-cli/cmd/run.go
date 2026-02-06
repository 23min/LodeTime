package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/fatih/color"
	"github.com/spf13/cobra"
)

var runCmd = &cobra.Command{
	Use:   "run",
	Short: "Start the LodeTime runtime",
	Run: func(cmd *cobra.Command, args []string) {
		root := findLodeTimeRoot()
		if root == "" {
			color.Red("Not in a LodeTime project (no .lodetime/ directory found)")
			os.Exit(1)
		}

	if inDevcontainer() {
		mixCmd := exec.Command("mix", "run", "--no-halt")
		mixCmd.Dir = root
		mixCmd.Stdout = os.Stdout
		mixCmd.Stderr = os.Stderr

		color.Cyan("Starting LodeTime runtime (devcontainer)...")
		if err := mixCmd.Run(); err != nil {
			color.Red("Runtime exited: %v", err)
			os.Exit(1)
		}
		return
	}

	if !dockerAvailable() {
		color.Red("Docker is required for host runtime boot in Phase 1.")
		os.Exit(1)
	}

	image := "lodetime-runtime:local"
	container := "lodetime-runtime"
	color.Cyan("Building runtime image (%s)...", image)
	buildCmd := exec.Command("docker", "build", "-t", image, root)
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
		"-v", fmt.Sprintf("%s:/app", root),
		"-w", "/app",
		image,
	)
	runCmd.Stdout = os.Stdout
	runCmd.Stderr = os.Stderr
	if err := runCmd.Run(); err != nil {
		color.Red("Docker run failed: %v", err)
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

func init() {
	rootCmd.AddCommand(runCmd)
	rootCmd.Flags().String("endpoint", "", "runtime endpoint override (future)")
	rootCmd.Flags().String("engine", "", "runtime engine override (future)")
	rootCmd.Flags().Bool("auto", true, "auto-detect runtime environment")
	_ = rootCmd.Flags().MarkHidden("endpoint")
	_ = rootCmd.Flags().MarkHidden("engine")
	_ = rootCmd.Flags().MarkHidden("auto")

	rootCmd.SetHelpTemplate(fmt.Sprintf("%s\n", rootCmd.HelpTemplate()))
}
