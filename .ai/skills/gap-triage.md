# Skill: gap-triage

**Maturity:** Production-ready

**Purpose:** Record gaps discovered during work and decide whether to include now or defer.

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
1) Record the gap in `work/GAPS.md` (project gap log). Optionally add a short note to `ROADMAP.md` only if it affects epic prioritization.
2) Classify: scope gap, design gap, implementation gap, or documentation gap
3) Decide disposition with the user:
   - Include in current milestone (update scope + tests)
   - Defer to a specific milestone (preferred)
   - Defer to a future epic (if broader)
4) If deferred, record the target epic/milestone and rationale
5) If included now, update the milestone spec and tracking doc

## Outputs
- Gap recorded with owner and target
- Milestone scope updated if the gap is pulled in
- Decision documented in tracking doc

## Decision points
- **Decision:** Include now or defer?
  - **Options:** A) Include (expand scope), B) Defer to specific milestone, C) Defer to backlog
  - **Default:** B or C (defer) - strong bias against scope creep
  - **Record in:** Tracking doc and ROADMAP.md
  - **Authority:** [USER] - must confirm scope changes

## Guardrails
- Strong bias toward deferring (prevent scope creep)
- User must approve any scope additions to current milestone
- Record ALL gaps, even if obviously deferred
- Include rationale for defer decisions

## Common Failure Modes
1. Auto-expanding scope → Always defer unless user explicitly approves
2. Not recording gap → Write it down even if "obvious" defer
3. Vague gap description → Be specific about what's missing and impact

## Handoff
- **Next skill:** 
  - If deferred → Continue current work
  - If included → Update milestone spec, add tests, continue implementation

## Related Skills
- **Used during:** Any implementation skill (milestone-start, red-green-refactor)
- **Related:** milestone-draft (if creating new milestone for gap)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** Any (commonly architect or implementer)
