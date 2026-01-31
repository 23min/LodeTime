#!/bin/bash
# Post-start script - runs every time container starts

echo "🔄 LodeTime container started"

# Verify workspace-data is mounted
if [ ! -d /workspace-data ]; then
    echo "⚠️  Warning: /workspace-data not mounted"
    echo "   Run setup-host.sh on your host machine first"
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
