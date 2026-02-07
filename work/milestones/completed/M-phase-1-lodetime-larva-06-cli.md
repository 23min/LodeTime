# M-phase-1-lodetime-larva-06-cli: CLI Status + Check + Output

**Status:** ✅ Completed  
**Epic:** phase-1-lodetime-larva

## Goal
Deliver the Phase 1 CLI commands with connected + offline modes and human-readable output.

## Technology & API
- Language: Go.
- CLI framework: Cobra (existing).
- Config: Viper (existing).
- Status transport: TCP JSONL client for `127.0.0.1:9998`.
- Offline mode: read `.lodetime/` via YAML in Go (existing parser).
- Output: sectioned ASCII layout via plain `fmt` (no Unicode/boxes).

## Scope
In scope:
- CLI binary name is `lode`.
- Build bootstrap via `./build.sh` that produces `./bin/lode` for local CLI use.
- `lode status` (default + `--verbose`).
- `lode check` stub (informational only).
- `lode run` start-or-connect behavior once CLI socket exists.
- Flags: `--connected`, `--offline`, `--auto` (default), `--json`, `--verbose`, `--endpoint`, `--engine`.
- Sectioned ASCII output for human-readable status.
- Offline mode includes `source: offline` and omits runtime-only fields.

Out of scope:
- Additional CLI commands beyond `run`, `status`, `check`.
- Unicode/boxed formatting.

## Acceptance Criteria
- Fresh checkout can run `./build.sh` and then execute CLI commands via `./bin/lode`.
- `lode status` uses CLI socket in connected mode and falls back to offline in auto mode.
- `lode status --json` outputs JSON only.
- Human output uses sectioned ASCII layout.
- `lode check` prints informational output and exits 0 when runtime is healthy; non-zero on connection/config errors.
- `lode run` connects to an existing runtime if reachable; otherwise starts it.

## TDD
- Follow RED → GREEN → REFACTOR.
- List tests first in the tracking doc before implementation.

## Implementation Plan
- Update Go CLI root command to use `lode`.
- Add/maintain `build.sh` to build `./bin/lode` (and compile runtime if available).
- Implement status client for TCP JSONL protocol.
- Implement offline status path reading `.lodetime/` directly.
- Add output formatter for sectioned ASCII and JSON output.
- Implement `lode check` stub behavior.

## Test Plan
- Unit tests for status response parsing and formatting.
- Integration test: start runtime, run `lode status`, verify output fields.
- Offline test: run `lode status --offline` with no runtime.

## Release Notes
- CLI supports `lode status` with connected/offline modes and JSON output.
- Added `build.sh` bootstrap path for local `./bin/lode` usage.
