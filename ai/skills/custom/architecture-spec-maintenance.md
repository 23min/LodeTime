# Skill: architecture-spec-maintenance

**Maturity:** Beta

**Purpose:** Maintain LodeTime architecture specs as the source of truth.

**Trigger phrases:**
- "Update architecture spec"
- "Change component specs"
- "Align .lodetime with code"

**Use when:**
- Adding or changing components/contracts in `.lodetime/`
- Aligning architecture specs with implemented behavior

**Do not use when:**
- Pure code changes with no architecture impact
- Phase progression updates (use phase-progress)

## Inputs
- **Required:**
  - Component or contract name(s)
  - Desired change summary
- **Optional:**
  - Related milestone/epic ID
  - Known constraints or dependencies

## Preconditions / preflight
- `.lodetime/` exists and is readable
- Related docs in `docs/design/` have been reviewed (if relevant)

## Process
1) Locate the relevant spec(s):
   - `.lodetime/config.yaml`
   - `.lodetime/components/<component>.yaml`
   - `.lodetime/contracts/<contract>.yaml`
2) Update specs to match the intended behavior and dependencies.
3) If dependencies change, update ordering in `.lodetime/config.yaml`.
4) If behavior changes, ensure docs/design references remain accurate.
5) Record changes in the milestone tracking doc (if applicable).

## Outputs
- Updated `.lodetime/` specs reflecting current architecture
- Dependencies and ordering aligned
- Related docs updated when necessary

## Guardrails
- `.lodetime/` is the source of truth; don’t contradict it in docs
- Keep changes minimal and explicit
- If implementation is unclear, escalate to architect

## Handoff
- **Next skill:** milestone-start or red-green-refactor (if implementation follows)

---

**Version:** 1.0.0  
**Last Updated:** 2026-02-01

**Agent:** architect (or planner when decomposing)
