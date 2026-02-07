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
# SYNC AGENTS (.ai/agents/*.md → .claude/agents/<name>.md with YAML frontmatter)
# Claude Code uses agents as subagents with own context, tools, and system prompt.
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

  # Claude Code description: tells Claude WHEN to delegate to this agent.
  # Must be directive (not just what the agent does, but when to use it).
  case "$agent_name" in
    architect)
      description="Architectural design and epic scoping specialist. Use when planning features, creating epics, making design tradeoffs, or defining system boundaries."
      ;;
    planner)
      description="Milestone planning specialist. Use when breaking epics into milestones, sequencing work, or analyzing dependencies."
      ;;
    documenter)
      description="Documentation and specification specialist. Use when drafting milestone specs, writing release notes, updating roadmaps, or creating tracking docs."
      ;;
    implementer)
      description="Coding specialist for precise, minimal-risk changes. Use when implementing milestone requirements, writing code, or following TDD cycles."
      ;;
    tester)
      description="Test planning and TDD specialist. Use when defining test plans, creating RED/GREEN/REFACTOR steps, or validating test coverage."
      ;;
    deployer)
      description="Infrastructure and release specialist. Use when deploying changes, managing environments, or executing release procedures."
      ;;
    maintainer)
      description="AI framework maintenance specialist. Use when updating .ai/ framework files, reviewing skills/agents, or improving development workflows."
      ;;
    *)
      # Fallback: use Focus: line from the agent definition
      description=$(grep "^Focus:" "$file" | sed 's/Focus: //' | head -1)
      ;;
  esac

  # Extract skills from **Key Skills:** line
  skills_line=$(grep "^\*\*Key Skills:\*\*" "$file" | sed 's/\*\*Key Skills:\*\* //' | head -1)
  skills_yaml=""
  if [ -n "$skills_line" ]; then
    skills_yaml="skills:"
    IFS=',' read -ra SKILL_ARRAY <<< "$skills_line"
    for skill in "${SKILL_ARRAY[@]}"; do
      skill=$(echo "$skill" | xargs)  # trim whitespace
      skills_yaml="${skills_yaml}
  - ${skill}"
    done
  fi

  # Determine tools by agent role
  case "$agent_name" in
    architect|planner)
      tools="Read, Glob, Grep, WebFetch, WebSearch"
      ;;
    implementer)
      tools="Read, Edit, Write, Bash, Glob, Grep"
      ;;
    tester)
      tools="Read, Edit, Write, Bash, Glob, Grep"
      ;;
    documenter)
      tools="Read, Edit, Write, Glob, Grep"
      ;;
    deployer)
      tools="Read, Edit, Write, Bash, Glob, Grep"
      ;;
    maintainer)
      tools="Read, Edit, Write, Glob, Grep"
      ;;
    *)
      tools="Read, Glob, Grep"
      ;;
  esac

  # Generate agent file with YAML frontmatter + body as system prompt
  cat > "$output" <<EOF
---
name: ${agent_name}
description: "${description}"
tools: ${tools}
model: inherit
${skills_yaml}
---

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

  # Copy instruction file, append Claude-specific override if it exists, add source footer
  override="${INSTRUCTIONS_DIR}/claude/${basename}"

  {
    cat "$file"
    if [ -f "$override" ]; then
      echo ""
      echo "---"
      echo ""
      cat "$override"
    fi
    cat <<FOOTER

---

**Source:** This rule is automatically synced from \`.ai/instructions/${basename}\`

To update, edit the source file and run:
\`\`\`bash
.ai/scripts/sync-to-claude.sh
\`\`\`
FOOTER
  } > "$output"

  echo "  + ${basename}"
  synced_rules=$((synced_rules + 1))
done

echo "  Synced ${synced_rules} rules to .claude/rules/"
echo ""

# ============================================================================
# SUMMARY
# ============================================================================

echo ""
echo "Synced ${synced_skills} skills, ${synced_agents} agents, and ${synced_rules} rules to .claude/"
