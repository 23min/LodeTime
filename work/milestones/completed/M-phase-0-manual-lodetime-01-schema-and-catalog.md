# M-phase-0-manual-lodetime-01-schema-and-catalog: Phase 0 Schema and Catalog

**Status:** ✅ Complete  
**Epic:** phase-0-manual-lodetime  
**Date Completed:** 2026-02-06 (retroactive documentation)

## Goal
Define the minimum `.lodetime/` schema and populate the Phase 0 component and contract catalogs so humans/AI can use it without a runtime.

## Scope
In scope:
- `.lodetime/config.yaml` exists and reflects Phase 0 expectations.
- `.lodetime/components/*.yaml` catalog exists with required fields.
- `.lodetime/contracts/*.yaml` catalog exists with required fields.
- Phase 0 definition and success criteria documented.

Out of scope:
- Runtime services or Phase 1+ execution.
- Automated runtime validation.

## Acceptance Criteria
- `.lodetime/config.yaml` is present and includes Phase 0 basics (project, schema_version, current_phase, zones).
- Each component file has `id`, `name`, `status`, `location`, and `depends_on`.
- Each contract file has `id`, `name`, and `description` (plus any defined schema fields).
- Phase 0 goals and success criteria are documented in `docs/phases/IMPLEMENTATION-PHASES.md`.

## Implementation Plan (Retroactive)
- Identify minimum schema fields for config/components/contracts.
- Populate `.lodetime/components/*.yaml` and `.lodetime/contracts/*.yaml`.
- Confirm Phase 0 goal and success criteria doc.

## Test Plan
- Manual review of `.lodetime/` structure and required fields.
- Spot-check component and contract references for consistency.

## Release Notes
- Established the minimum `.lodetime/` schema and populated Phase 0 component/contract catalogs.
- Documented Phase 0 goals and success criteria for manual use.
