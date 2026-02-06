# Skill: epic-refine

**Maturity:** Production-ready

**Purpose:** Run a human-in-the-loop preflight to confirm epic scope, decisions, and constraints before any milestone specs are drafted.

**Trigger phrases:**
- "Start a new epic"
- "Plan an epic"
- "Refine epic [name]"
- "Define epic scope"

**Use when:**
- A new epic is starting and we need shared context and decisions up front
- The epic is specified but still ambiguous or has open questions

**Do not use when:**
- Milestone-level work (use milestone-draft instead)
- Epic scope is already well-defined and documented

## Inputs
- **Required:**
  - Epic name and slug (maps to work/epics/<epic-slug>/)
  - High-level goal or problem statement
- **Optional:**
  - Known constraints (time, data, platform, teams)
  - Known dependencies (milestones, systems, external services)

## Preconditions / preflight
- Epic concept exists (at least a name and high-level goal)
- Architect agent has context on system architecture

## Process
1) Locate or create the epic folder under work/epics/<epic-slug>/.
2) Review existing epic docs and roadmap entries (if any):
   - work/epics/<epic-slug>/README.md
   - work/epics/epic-roadmap.md
  - ROADMAP.md
3) Run a structured Q&A and capture decisions in a short notes block.
4) Produce an initial milestone outline for the epic.
5) Confirm open questions and owners; do not proceed to drafting milestones until resolved or explicitly deferred.

Structured Q&A (capture answers verbatim):
- Goal: what is the epic trying to enable or fix?
- Success criteria: what observable outcomes signal success?
- In scope: what must be included to claim completion?
- Out of scope: what is explicitly excluded?
- Dependencies: what milestones, systems, or teams must align first?
- Data/contracts: any schema or API changes required?
- Surfaces: which products are affected (API, UI, CLI, Sim, Core)?
- Risks: what could derail or invalidate the plan?
- Testing: how will we validate correctness and regressions?
- Observability: what metrics, logs, or diagnostics are needed?
- Security: any auth, privacy, or access changes?
- Rollout: phased delivery, migration, or compatibility steps?
- Documentation: which docs must change at epic or milestone completion?

Outputs:
- Epic summary (one paragraph) and decisions list
- Open questions list with owners
- Milestone outline (IDs optional but preferred) with rough sequencing
- A clear handoff to milestone-draft for each planned milestone

## Decision points
- **Decision:** Proceed to milestone drafting or defer?
  - **Options:** A) Proceed (all questions resolved), B) Defer (open questions remain)
  - **Default:** B (don't proceed until questions resolved or explicitly deferred)
  - **Record in:** Epic README.md or session log

## Guardrails
- Do not start coding or implementation planning here
- Use milestone-draft once the epic decisions are confirmed
- Capture all decisions in epic documentation (no hidden assumptions)
- All "out of scope" items should be explicit to prevent scope creep

## Common Failure Modes
1. Skipping structured Q&A → Add all questions from template, even if answers are "N/A"
2. Proceeding with unresolved questions → Defer milestone drafting until resolved
3. No written output → Ensure epic README or session log captures all decisions

## Handoff
- **Next skill:** epic-start (to activate epic), then milestone-plan (planner decomposes epic into milestones)

## Related Skills
- **Before this:** N/A (entry point for epic work)
- **After this:** epic-start, milestone-plan
- **Alternatives:** Skip if epic is small enough to be a single milestone

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** architect
