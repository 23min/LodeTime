# Skill: gap-triage

**Maturity:** Production-ready

**Purpose:** Record gaps discovered during work and decide where they should live (epic/milestone, backlog, or one-off).

**Trigger phrases:**
- "We found a gap"
- "This is missing"
- "Discovered issue: [description]"
- "Unexpected limitation"

**Use when:**
- A missing requirement, design hole, or unexpected limitation is found
- Scope creep is detected during implementation
- New work discovered that wasn't in original spec

**Do not use when:**
- Planned work (use milestone spec instead)
- Bugs in existing code (use bug tracking)
- Requirement is already in scope (use milestone-draft to update the spec)

## Inputs
- **Required:**
  - Gap description
  - Where it was found (file, test, doc)
- **Optional:**
  - Impact and risk assessment
  - Proposed solution

## Preconditions / preflight
- Active milestone or epic work
- Gap is truly out-of-scope (not covered by current ACs)

## Process
1) Confirm the item is truly out-of-scope for the current milestone.
   - If in-scope → update the milestone spec via milestone-draft (documenter) and stop.
2) Record the gap in the backlog section of EPIC_ROADMAP_PATH (see `ai/instructions/PROJECT_PATHS.md`)
3) Classify: scope gap, design gap, implementation gap, or documentation gap
4) Review with architect or planner to determine the right home:
   - Include in current milestone (rare; requires architect + documenter approval)
   - Plan into a specific epic/milestone (preferred)
   - Defer to backlog (not yet ready to plan)
   - Treat as a one-off change on a separate branch (explicit user decision)
5) If included now, coordinate with documenter to update the milestone spec and tracking doc
6) If planned into an epic/milestone, record the target and rationale
7) If one-off, create a separate branch and log the work in PROVENANCE.md

## Outputs
- Gap recorded with owner and target
- Decision documented in tracking doc and/or EPIC_ROADMAP_PATH
- One-off work logged in PROVENANCE.md (if chosen)

## Decision points
- **Decision:** Where should the gap live?
  - **Options:** A) Include in current milestone (rare), B) Plan into epic/milestone, C) Defer to backlog, D) One-off change on separate branch
  - **Default:** C (defer) unless architect/planner agree on placement
  - **Record in:** Tracking doc and EPIC_ROADMAP_PATH
  - **Authority:** Architect/planner decide placement; [USER] decides one-off; documenter approves spec updates

## Guardrails
- Strong bias toward deferring (prevent scope creep)
- Do not pull gaps into the current milestone without explicit architect + documenter approval
- Record ALL gaps, even if obviously deferred
- Include rationale for defer decisions

## Common Failure Modes
1. Auto-expanding scope → Always defer unless architect + documenter approve
2. Not recording gap → Write it down even if "obvious" defer
3. Vague gap description → Be specific about what's missing and impact

## Handoff
- **Next skill:** 
  - If included now → update milestone spec (milestone-draft) and continue implementation
  - If planned into epic/milestone → milestone-plan or milestone-draft (as appropriate)
  - If one-off → follow normal implementation workflow on a separate branch

## Related Skills
- **Used during:** Any implementation skill (milestone-start, red-green-refactor)
- **Related:** milestone-draft (if creating new milestone for gap)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** Any (commonly architect or implementer)
