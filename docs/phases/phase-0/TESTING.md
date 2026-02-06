# Phase 0 Testing (Validation Without Runtime)

Phase 0 validation is intentionally lightweight. The point is to keep `.lodetime/` consistent and useful, not to build Phase 1+ runtime behavior early.

## What We Validate In Phase 0
- Required files exist:
  - `.lodetime/config.yaml`
  - `.lodetime/components/*.yaml`
  - `.lodetime/contracts/*.yaml`
- Required keys exist in each file type (minimum schema).
- References are internally consistent:
  - `depends_on` references existing component IDs
  - `implements_contracts` references existing contract IDs (when present)

## How We Validate In Phase 0
Pick one (or do both):
- Manual review checklist (good enough early on)
- A Phase-0-only validator script (recommended once the catalogs grow)

If a Phase 0 script exists, it must be clearly labeled as Phase-0-only and is allowed to be archived later when the runtime supersedes it.

## Suggested Manual Checklist
- `config.yaml` parses as YAML and matches the expected top-level keys for this repo.
- Every component file has `id`, `name`, `status`, `location`, and `depends_on`.
- Every contract file has `id`, `name`, and `description`.
- No duplicate `id` values across component files.
- Every dependency and contract reference resolves to an existing file.

## Script Location (If/When Added)
Phase 0 scripts live under:
- `scripts/phase-0/validate-lodetime/`

They should remain optional and non-blocking in Phase 0.
