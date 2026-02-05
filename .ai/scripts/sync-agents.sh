#!/bin/bash
# Sync .ai/agents/*.md to .github/agents/*.agent.md with YAML frontmatter

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="${SCRIPT_DIR}/../agents"
OUTPUT_DIR="${SCRIPT_DIR}/../../.github/agents"

echo "Syncing agents from ${AGENTS_DIR} to ${OUTPUT_DIR}..."

# Create output directory
mkdir -p "${OUTPUT_DIR}"

# Track synced files
synced=0

for file in "${AGENTS_DIR}"/*.md; do
  [ -f "$file" ] || continue
  
  basename=$(basename "$file" .md)
  output="${OUTPUT_DIR}/${basename}.agent.md"
  
  # Extract metadata
  name=$(grep "^# Agent:" "$file" | sed 's/# Agent: //' | xargs)
  description=$(grep "^Focus:" "$file" | sed 's/Focus: //' | xargs)
  
  # Determine tools by agent role
  case "$basename" in
    planner|architect)
      tools="['search', 'fetch', 'usages', 'githubRepo']"
      ;;
    implementer)
      tools="['*']"
      ;;
    tester)
      tools="['search', 'fetch', 'usages', 'terminal', 'grep']"
      ;;
    documenter)
      tools="['search', 'fetch', 'usages', 'edit']"
      ;;
    deployer)
      tools="['terminal', 'docker', 'fetch', 'edit']"
      ;;
    maintainer)
      tools="['search', 'fetch', 'usages', 'grep', 'edit']"
      ;;
    *)
      tools="['search', 'fetch']"
      ;;
  esac
  
  # Determine handoffs
  handoffs=""
  case "$basename" in
    architect)
      handoffs="handoffs:
  - label: Create Milestone Plan
    agent: planner
    prompt: Create a milestone plan based on the epic design above.
    send: false"
      ;;
    planner)
      handoffs="handoffs:
  - label: Draft Milestone Specs
    agent: documenter
    prompt: Create milestone specifications based on the plan above.
    send: false"
      ;;
    documenter)
      handoffs="handoffs:
  - label: Start Implementation
    agent: implementer
    prompt: Begin implementing the first milestone.
    send: false"
      ;;
    implementer)
      handoffs="handoffs:
  - label: Review Code
    agent: tester
    prompt: Review and test the implementation above.
    send: false"
      ;;
  esac
  
  # Generate .agent.md file
  cat > "$output" <<EOF
---
description: ${description}
name: ${name}
tools: ${tools}
model: Claude Sonnet 4
${handoffs}
---

$(cat "$file")

---

**Source:** This agent is automatically synced from [\`.ai/agents/${basename}.md\`](../../.ai/agents/${basename}.md)

To update this agent, edit the source file and run:
\`\`\`bash
./.ai/scripts/sync-agents.sh
\`\`\`
EOF

  echo "  ✓ ${basename}.agent.md"
  synced=$((synced + 1))
done

echo ""
echo "✓ Synced ${synced} agents to .github/agents/"
echo "  Reload VS Code window to see updated agents in chat dropdown"
