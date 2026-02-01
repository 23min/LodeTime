# Skill: component-refine

**Maturity:** Beta

**Purpose:** Refine a single component’s spec and contract definitions before implementation.

**Trigger phrases:**
- "Refine component [name]"
- "Update component spec"
- "Add contract for [component]"

**Use when:**
- Clarifying a component’s responsibilities and interfaces
- Adding or adjusting contracts before coding

**Do not use when:**
- You’re already implementing (use milestone-start)
- Only updating documentation prose

## Inputs
- **Required:**
  - Component name
  - Intended responsibilities
- **Optional:**
  - Dependencies
  - Example inputs/outputs

## Preconditions / preflight
- `.lodetime/components/` exists
- Related contract files are identifiable

## Process
1) Open `.lodetime/components/<component>.yaml` (or create if missing).
2) Define responsibilities, inputs/outputs, and dependencies.
3) Update `.lodetime/contracts/<contract>.yaml` to match the interface.
4) Ensure `.lodetime/config.yaml` includes the component and dependencies.
5) Add a short note to the relevant milestone tracking doc (if applicable).

## Outputs
- Updated component spec and contract definitions
- Dependencies captured in `.lodetime/config.yaml`

## Guardrails
- Keep component responsibilities narrow and testable
- Escalate to architect if the component affects system boundaries

## Handoff
- **Next skill:** milestone-draft (to formalize work) or milestone-start (if already scoped)

---

**Version:** 1.0.0  
**Last Updated:** 2026-02-01

**Agent:** planner (with architect oversight)
