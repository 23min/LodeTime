# Skill: epic-start

**Maturity:** Production-ready

**Purpose:** Initialize or confirm epic context before milestone planning or work begins.

**Trigger phrases:**
- "Start epic [name]"
- "Begin epic [name]"
- "Initialize epic context"
- "Resume epic [name]"

**Use when:**
- Starting work on a new epic
- Returning to an epic after time away and context is unclear
- Before executing first milestone in an epic

**Do not use when:**
- Epic not yet refined (use epic-refine first)
- Working on standalone milestone (not part of an epic)

## Inputs
- **Required:**
  - Epic name and slug
- **Optional:**
  - Target branch strategy (epic integration or mainline)

## Preconditions / preflight
- Epic has been refined (epic-refine completed)
- Epic spec exists in `work/epics/<epic-slug>/README.md`
- Not already in `work/epics/active/` (if resuming, skip this skill)

## Process:
0) Ensure required directories exist (create if missing):
   - `work/epics/`
   - `work/epics/active/`
1) Verify epic has been refined in `work/epics/<epic-slug>/README.md`
2) Move (or copy) epic spec to `work/epics/active/<epic-slug>.md` to signal active work
3) Review and update roadmaps:
   - `ROADMAP.md` (high-level status)
   - `work/epics/epic-roadmap.md` (detailed technical view)
4) Confirm or create epic integration branch per docs/development/branching-strategy.md
5) Summarize epic scope and any existing milestone outline from epic spec
6) Ready to hand off to planner for milestone-plan

Outputs:
- Epic moved from architecture (planning) to epics/active (execution)
- Roadmaps updated to reflect epic in progress
- Epic context summary
- Confirmed branch plan
- Ready for milestone planning

## Decision points
- **Decision:** Branch strategy
  - **Options:** A) Epic integration branch, B) Work directly from main
  - **Default:** A (epic integration branch) for multi-milestone epics
  - **Record in:** Epic README or session log

## Guardrails
- Ensure epic docs exist before proceeding
- Confirm branch strategy aligns with docs/development/branching-strategy.md
- Don't skip epic context review (prevents misaligned work)

## Common Failure Modes
1. Missing epic docs → Run epic-refine first
2. Unclear which milestone to start → Review epic-roadmap.md for sequencing
3. Wrong branch → Verify branching strategy before creating milestone branch

## Handoff
- **Next skill:** milestone-plan (planner decomposes epic into sequenced milestones)

## Related Skills
- **Before this:** epic-refine (creates epic context)
- **After this:** milestone-plan (execute specific milestone)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** architect
