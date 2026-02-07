# M-phase-1-lodetime-larva-04-degraded-mode: Degraded Mode + Last Known Good

**Status:** ✅ Completed  
**Epic:** phase-1-lodetime-larva

## Goal
Keep the runtime up in degraded mode when config input errors occur, while preserving the last known good graph.

## Degraded Mode Flow
1. Startup loads config.
2. If load succeeds: `degraded=false`, `last_good_graph` and `last_good_at` set.
3. If load fails: `degraded=true`, `last_error` set, and the server stays up.
4. On reload:
   - Success: clear `last_error`, update `last_good_graph` + `last_good_at`, `degraded=false`.
   - Failure: keep `last_good_graph`, update `last_error`, `degraded=true`.
5. `summary/1` uses `last_good_graph` when degraded; otherwise uses current graph.

## Technology & API
- Language: Elixir/OTP.
- State owner: `LodeTime.Graph.Server` holds degraded status and last-known-good graph in memory.
- Error shape: `%LodeTime.Config.Error{file, field, message}` from the config loader.
- No persistence in Phase 1; state is in-memory only.

## Scope
In scope:
- Track last known good graph and timestamp.
- On config load errors, keep runtime alive and mark state as degraded.
- Store a structured error summary for status reporting.

Out of scope:
- CLI socket or CLI output formatting.
- Queueing, validation, or checkpointing.

## Acceptance Criteria
- Runtime does not crash on invalid `.lodetime/` input; it enters degraded mode.
- Last known good graph remains available in memory with timestamp.
- Error summary includes file path, field, and message.

## TDD
- Follow RED → GREEN → REFACTOR.
- List tests first in the tracking doc before implementation.

## Implementation Plan
- Extend graph server state with `last_good_graph`, `last_good_at`, and `last_error`.
- Update config reload path to preserve last good data on failure.
- Provide internal API to retrieve degraded status and last good timestamp.

## Test Plan
- Unit tests: successful load sets last-good and returns `degraded=false`.
- Unit tests: invalid config sets `degraded=true` with error summary.
- Unit tests: reload failure preserves last-known-good graph and `last_good_at`.

## Release Notes
- Runtime stays alive in degraded mode with last known good graph preserved.
