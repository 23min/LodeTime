# M-phase-0-manual-lodetime-03-validator-script: Phase 0 Validator Script

**Status:** ✅ Complete  
**Epic:** phase-0-manual-lodetime  
**Date Planned:** 2026-02-06 (retroactive documentation)  
**Date Started:** 2026-02-06  
**Date Completed:** 2026-02-06

## Goal
Provide a Phase 0 validator script and README under `scripts/phase-0/validate-lodetime/` to check `.lodetime/` file completeness and internal consistency.

## Scope
In scope:
- `scripts/phase-0/validate-lodetime/README.md` describing purpose, usage, and lifecycle.
- A simple validator script (language TBD) that checks required fields and references.
- Phase‑0‑only labeling and archival guidance.

Out of scope:
- Runtime validation runner or Phase 1+ integration.
- CI enforcement beyond optional/manual use.

## Acceptance Criteria
- README explains what the script validates, how to run it, and when to use it.
- Script validates required fields in config/components/contracts.
- Script validates references (e.g., `depends_on`, `implements_contracts`) exist.
- Script clearly labeled Phase‑0‑only with archival guidance.

## Implementation Plan
- Choose a small script language (Python or Go) with minimal dependencies.
- Implement required-field checks and reference validation.
- Write README with usage examples and lifecycle notes.

## Test Plan
- Run script against current `.lodetime/`.
- Introduce a known-bad sample and confirm failure (manual test).

## Release Notes
- Added `scripts/phase-0/validate-lodetime/README.md`.
- Added `scripts/phase-0/validate-lodetime/validate_lodetime.exs`.
- Validated current `.lodetime/` successfully via `mix run scripts/phase-0/validate-lodetime/validate_lodetime.exs`.
