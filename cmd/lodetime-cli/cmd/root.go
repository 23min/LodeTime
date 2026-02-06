package cmd

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/fatih/color"
	"github.com/jedib0t/go-pretty/v6/table"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"gopkg.in/yaml.v3"
)

var (
	cfgFile     string
	verbose     bool
	serverAddr  string
	noColor     bool
	versionInfo struct {
		Version string
		Commit  string
		Date    string
	}
)

// rootCmd represents the base command
var rootCmd = &cobra.Command{
	Use:   "lodetime",
	Short: "LodeTime - A living development companion",
	Long: `LodeTime watches your codebase, understands its architecture,
runs tests continuously, and communicates with you and AI tools.

Use 'lodetime status' to see the current state of your project.`,
}

// Execute runs the root command
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

// SetVersionInfo sets version information from build flags
func SetVersionInfo(version, commit, date string) {
	versionInfo.Version = version
	versionInfo.Commit = commit
	versionInfo.Date = date
}

func init() {
	cobra.OnInitialize(initConfig)

	// Global flags
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is .lodetime/cli.yaml)")
	rootCmd.PersistentFlags().BoolVarP(&verbose, "verbose", "v", false, "verbose output")
	rootCmd.PersistentFlags().StringVar(&serverAddr, "server", "localhost:9998", "server address")
	rootCmd.PersistentFlags().BoolVar(&noColor, "no-color", false, "disable color output")

	// Add subcommands
	rootCmd.AddCommand(versionCmd)
	rootCmd.AddCommand(statusCmd)
	rootCmd.AddCommand(runCmd)
	rootCmd.AddCommand(componentCmd)
	rootCmd.AddCommand(initCmd)
}

func initConfig() {
	if noColor {
		color.NoColor = true
	}

	if cfgFile != "" {
		viper.SetConfigFile(cfgFile)
	} else {
		root := findLodeTimeRoot()
		if root != "" {
			viper.AddConfigPath(root)
			viper.SetConfigName("cli")
			viper.SetConfigType("yaml")
		}
	}

	viper.AutomaticEnv()
	viper.ReadInConfig() // Ignore error if config doesn't exist
}

// findLodeTimeRoot walks up directories to find .lodetime/
func findLodeTimeRoot() string {
	dir, err := os.Getwd()
	if err != nil {
		return ""
	}

	for {
		lodtimePath := filepath.Join(dir, ".lodetime")
		if info, err := os.Stat(lodtimePath); err == nil && info.IsDir() {
			return lodtimePath
		}

		parent := filepath.Dir(dir)
		if parent == dir {
			return ""
		}
		dir = parent
	}
}

// ============================================
// Version Command
// ============================================

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Print version information",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("lodetime %s\n", versionInfo.Version)
		if verbose {
			fmt.Printf("  commit: %s\n", versionInfo.Commit)
			fmt.Printf("  built:  %s\n", versionInfo.Date)
		}
	},
}

// ============================================
// Status Command
// ============================================

var statusCmd = &cobra.Command{
	Use:   "status",
	Short: "Show project status",
	Long:  `Shows the current status of your LodeTime project including components and health.`,
	Run: func(cmd *cobra.Command, args []string) {
		root := findLodeTimeRoot()
		if root == "" {
			color.Red("Not in a LodeTime project (no .lodetime/ directory found)")
			os.Exit(1)
		}

		// Load config (static mode - no server needed)
		configPath := filepath.Join(root, "config.yaml")
		data, err := os.ReadFile(configPath)
		if err != nil {
			color.Red("Error reading config: %v", err)
			os.Exit(1)
		}

		var config map[string]interface{}
		if err := yaml.Unmarshal(data, &config); err != nil {
			color.Red("Error parsing config: %v", err)
			os.Exit(1)
		}

		// Display status
		color.Cyan("LodeTime Status")
		fmt.Println()

		projectName := config["project"]
		if projectName != nil {
			fmt.Printf("Project: %s\n", projectName)
		}

		phase := config["current_phase"]
		if phase != nil {
			fmt.Printf("Phase: %v\n", phase)
		}

		// Load and display components
		componentsDir := filepath.Join(root, "components")
		components, err := loadComponents(componentsDir)
		if err == nil && len(components) > 0 {
			fmt.Println()
			color.Cyan("Components:")
			
			t := table.NewWriter()
			t.SetOutputMirror(os.Stdout)
			t.AppendHeader(table.Row{"ID", "Status", "Dependencies"})
			
			for _, comp := range components {
				status := statusColor(comp.Status)
				deps := ""
				if len(comp.DependsOn) > 0 {
					deps = fmt.Sprintf("%v", comp.DependsOn)
				}
				t.AppendRow(table.Row{comp.ID, status, deps})
			}
			t.Render()
		}

		fmt.Println()
		color.Green("Mode: Static (reading .lodetime/ directly)")
	},
}

type Component struct {
	ID        string   `yaml:"id"`
	Name      string   `yaml:"name"`
	Status    string   `yaml:"status"`
	DependsOn []string `yaml:"depends_on"`
}

func loadComponents(dir string) ([]Component, error) {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return nil, err
	}

	var components []Component
	for _, entry := range entries {
		if entry.IsDir() || filepath.Ext(entry.Name()) != ".yaml" {
			continue
		}

		data, err := os.ReadFile(filepath.Join(dir, entry.Name()))
		if err != nil {
			continue
		}

		var comp Component
		if err := yaml.Unmarshal(data, &comp); err != nil {
			continue
		}
		components = append(components, comp)
	}

	return components, nil
}

func statusColor(status string) string {
	switch status {
	case "implemented":
		return color.GreenString(status)
	case "implementing":
		return color.YellowString(status)
	case "planned":
		return color.CyanString(status)
	case "deprecated":
		return color.RedString(status)
	default:
		return status
	}
}

// ============================================
// Component Command
// ============================================

var componentCmd = &cobra.Command{
	Use:   "component [id]",
	Short: "Show component details",
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		root := findLodeTimeRoot()
		if root == "" {
			color.Red("Not in a LodeTime project")
			os.Exit(1)
		}

		id := args[0]
		compPath := filepath.Join(root, "components", id+".yaml")
		
		data, err := os.ReadFile(compPath)
		if err != nil {
			color.Red("Component not found: %s", id)
			os.Exit(1)
		}

		var comp map[string]interface{}
		if err := yaml.Unmarshal(data, &comp); err != nil {
			color.Red("Error parsing component: %v", err)
			os.Exit(1)
		}

		color.Cyan("Component: %s", id)
		fmt.Println()
		
		// Pretty print the component
		output, _ := yaml.Marshal(comp)
		fmt.Println(string(output))
	},
}

// ============================================
// Init Command
// ============================================

var initCmd = &cobra.Command{
	Use:   "init",
	Short: "Initialize a new LodeTime project",
	Run: func(cmd *cobra.Command, args []string) {
		if _, err := os.Stat(".lodetime"); err == nil {
			color.Yellow(".lodetime/ already exists")
			return
		}

		// Create directory structure
		dirs := []string{
			".lodetime",
			".lodetime/components",
			".lodetime/contracts",
		}

		for _, dir := range dirs {
			if err := os.MkdirAll(dir, 0755); err != nil {
				color.Red("Error creating %s: %v", dir, err)
				os.Exit(1)
			}
		}

		// Create default config
		config := `# LodeTime Configuration
project: my-project
version: "0.1.0"

zones:
  core:
    paths: [src/, lib/]
    tracking: full
  tests:
    paths: [test/]
    tracking: none
`
		if err := os.WriteFile(".lodetime/config.yaml", []byte(config), 0644); err != nil {
			color.Red("Error creating config: %v", err)
			os.Exit(1)
		}

		color.Green("Initialized LodeTime project!")
		fmt.Println()
		fmt.Println("Next steps:")
		fmt.Println("  1. Edit .lodetime/config.yaml")
		fmt.Println("  2. Add components: lodetime add-component <name>")
		fmt.Println("  3. Run: lodetime status")
	},
}
