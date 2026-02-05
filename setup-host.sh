#!/bin/bash
# setup-host.sh - Run this on your HOST machine before starting the devcontainer

set -e

echo "🏠 Setting up LodeTime workspace on host..."

# Detect OS
case "$(uname -s)" in
    Darwin*)    OS="macOS" ;;
    Linux*)     
        if grep -q Microsoft /proc/version 2>/work/null; then
            OS="WSL"
        else
            OS="Linux"
        fi
        ;;
    *)          OS="Unknown" ;;
esac

echo "   Detected: $OS"

# Create workspace directory
WORKSPACE_DIR="$HOME/lodetime-workspace"

if [ -d "$WORKSPACE_DIR" ]; then
    echo "   Workspace already exists: $WORKSPACE_DIR"
else
    echo "   Creating workspace: $WORKSPACE_DIR"
    mkdir -p "$WORKSPACE_DIR"/{backups,dropzone,scratch,exports,chat-sessions}
fi

# Create subdirectories
mkdir -p "$WORKSPACE_DIR"/{backups,dropzone,scratch,exports,chat-sessions}

# WSL-specific: Create Windows-accessible dropzone
if [ "$OS" = "WSL" ]; then
    WIN_HOME=$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/work/null | tr -d '\r')")
    WIN_DROPZONE="$WIN_HOME/lodetime-dropzone"
    
    if [ ! -d "$WIN_DROPZONE" ]; then
        echo "   Creating Windows dropzone: $WIN_DROPZONE"
        mkdir -p "$WIN_DROPZONE"
    fi
    
    # Symlink for easy access
    if [ ! -L "$WORKSPACE_DIR/win-dropzone" ]; then
        ln -sf "$WIN_DROPZONE" "$WORKSPACE_DIR/win-dropzone"
        echo "   Linked Windows dropzone"
    fi
fi

echo ""
echo "✅ Host setup complete!"
echo ""
echo "Workspace: $WORKSPACE_DIR"
echo "  ├── backups/       - Manual backups"
echo "  ├── dropzone/      - File exchange with host"
echo "  ├── scratch/       - Temporary experiments"
echo "  ├── exports/       - Exported work"
echo "  └── chat-sessions/ - Saved conversations"
echo ""
echo "Next steps:"
echo "  1. Open this folder in VS Code"
echo "  2. Click 'Reopen in Container' when prompted"
echo "  3. Run: ./bin/lodetime status"
echo ""
