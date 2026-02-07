# M-phase-1-lodetime-larva-01-config-loader: Config Loader

**Status:** ✅ Completed  
**Epic:** phase-1-lodetime-larva

## Goal
Implement a config loader that reads `.lodetime/` files and produces a validated in-memory model for runtime and offline CLI use.

## Technology & API
- Language: Elixir.
- YAML parser: `yaml_elixir`.
- Location: `lib/lodetime/config/`.
- Model: `%LodeTime.Config.Model{config, components, contracts}`.
- Error shape: `%LodeTime.Config.Error{file, field, message}`.
- Entrypoint: `LodeTime.Config.Loader.load(root_path)` returns `{:ok, model}` or `{:error, [error]}`.

## Scope
In scope:
- Parse `.lodetime/config.yaml`, `.lodetime/components/*.yaml`, and `.lodetime/contracts/*.yaml`.
- Validate required fields and schema_version presence.
- Surface actionable errors with file path + field names.
- Provide a stable API for the graph server and offline CLI.

Out of scope:
- Graph construction or runtime processes.
- CLI socket or network transport.
- Degraded-mode behavior (handled later).

## Acceptance Criteria
- Loading succeeds on valid `.lodetime/` data and returns a structured model.
- Missing or malformed files return clear, structured errors (file + field + message).
- Required fields validated:
  - Config: `project`, `schema_version`, `current_phase`, `zones`.
  - Components: `id`, `name`, `status`, `location`, `depends_on`.
  - Contracts: `id`, `name`, `description`.
- API surface is documented for consumers (graph server and CLI offline mode).

## TDD
- Follow RED → GREEN → REFACTOR.
- List tests first in the tracking doc before implementation.

## Implementation Plan
- Define data structures in `lib/lodetime/config/` for config, components, and contracts.
- Implement loader entrypoint `LodeTime.Config.Loader.load(root_path)`.
- Add field-level validation and error collection.
- Add unit tests with fixtures for valid/invalid inputs.

## Test Plan
- Unit tests for successful load of the repo `.lodetime/`.
- Unit tests for missing file, missing field, and malformed YAML.

## Release Notes
- Config loader reads `.lodetime/` and exposes validated configuration data.
