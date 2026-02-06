# Phase 0 Validator (`.lodetime/`)

This directory contains a Phase-0-only validator for `.lodetime/` files.

## Purpose
- Validate minimum file presence for Phase 0.
- Validate required keys in config/components/contracts YAML files.
- Validate reference integrity (`depends_on`, `implements_contracts`).
- Catch duplicate IDs in component and contract catalogs.

## Run
From repository root:

```bash
mix run scripts/phase-0/validate-lodetime/validate_lodetime.exs
```

Optional argument:

```bash
mix run scripts/phase-0/validate-lodetime/validate_lodetime.exs /path/to/repo
```

## Exit Codes
- `0`: validation passed
- `1`: validation failed

## Lifecycle
This script is Phase-0-only scaffolding. When runtime-native validation supersedes it in later phases, archive this directory rather than deleting it.
