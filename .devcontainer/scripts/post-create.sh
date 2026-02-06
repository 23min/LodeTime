#!/bin/bash
# Post-create script - runs once after container is created

set -e

echo "🚀 Setting up LodeTime development environment..."

# Setup shells (oh-my-zsh, powerlevel10k, oh-my-posh)
if [ -f /workspace/.devcontainer/scripts/setup-shells.sh ]; then
    echo "🎨 Setting up shells with Powerlevel10k theme..."
    bash /workspace/.devcontainer/scripts/setup-shells.sh
else
    # Fallback: Basic oh-my-zsh installation
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
fi

# Create workspace directories (ensure permissions when running as non-root)
if [ ! -d "/workspace-data" ]; then
  sudo mkdir -p /workspace-data
fi
if [ ! -w "/workspace-data" ]; then
  sudo chown -R "$(id -u):$(id -g)" /workspace-data
fi
mkdir -p /workspace-data/{backups,dropzone,scratch,exports}

# Install Elixir dependencies
cd /workspace
if [ -f mix.exs ]; then
    echo "📦 Installing Elixir dependencies..."
    mix deps.get
fi

set -e

# If this is a Go module directory:
cd /workspace/cmd/lodetime-cli
go mod download
go mod tidy

# Build Go CLI
if [ -f cmd/lodetime-cli/go.mod ]; then
    echo "🔨 Building Go CLI..."
    mkdir -p /workspace/bin
    cd /workspace/cmd/lodetime-cli
    go mod download
    go build -o /workspace/bin/lodetime .
fi

# Create helper scripts
mkdir -p ~/bin

cat > ~/bin/lodetime-backup << 'EOF'
#!/bin/bash
backup "$@"
EOF
chmod +x ~/bin/lodetime-backup

cat > ~/bin/build-cli << 'EOF'
#!/bin/bash
cd /workspace/cmd/lodetime-cli
go build -o /workspace/bin/lodetime .
echo "Built: /workspace/bin/lodetime"
EOF
chmod +x ~/bin/build-cli

echo ""
echo "✅ LodeTime development environment ready!"
echo ""
echo "Quick commands:"
echo "  lt status     - Check project status"
echo "  mt            - Run Elixir tests"
echo "  gobuild       - Build Go CLI"
echo "  backup        - Backup current work"
echo ""

# Sync AI agents and skills to .github/ for VS Code Copilot
if [ -f .ai/scripts/sync-agents.sh ]; then
    echo "🤖 Syncing AI agents and skills..."
    bash .ai/scripts/sync-agents.sh
fi
