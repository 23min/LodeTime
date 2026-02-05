# Skill: context-refresh

**Maturity:** Production-ready

**Purpose:** Reload critical context to maintain accuracy during long sessions or when context seems stale.

**Trigger phrases:**
- "Refresh context"
- "Reload instructions"
- "Reset context"
- "What's my current state?"

**Use when:**
- Long conversation sessions (>20 exchanges)
- After switching between multiple topics
- When AI seems to forget earlier decisions
- Before starting major work (epic/milestone)
- User explicitly requests context refresh

**Do not use when:**
- Session just started
- Context is clearly fresh
- Simple queries that don't require full context

## Inputs
- **Optional:**
  - Specific focus area (e.g., "refresh epic context", "refresh milestone context")

## Preconditions / preflight
- None (can be used anytime)

## Process

### Step 1: Reload Core Instructions

Read these files in order:
1. `.ai/instructions/ALWAYS_DO.md` - Critical rules and guardrails
2. `.ai/instructions/GETTING_STARTED.md` - Workflow overview
3. Current agent file from `.ai/agents/` (if working in specific role)

### Step 2: Reload Active Work Context

If work is in progress:
1. Check `work/epics/active/` for active epics
2. Read current epic spec if applicable
3. Check `work/milestones/tracking/` for active milestone tracking
4. Read current milestone spec if applicable

### Step 3: Confirm Understanding

Provide brief confirmation:
- Current work state (epic/milestone)
- Key constraints from ALWAYS_DO.md
- Active role/agent (if applicable)
- Ready to continue

**Example confirmation:**
```
Context refreshed:
- Working on: Epic "Critical Flow Reporting", Milestone M-cfr-01
- Role: implementer (TDD focus)
- Key rules: Never commit without approval, update PROVENANCE.md
- Status: Ready to continue
```

## Outputs
- Confirmation message with current context summary
- Fresh understanding of project state and constraints

## Session Guardrails
- **Never skip ALWAYS_DO.md** - It contains critical guardrails
- **Always confirm** - Let user know context has been refreshed
- **Be specific** - State what epic/milestone/role is active
- **Stay brief** - Confirmation should be concise (3-5 lines)

## Related Skills
- session-start - Use at beginning of new session
- epic-start - Automatically includes context check
- milestone-start - Automatically includes context check

---

## Notes for AI
This skill helps maintain accuracy during extended conversations by explicitly re-reading key instruction files and project state. When in doubt about context freshness, proactively suggest using this skill.
