#!/bin/bash
# Post-create script - runs once after container is created

set -e

echo "🚀 Setting up LodeTime development environment..."

# Oh My Zsh installation
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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

# Setup shell aliases
cat >> ~/.zshrc << 'EOF'

# LodeTime aliases
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
EOF

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
