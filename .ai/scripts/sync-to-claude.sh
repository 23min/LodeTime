#!/bin/bash
# Sync .ai/skills/*.md to .claude/skills/<name>/SKILL.md with YAML frontmatter
# Claude Code expects skills at .claude/skills/<name>/SKILL.md
#
# Source: .ai/ (canonical)
# Target: .claude/skills/, .claude/agents/, .claude/rules/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${SCRIPT_DIR}/../skills"
AGENTS_DIR="${SCRIPT_DIR}/../agents"
INSTRUCTIONS_DIR="${SCRIPT_DIR}/../instructions"
CLAUDE_SKILLS_OUTPUT="${SCRIPT_DIR}/../../.claude/skills"
CLAUDE_AGENTS_OUTPUT="${SCRIPT_DIR}/../../.claude/agents"
CLAUDE_RULES_OUTPUT="${SCRIPT_DIR}/../../.claude/rules"

echo "Syncing to .claude/ for Claude Code..."
echo ""

# ============================================================================
# SYNC SKILLS
# ============================================================================

echo "Syncing skills from ${SKILLS_DIR} to ${CLAUDE_SKILLS_OUTPUT}..."

synced_skills=0

for file in "${SKILLS_DIR}"/*.md; do
  [ -f "$file" ] || continue

  basename=$(basename "$file")
  if [[ "$basename" == "README.md" ]]; then
    continue
  fi

  skill_name=$(basename "$file" .md)
  output_dir="${CLAUDE_SKILLS_OUTPUT}/${skill_name}"
  output="${output_dir}/SKILL.md"

  mkdir -p "${output_dir}"

  # Extract metadata from .ai/ skill format
  description=$(grep "^\*\*Purpose:\*\*" "$file" | sed 's/\*\*Purpose:\*\* //' | head -1)
  if [ -z "$description" ]; then
    description=$(grep "^Focus:" "$file" | sed 's/Focus: //' | head -1)
  fi

  # Generate SKILL.md with YAML frontmatter
  cat > "$output" <<EOF
---
name: ${skill_name}
description: "${description}"
---

$(cat "$file")

---

**Source:** This skill is automatically synced from \`.ai/skills/${skill_name}.md\`

To update, edit the source file and run:
\`\`\`bash
.ai/scripts/sync-to-claude.sh
\`\`\`
EOF

  echo "  + ${skill_name}/SKILL.md"
  synced_skills=$((synced_skills + 1))
done

echo "  Synced ${synced_skills} skills to .claude/skills/"
echo ""

# ============================================================================
# SYNC AGENTS (as markdown files in .claude/agents/)
# ============================================================================

echo "Syncing agents from ${AGENTS_DIR} to ${CLAUDE_AGENTS_OUTPUT}..."

mkdir -p "${CLAUDE_AGENTS_OUTPUT}"

synced_agents=0

for file in "${AGENTS_DIR}"/*.md; do
  [ -f "$file" ] || continue

  basename=$(basename "$file")
  if [[ "$basename" == "README.md" ]]; then
    continue
  fi

  agent_name=$(basename "$file" .md)
  output="${CLAUDE_AGENTS_OUTPUT}/${agent_name}.md"

  # Copy agent file with source footer
  cat > "$output" <<EOF
$(cat "$file")

---

**Source:** This agent is automatically synced from \`.ai/agents/${agent_name}.md\`

To update, edit the source file and run:
\`\`\`bash
.ai/scripts/sync-to-claude.sh
\`\`\`
EOF

  echo "  + ${agent_name}.md"
  synced_agents=$((synced_agents + 1))
done

echo "  Synced ${synced_agents} agents to .claude/agents/"
echo ""

# ============================================================================
# SYNC RULES (instructions → .claude/rules/)
# Claude Code auto-loads .claude/rules/*.md every session
# ============================================================================

echo "Syncing instructions from ${INSTRUCTIONS_DIR} to ${CLAUDE_RULES_OUTPUT}..."

mkdir -p "${CLAUDE_RULES_OUTPUT}"

synced_rules=0

for file in "${INSTRUCTIONS_DIR}"/*.md; do
  [ -f "$file" ] || continue

  basename=$(basename "$file")
  if [[ "$basename" == "README.md" ]]; then
    continue
  fi

  output="${CLAUDE_RULES_OUTPUT}/${basename}"

  # Copy instruction file with source footer
  cat > "$output" <<EOF
$(cat "$file")

---

**Source:** This rule is automatically synced from \`.ai/instructions/${basename}\`

To update, edit the source file and run:
\`\`\`bash
.ai/scripts/sync-to-claude.sh
\`\`\`
EOF

  echo "  + ${basename}"
  synced_rules=$((synced_rules + 1))
done

echo "  Synced ${synced_rules} rules to .claude/rules/"
echo ""

# ============================================================================
# SUMMARY
# ============================================================================

echo ""
echo "Synced ${synced_skills} skills, ${synced_agents} agents, ${synced_rules} rules to .claude/"
