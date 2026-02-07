package cmd

import (
	"errors"
	"fmt"
	"os"
	"time"

	"github.com/spf13/cobra"
)

var checkCmd = &cobra.Command{
	Use:   "check",
	Short: "Check runtime health",
	Run: func(cmd *cobra.Command, args []string) {
		lodeDir := findLodeTimeRoot()
		if lodeDir == "" {
			fmt.Fprintln(os.Stderr, "Not in a LodeTime project (no .lodetime/ directory found)")
			os.Exit(1)
		}

		endpoint := resolveEndpoint(runtimeEndpoint, lodeDir)
		_, err := fetchStatus(endpoint, false, time.Second)
		if err != nil {
			if errors.Is(err, errConnect) {
				fmt.Fprintln(os.Stderr, "Runtime not reachable:", err)
			} else {
				fmt.Fprintln(os.Stderr, "Runtime check failed:", err)
			}
			os.Exit(1)
		}

		fmt.Println("Runtime reachable.")
	},
}
