# Schema Changes

This log tracks changes to `.lodetime/` schemas so tooling and documentation stay in sync.

## 2026-02-01 — v1 (initial)

- Added `schema_version: 1` to:
  - `.lodetime/config.yaml`
  - `.lodetime/components/*.yaml`
  - `.lodetime/contracts/*.yaml`

Notes:
- `schema_version` is required for new or updated schema files.
- Breaking changes must increment the version and be recorded here.
