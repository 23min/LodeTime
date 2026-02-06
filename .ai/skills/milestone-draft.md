# Skill: milestone-draft

**Maturity:** Production-ready

**Purpose:** Draft milestone specification documents after milestone planning is complete.

**Trigger phrases:**
- "Draft milestone [ID]"
- "Create milestone spec for [ID]"
- "Write milestone specification"

**Use when:**
- The epic is refined and milestones are planned
- The milestone does not yet exist, or needs a full rewrite to align with the guide

**Do not use when:**
- Epic not yet refined (run epic-refine first)
- Milestone plan does not exist (run milestone-plan first)
- Milestone already exists and is current (use milestone-start instead)

## Inputs
- **Required:**
  - Epic slug and context
  - Milestone ID and title
- **Required (from planner):**
  - Milestone plan or outline
- **Optional:**
  - Dependencies and target statement
  - Any decisions or constraints captured during epic-refine

## Preconditions / preflight
- Epic context exists (epic-refine completed)
- Milestone ID assigned and unique
- Milestone plan exists in `work/epics/<epic-slug>/README.md`

## Guardrails
- Follow docs/development/milestone-documentation-guide.md
- Follow docs/development/milestone-rules-quick-ref.md
- No time estimates
- Diagrams must use Mermaid

## Process:
1) Ensure epic context and milestone plan exist. If missing, run epic-refine and milestone-plan first.
2) Ensure required directories exist (create if missing):
   - `work/milestones/`
3) Create or update the milestone spec under `work/milestones/<milestone-id>.md` (e.g., `work/milestones/M-03.10.md`).
4) Populate required sections with testable acceptance criteria and explicit scope boundaries.
5) Include a TDD-ready implementation plan that calls out RED -> GREEN -> REFACTOR.
   - **Optional:** Use @plan as subagent to decompose complex implementation phases into tactical steps
   - @plan excels at breaking down "how to implement" into granular TDD cycles
6) Add or update references in:
   - work/epics/epic-roadmap.md (epic status and milestone list)
   - ROADMAP.md (high-level status)
   - work/epics/<epic-slug>/README.md (if it lists milestones)

Outputs:
- A complete milestone spec in `work/milestones/<milestone-id>.md`
- Clear dependencies and success criteria
- TDD-ready implementation phases and test plan
- Updated epic roadmap and ROADMAP.md

## Decision points
- **Decision:** Milestone scope boundaries
  - **Options:** Define what's in vs out of scope
  - **Default:** N/A (must be explicitly defined)
  - **Record in:** Milestone spec (Scope section)

## Common Failure Modes
1. Missing epic context → Run epic-refine first
2. Vague acceptance criteria → Make them testable and measurable
3. Time estimates included → Remove all time/effort estimates
4. ASCII diagrams → Use Mermaid instead

## Handoff
- **Next skill:** milestone-start (when ready to begin implementation)

## Related Skills
- **Before this:** epic-refine (provides epic context), milestone-plan (provides milestone breakdown)
- **After this:** milestone-start (executes the spec)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** documenter

**Notes:**
- Do not start implementation in this skill
- Use milestone-start when the milestone is ready to begin
