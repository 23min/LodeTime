# Skill: milestone-plan

**Maturity:** Beta

**Purpose:** Convert an epic into a sequenced milestone plan before any specs are drafted.

**Trigger phrases:**
- "Plan milestones for epic [name]"
- "Break this epic into milestones"
- "Create a milestone plan"

**Use when:**
- Epic is refined and ready to decompose into milestones
- You need clear sequencing before milestone specs

**Do not use when:**
- Milestone specs already exist and only need updates
- The epic is a single milestone (skip to milestone-draft)

## Inputs
- **Required:**
  - Epic slug and summary
  - Decisions/constraints from epic-refine
- **Optional:**
  - Dependencies or ordering constraints
  - Known risk areas

## Preconditions / preflight
- Epic-refine completed
- `work/epics/<epic-slug>/README.md` exists

## Process
1) Review epic README and decisions from epic-refine.
2) Define milestone list (IDs/titles) with short scope boundaries.
3) Sequence milestones and capture dependencies and risks.
4) Draft acceptance-criteria outlines (high-level, not full specs).
5) Write/update a **Milestone Plan** section in `work/epics/<epic-slug>/README.md`:
   - Milestone ID + title
   - Goal/outcome
   - In/Out of scope (short)
   - Dependencies
   - Proposed order
6) Confirm scope/sequence changes with architect if they alter epic intent.

Outputs:
- Milestone plan recorded in `work/epics/<epic-slug>/README.md`
- Clear milestone ordering and dependencies
- Handoff to documenter for milestone-draft

## Decision points
- **Decision:** Split or merge milestones
  - **Options:** A) Split for risk/size, B) Merge for cohesion
  - **Default:** A (split when risk or scope is unclear)
  - **Record in:** Milestone Plan section

## Guardrails
- Do not draft full milestone specs (documenter owns specs)
- Do not change epic scope without architect approval
- Keep the plan high-level (no task lists or implementation detail)
- Outline acceptance criteria only; documenter owns full criteria and test plans

## Common Failure Modes
1. Milestones too granular → Collapse into cohesive deliverables
2. Missing dependencies → Add explicit ordering constraints
3. Plan reads like a spec → Move details to milestone-draft

## Handoff
- **Next skill:** milestone-draft (documenter) for each planned milestone

## Related Skills
- **Before this:** epic-refine, epic-start
- **After this:** milestone-draft

---

**Version:** 1.0.0  
**Last Updated:** 2026-02-03

**Agent:** planner
