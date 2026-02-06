#!/bin/bash
# Setup script for oh-my-zsh and oh-my-posh with Powerlevel10k theme

set -e

# Detect workspace directory from script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "Setting up shells with Powerlevel10k theme..."
echo "Workspace detected: $WORKSPACE_DIR"

# Setup Powerlevel10k for zsh (oh-my-zsh)
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Powerlevel10k for zsh..."
    
    # Clone powerlevel10k theme first
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    fi
    
    # Copy p10k configuration BEFORE creating .zshrc
    if [ -f "$WORKSPACE_DIR/.devcontainer/p10k.zsh" ]; then
        cp "$WORKSPACE_DIR/.devcontainer/p10k.zsh" "$HOME/.p10k.zsh"
        echo "Default p10k configuration applied from $WORKSPACE_DIR"
    else
        echo "Warning: p10k.zsh not found at $WORKSPACE_DIR/.devcontainer/p10k.zsh"
    fi
    
    # Always create/overwrite .zshrc with our complete configuration
    cat > "$HOME/.zshrc" << 'ZSHEOF'
# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme - using Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Disable auto-update prompts
zstyle ':omz:update' mode disabled

# Standard plugins
plugins=(git)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Load p10k configuration (must be at the end)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# LodeTime aliases (if in LodeTime workspace)
if [ -d "/workspace/.lodetime" ] || [ -f "/workspace/mix.exs" ]; then
    alias s='cd /workspace'
    alias sd='cd /workspace-data'
    alias drop='cd /workspace-data/dropzone'
    
    # Elixir aliases
    alias mt='mix test'
    alias mc='mix compile'
    alias mf='mix format'
    alias iex='iex -S mix'
    
    # Go aliases
    alias gocli='cd /workspace/cmd/lodetime-cli'
    alias gobuild='cd /workspace/cmd/lodetime-cli && go build -o /workspace/bin/lodetime .'
    
    # LodeTime CLI
    alias lt='/workspace/bin/lodetime'
    
    # Functions
    backup() {
        local name="${1:-backup}"
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local dest="/workspace-data/backups/${name}_${timestamp}"
        mkdir -p "$dest"
        cp -r /workspace/.lodetime "$dest/"
        cp -r /workspace/lib "$dest/" 2>/dev/null || true
        cp -r /workspace/test "$dest/" 2>/dev/null || true
        cp -r /workspace/cmd "$dest/" 2>/dev/null || true
        echo "Backed up to: $dest"
    }
    
    export-work() {
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local dest="/workspace-data/exports/work_${timestamp}"
        mkdir -p "$dest"
        cd /workspace
        git diff > "$dest/uncommitted.diff" 2>/dev/null || true
        git diff --cached > "$dest/staged.diff" 2>/dev/null || true
        cp -r .lodetime "$dest/"
        echo "Exported to: $dest"
    }
fi
ZSHEOF
    
    echo "Powerlevel10k configured for zsh"
fi

# Setup Powerlevel10k for PowerShell (oh-my-posh)
if command -v oh-my-posh &> /dev/null; then
    echo "Installing Powerlevel10k theme for PowerShell..."
    
    # Create PowerShell profile directory
    mkdir -p "$HOME/.config/powershell"
    
    # Determine which theme to use
    if [ -f "$WORKSPACE_DIR/.devcontainer/omp-theme.json" ]; then
        # Copy custom theme that matches p10k
        cp "$WORKSPACE_DIR/.devcontainer/omp-theme.json" "$HOME/.config/powershell/omp-theme.json"
        OMP_THEME_PATH="\$HOME/.config/powershell/omp-theme.json"
        echo "Custom oh-my-posh theme applied (matching p10k)"
    else
        # Fallback to built-in theme
        OMP_THEME_PATH="\$env:POSH_THEMES_PATH/powerlevel10k_rainbow.omp.json"
        echo "Using default powerlevel10k_rainbow theme"
    fi
    
    # Create PowerShell profile with oh-my-posh and p10k theme
    cat > "$HOME/.config/powershell/Microsoft.PowerShell_profile.ps1" << PSEOF
# Oh-My-Posh Prompt Configuration
# 
# To customize your prompt:
# 1. Browse themes: Get-PoshThemes
# 2. Pick a theme and change the path below
# 3. Or use a URL: oh-my-posh init pwsh --config 'https://...' | Invoke-Expression
#
# Popular themes: powerlevel10k_rainbow, atomic, capr4n, dracula, jandedobbeleer, night-owl

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$OMP_THEME_PATH" | Invoke-Expression
}

# PSReadLine configuration for better command line editing
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}
PSEOF
    
    echo "Powerlevel10k configured for PowerShell"
fi

echo "Shell setup complete!"
echo ""
echo "Default shell: zsh (with Powerlevel10k)"
echo "To use PowerShell: run 'pwsh' in the terminal"
echo ""
echo "Customization:"
echo "  zsh:        Run 'p10k configure' to customize your prompt"
echo "  PowerShell: Run 'Get-PoshThemes' to browse themes, then edit ~/.config/powershell/Microsoft.PowerShell_profile.ps1"
