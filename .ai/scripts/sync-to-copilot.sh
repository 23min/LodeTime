#!/bin/bash
# Sync .ai/agents/*.md to .github/agents/*.agent.md with YAML frontmatter
# Sync .ai/skills/*.md to .github/skills/*.skill.md
#
# Source: .ai/ (canonical)
# Target: .github/agents/, .github/skills/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="${SCRIPT_DIR}/../agents"
SKILLS_DIR="${SCRIPT_DIR}/../skills"
AGENTS_OUTPUT="${SCRIPT_DIR}/../../.github/agents"
SKILLS_OUTPUT="${SCRIPT_DIR}/../../.github/skills"

echo "Syncing agents and skills..."
echo ""

# ============================================================================
# SYNC AGENTS
# ============================================================================

echo "Syncing agents from ${AGENTS_DIR} to ${AGENTS_OUTPUT}..."

# Create output directory
mkdir -p "${AGENTS_OUTPUT}"

# Track synced files
synced=0

for file in "${AGENTS_DIR}"/*.md; do
  [ -f "$file" ] || continue
  
  basename=$(basename "$file" .md)
  output="${AGENTS_OUTPUT}/${basename}.agent.md"
  
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
  - label: Create Test Plan
    agent: tester
    prompt: Create a test plan with RED/GREEN/REFACTOR steps for this milestone spec.
    send: false"
      ;;
    tester)
      handoffs="handoffs:
  - label: Start Implementation
    agent: implementer
    prompt: Implement against the test plan above using TDD cycles.
    send: false"
      ;;
    implementer)
      handoffs="handoffs:
  - label: Verify Implementation
    agent: tester
    prompt: Verify the implementation passes all tests and meets acceptance criteria.
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
.ai/scripts/sync-to-copilot.sh
\`\`\`
EOF

  echo "  ✓ ${basename}.agent.md"
  synced=$((synced + 1))
done

echo "✓ Synced ${synced} agents to .github/agents/"
echo ""

# ============================================================================
# SYNC SKILLS
# ============================================================================

echo "Syncing skills from ${SKILLS_DIR} to ${SKILLS_OUTPUT}..."

# Create output directory
mkdir -p "${SKILLS_OUTPUT}"

# Track synced files
synced_skills=0

for file in "${SKILLS_DIR}"/*.md; do
  [ -f "$file" ] || continue
  
  # Skip README files
  basename=$(basename "$file")
  if [[ "$basename" == "README.md" ]]; then
    continue
  fi
  
  basename=$(basename "$file" .md)
  output="${SKILLS_OUTPUT}/${basename}.skill.md"
  
  # Skills don't need frontmatter processing, just copy with footer
  cat > "$output" <<EOF
$(cat "$file")

---

**Source:** This skill is automatically synced from [\`.ai/skills/${basename}.md\`](../../.ai/skills/${basename}.md)

To update this skill, edit the source file, and run:
\`\`\`bash
.ai/scripts/sync-to-copilot.sh
\`\`\`
EOF

  echo "  ✓ ${basename}.skill.md"
  synced_skills=$((synced_skills + 1))
done

echo "✓ Synced ${synced_skills} skills to .github/skills/"
echo ""

# ============================================================================
# SUMMARY
# ============================================================================

echo ""
echo "✓ Synced ${synced} agents and ${synced_skills} skills"
echo "  Reload VS Code window to see updates in chat"
