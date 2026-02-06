# Epic: Phase 0 — Manual LodeTime

**Status:** ✅ Complete  
**Wrapped On:** 2026-02-06

## Goal
Validate the Phase 0 manual workflow by defining the minimum `.lodetime/` schema, completing the component/contract catalog, and documenting how humans/AI use it without a runtime.

## Scope
- Define the minimum `.lodetime/` schema and file layout.
- Populate component and contract definitions for the system.
- Document manual usage of `.lodetime/` (no runtime required).
- Define Phase 0 validation expectations (manual or scripted).

## Out of Scope
- Runtime services (watcher, graph server, state server, MCP, etc.).
- Automated validation runner or daemon modes.
- Phase 1+ CLI/runtime capabilities beyond static reads.

## Deliverables
- [x] Minimum `.lodetime/` schema defined and documented.
- [x] `.lodetime/config.yaml` present and aligned with schema expectations.
- [x] `.lodetime/components/*.yaml` catalog complete for Phase 0.
- [x] `.lodetime/contracts/*.yaml` catalog complete for Phase 0.
- [x] Manual usage guidance for humans/AI (no runtime) documented. (`docs/phases/phase-0/USAGE.md`)
- [x] Phase 0 validation guidance documented (manual or scripted). (`docs/phases/phase-0/TESTING.md`)
- [x] Phase 0 validator script + README under `scripts/phase-0/validate-lodetime/`.

## Current Status (from repo)
- [x] `.lodetime/config.yaml` exists. (`.lodetime/config.yaml`)
- [x] Components catalog present (status: planned). (`.lodetime/components/*.yaml`)
- [x] Contracts catalog present. (`.lodetime/contracts/*.yaml`)
- [x] Manual usage guidance captured in architecture notes. (`docs/discussion/2026-02-01-lodetime-architecture-notes.md`)
- [x] Phase 0 definition and success criteria documented. (`docs/phases/IMPLEMENTATION-PHASES.md`)

## Open Questions
- Are any Phase 0 components or contracts still missing or too skeletal?
- Do we want a dedicated Phase 0 usage doc (e.g., `docs/phases/phase-0/USAGE.md`) as suggested in architecture notes?

## Wrap Notes
- Wrapped as complete on 2026-02-06.
- Milestones archived under `work/milestones/completed/`.
- Release notes: `work/epics/releases/phase-0-manual-lodetime.md`.
