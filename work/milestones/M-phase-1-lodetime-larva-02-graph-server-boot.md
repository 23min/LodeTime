# M-phase-1-lodetime-larva-02-graph-server-boot: Graph Server Boot (Devcontainer)

**Status:** ⬜ Planned  
**Epic:** phase-1-lodetime-larva

## Goal
Boot the runtime in a devcontainer and start a minimal graph server using the config loader.

## Technology & API
- Runtime language: Elixir/OTP.
- CLI language: Go (Cobra) for `lode run`.
- Graph server module: `LodeTime.Graph.Server` (GenServer) in `lib/lodetime/graph/`.
- Application wiring: `LodeTime.Application` in `lib/lodetime/application.ex`.
- Config loader entrypoint: `LodeTime.Config.Loader.load/1`.
- Logging: write runtime logs under `logs/graph-server/` without adding new dependencies (use Logger + custom file sink as needed).

## Scope
In scope:
- Start the Elixir runtime in devcontainer with `mix run --no-halt`.
- Implement `LodeTime.Graph.Server` that loads the config model and builds an in-memory graph.
- Wire the graph server into `LodeTime.Application` supervision tree.
- Implement a minimal `lode run` CLI command that starts the devcontainer runtime.
- Write runtime logs under `logs/graph-server/`.
- `lode run` is start-only in this milestone (no preflight connect check).

Out of scope:
- Host container boot (separate milestone).
- Degraded mode / last-known-good handling.
- CLI socket protocol or `lode status`.

## Acceptance Criteria
- `lode run` (devcontainer) starts the runtime via `mix run --no-halt`.
- Graph server loads config and builds the dependency graph on startup.
- Graph server exposes a minimal internal API for counts and status summary.
- Logs are written to `logs/graph-server/`.
- Invalid `.lodetime/` currently fails fast with clear error output.

## TDD
- Follow RED → GREEN → REFACTOR.
- List tests first in the tracking doc before implementation.

## Implementation Plan
- Add `LodeTime.Graph.Server` under `lib/lodetime/graph/`.
- Load config via `LodeTime.Config.Loader` and build a graph map.
- Update `LodeTime.Application` to start the graph server.
- Implement a minimal Go CLI subcommand `lode run` that starts `mix run --no-halt` when in a devcontainer.
- Create log directory on runtime start if missing.

## Test Plan
- Unit tests for graph construction from fixture components.
- Integration test: start runtime in test mode and assert graph server is running.

## Release Notes
- Runtime can boot in devcontainer with a graph server loaded from `.lodetime/`.
