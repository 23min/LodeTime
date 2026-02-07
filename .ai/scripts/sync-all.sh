#!/bin/bash
# Sync .ai/ (canonical source) to all AI assistant targets
#
# Targets:
#   .github/agents/, .github/skills/  (GitHub Copilot)
#   .claude/skills/, .claude/agents/   (Claude Code)
#
# To add a new target (e.g., Gemini), create sync-to-<target>.sh
# and call it from this script.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "====================================="
echo "  AI Framework Sync"
echo "  Source: .ai/ (canonical)"
echo "====================================="
echo ""

# Sync to GitHub Copilot (.github/)
echo "--- GitHub Copilot ---"
bash "${SCRIPT_DIR}/sync-to-copilot.sh"
echo ""

# Sync to Claude Code (.claude/)
echo "--- Claude Code ---"
bash "${SCRIPT_DIR}/sync-to-claude.sh"
echo ""

echo "====================================="
echo "  All targets synced"
echo "====================================="
