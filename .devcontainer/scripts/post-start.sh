#!/bin/bash
# Post-start script - runs every time container starts

echo "🔄 LodeTime container started"

# Ensure mounted VS Code extension volume is writable by the remote user
sudo chown -R vscode:vscode /home/vscode/.vscode-server/extensions 2>/dev/null || true

# Ensure common build/cache dirs are writable (named volumes can come up root-owned)
sudo mkdir -p /workspace/_build /workspace/deps 2>/dev/null || true
if [ -d /workspace/_build ] && [ ! -w /workspace/_build ]; then
    sudo chown -R vscode:vscode /workspace/_build 2>/dev/null || true
fi
if [ -d /workspace/deps ] && [ ! -w /workspace/deps ]; then
    sudo chown -R vscode:vscode /workspace/deps 2>/dev/null || true
fi

# Verify workspace-data is mounted
if [ ! -d /workspace-data ]; then
    echo "⚠️  Warning: /workspace-data not mounted"
    echo "   Run setup-host.sh on your host machine first"
else
    # Persist Codex state on the host mount
    mkdir -p /workspace-data/.codex
    sudo chown -R vscode:vscode /workspace-data/.codex 2>/dev/null || true

    # Make git pushes less annoying: auto-load SSH key into ssh-agent.
    # This will prompt for the key passphrase once per container session (first new terminal).
    ZSHRC="$HOME/.zshrc"
    SSH_ADD_MARKER_BEGIN="# >>> lodetime ssh-add >>>"
    if [ -f "$ZSHRC" ] && ! grep -qF "$SSH_ADD_MARKER_BEGIN" "$ZSHRC" 2>/dev/null; then
        cat >> "$ZSHRC" << 'EOF'

# >>> lodetime ssh-add >>>
# If VS Code forwarded an ssh-agent into the container, add the mounted key once per session.
# You may be prompted for the key passphrase the first time after a container restart.
if [ -n "$SSH_AUTH_SOCK" ] && [ -f /workspace-data/.ssh/id_ed25519 ]; then
    ssh-add -l >/dev/null 2>&1 || ssh-add /workspace-data/.ssh/id_ed25519
fi
# <<< lodetime ssh-add <<<
EOF
    fi
fi

# Build CLI if missing
if [ ! -f /workspace/bin/lodetime ] && [ -f /workspace/cmd/lodetime-cli/go.mod ]; then
    echo "Building CLI..."
    cd /workspace/cmd/lodetime-cli
    go build -o /workspace/bin/lodetime . 2>/dev/null || true
fi

# Show status
echo ""
echo "📊 Environment:"
echo "   Elixir: $(elixir --version 2>/dev/null | head -1 || echo 'not found')"
echo "   Go:     $(go version 2>/dev/null | cut -d' ' -f3 || echo 'not found')"
echo "   CLI:    $([ -f /workspace/bin/lodetime ] && echo 'ready' || echo 'not built')"
echo ""
