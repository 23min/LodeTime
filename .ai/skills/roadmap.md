# Skill: roadmap

**Maturity:** Production-ready

**Purpose:** Maintain the lifecycle of epics between the high-level roadmap and epic architecture docs.

**Trigger phrases:**
- "Update roadmap"
- "Add epic to roadmap"
- "Promote epic [name]"
- "Complete epic in roadmap"

**Use when:**
- Proposing new epics
- Promoting an epic from idea to planned/active
- Closing an epic
- Syncing roadmap status

**Do not use when:**
- Milestone-level updates (use milestone specs instead)
- Individual task tracking

## Inputs
- **Required:**
  - Epic name and slug
  - Desired action (propose, promote, complete)
- **Optional:**
  - Epic intent or goal
  - Milestone count estimate

## Preconditions / preflight
- For promote: epic-refine has been completed
- For complete: epic-wrap has been completed

## Policy
- ROADMAP.md is the authoritative list of proposed and active epics
- work/epics/epic-roadmap.md is the authoritative list of epics with docs
- These two files must stay in sync

## Status flow
- **Proposed:** Only in ROADMAP.md
- **Planned:** Epic folder exists with README.md
- **Active:** Milestones underway
- **Complete:** Epic wrapped and milestones archived

## Process

**1) Proposed epic:**
- Add to ROADMAP.md with intent and rough ordering
- No epic folder required

**2) Promote to Planned/Active:**
- Run epic-refine
- Create work/epics/<epic-slug>/README.md
- Add to work/epics/epic-roadmap.md
- Update ROADMAP.md status

**3) Complete:**
- Run epic-wrap
- Update ROADMAP.md and work/epics/epic-roadmap.md

## Outputs
- Roadmap and epic roadmap in sync
- Clear epic status at each stage
- Chronological ordering maintained

## Decision points
- **Decision:** Conflicting roadmap info
  - **Options:** A) ROADMAP.md wins, B) epic-roadmap.md wins, C) Manual reconciliation
  - **Default:** A (ROADMAP.md is authoritative for status)
  - **Record in:** Update both files to match

## Guardrails
- Two authoritative files must stay synchronized
- Don't skip epic-refine when promoting to Planned
- Don't skip epic-wrap when marking Complete
- Maintain chronological or priority ordering

## Common Failure Modes
1. Files out of sync → Run roadmap skill to reconcile
2. Epic marked Complete without epic-wrap → Run epic-wrap first
3. Proposed epic with docs folder → Promote it properly or remove folder

## Handoff
- **Next skill:**
  - If proposing → epic-refine (when ready to plan)
  - If promoting → epic-start (to begin work)
  - If completing → N/A (epic done)

## Related Skills
- **Before this:** epic-refine (for promote), epic-wrap (for complete)
- **After this:** epic-start (for promoted epics)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** architect
