# Copilot-Specific Instructions

Appended to ALWAYS_DO.md when synced to `.github/copilot-instructions.md`.

## Subagent Handoffs

- Use `runSubagent` tool to spawn fresh agent context for role transitions
- Provide concise context summary (max 500 tokens) — avoid full state transfer
- Focus handoff on next-action requirements
- For complex workflows (architect → planner → documenter → implementer), use subagents with focused context summaries

## Long Session Protocol

For conversations >20 exchanges or when context seems stale:

1. **Proactively suggest context refresh** when:
   - User asks about something covered earlier
   - You notice potential context drift
   - Before starting new major work (epic/milestone)

2. **Refresh by using context-refresh skill:**
   - Re-read `.ai/instructions/ALWAYS_DO.md`
   - Re-read active agent definition
   - Check active epic/milestone docs
   - Confirm current state with user

3. **User can trigger refresh anytime** by saying:
   - "Refresh context"
   - "Reload instructions"
   - "What's my current state?"

## Co-authorship

Add `Co-authored-by: GitHub Copilot` trailer to AI-assisted commits.
