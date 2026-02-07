# Epic Release: Phase 1 - LodeTime Larva

**Epic Slug:** phase-1-lodetime-larva  
**Released:** 2026-02-07  
**Git Tag:** epic/phase-1-lodetime-larva

## Overview
Phase 1 delivered the first runtime query path: config loading, graph server boot, CLI socket transport, and end-user CLI commands (`run`, `status`, `check`) with connected/offline behavior.

## Milestones Completed
- M-phase-1-lodetime-larva-01-config-loader: Added config loader model + structured errors.
- M-phase-1-lodetime-larva-02-graph-server-boot: Added graph server boot path and runtime logs in devcontainer.
- M-phase-1-lodetime-larva-03-host-container-boot: Added host Docker boot path in `lode run`.
- M-phase-1-lodetime-larva-04-degraded-mode: Added degraded mode and last-known-good behavior.
- M-phase-1-lodetime-larva-05-cli-socket: Added loopback TCP JSONL CLI socket server.
- M-phase-1-lodetime-larva-06-cli: Added status/check commands, output formatting, tests, and docs.

## Key Features Delivered
- Runtime services for Phase 1 in Elixir:
  - Config loader
  - Graph server
  - CLI socket transport
- CLI features in Go:
  - `lode run` (start-or-connect)
  - `lode status` (`--auto`, `--connected`, `--offline`, `--json`, `--verbose`)
  - `lode check` runtime-reachability stub
- Output and transport:
  - Sectioned ASCII human output
  - JSON output mode
  - TCP JSONL loopback protocol (`127.0.0.1:9998`)
- Bootstrap and docs:
  - `build.sh` produces `./bin/lode`
  - Phase 1 docs under `docs/phases/phase-1/`

## Breaking Changes
- CLI command name standardized to `lode` (no `lodetime` alias in Phase 1 docs/flow).

## Impact
Phase 1 is now complete and testable end-to-end. A user can start the runtime and query status through the CLI, with deterministic offline fallback and integration-test coverage for the live status path.
