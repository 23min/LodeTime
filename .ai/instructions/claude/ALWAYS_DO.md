# Claude Code-Specific Instructions

Appended to ALWAYS_DO.md when synced to `.claude/rules/`.

## Agent Subagents

Claude Code agents (`.claude/agents/`) are real subagents with their own context windows,
tool restrictions, and preloaded skills. Claude auto-delegates to agents based on their
`description` field when a task matches.

When a task maps to a specific role (e.g., architecture decisions → architect, coding → implementer),
delegate to the appropriate agent. Each agent has role-appropriate tool access and preloaded skills.

See `.ai/docs/handoff-guide.md` for the full handoff chain.

## Co-authorship

Add `Co-authored-by: Claude <noreply@anthropic.com>` trailer to AI-assisted commits.
