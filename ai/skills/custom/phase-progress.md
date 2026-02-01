# Skill: phase-progress

**Maturity:** Beta

**Purpose:** Manually update phase status when explicitly requested.

**Trigger phrases:**
- "We are done with phase 0"
- "Start phase 1"
- "Move to phase [N]"

**Use when:**
- The user explicitly declares a phase transition

**Do not use when:**
- Regular milestone or epic work
- Phase status is uncertain or disputed

## Inputs
- **Required:**
  - Phase number/name
  - New status (e.g., Current, Complete, Pending)
- **Optional:**
  - Summary of completed epics/milestones
  - Date of change

## Preconditions / preflight
- `docs/phases/IMPLEMENTATION-PHASES.md` exists

## Process
1) Confirm the requested phase change with the user.
2) Update `docs/phases/IMPLEMENTATION-PHASES.md`:
   - Mark the prior phase as complete (if applicable)
   - Mark the new phase as current
   - Add a short summary of completed epics/milestones if provided
3) If README references the current phase, update it to match.

## Outputs
- Phase status updated in `docs/phases/IMPLEMENTATION-PHASES.md`
- Consistent current phase in README (if applicable)

## Guardrails
- Never infer phase changes automatically
- Only update when the user explicitly requests

## Handoff
- **Next skill:** None (manual update only)

---

**Version:** 1.0.0  
**Last Updated:** 2026-02-01

**Agent:** architect
