# Epic: Phase 1 — LodeTime Larva

**Status:** 📝 Draft  
**Created:** 2026-02-06

## Goal
Deliver the basic query path so `lode status` can load configuration, build a graph, and report a minimal system status via the CLI.

## Scope
- Implement a config loader that reads `.lodetime/` and produces a validated in-memory model.
- Implement a graph server that exposes the model for queries.
- Implement a CLI socket layer for lightweight query transport.
- Implement CLI commands: `lode run`, `lode status` (default + `--verbose`), and a minimal `lode check` stub.
- Support connected + offline CLI modes with explicit flags; default auto mode.
- Provide minimal docs for usage and expected output.

## Out of Scope
- File watching, validation runner, queues, or notifications.
- MCP server, dashboards, or full AI integration.
- Any Phase 2+ runtime services.
- Daemon/stop/restart commands.
- Non-container runtime mode.

## Deliverables
- [ ] Config loader with clear error handling for missing/invalid `.lodetime/` files.
- [ ] Graph server process that loads the config and responds to status queries.
- [ ] CLI socket bridge for query/response between CLI and graph server.
- [ ] CLI commands: `lode run`, `lode status` (default + `--verbose`), and `lode check` stub.
- [ ] Connected + offline CLI modes with explicit flags and mode disclosure in output.
- [ ] Basic docs for running `lode status` in Phase 1.
- [ ] JSON report output (opt-in) and log file output.

## Milestones
- [ ] M-phase-1-lodetime-larva-01-config-loader
- [ ] M-phase-1-lodetime-larva-02-graph-server-boot (devcontainer)
- [ ] M-phase-1-lodetime-larva-03-host-container-boot (Docker only)
- [ ] M-phase-1-lodetime-larva-04-degraded-mode
- [ ] M-phase-1-lodetime-larva-05-cli-socket
- [ ] M-phase-1-lodetime-larva-06-cli

## Success Criteria
- `lode status` runs end-to-end on a fresh checkout and reports a minimal status summary.
- Errors are surfaced clearly when `.lodetime/` is missing or malformed.

## Specification

### Commands
- `lode run`: start (or connect to) the runtime in the foreground; no daemon/stop/restart yet.
- `lode status`: report system status; uses connected mode by default when available.
- `lode status --verbose`: adds expanded fields as available (see Status Output).
- `lode check`: Phase 1 stub; no validations run. Returns an informational message and exit 0 when runtime is healthy; non-zero on connection/config errors.

### CLI Mode Selection
- Flags:
  - `--connected` (require runtime; fail if unreachable)
  - `--offline` (read `.lodetime/` directly; fail if missing/invalid)
  - `--auto` (default): try connected, fallback to offline with a warning
- Output always discloses mode: `connected` or `offline` in human output and JSON.

### Transport & Protocol
- Transport: TCP loopback `127.0.0.1:9998`, JSONL framing.
- Request shape (minimum):
  - `{"cmd":"status","verbose":false}`
- Response shape (minimum):
  - Success: `{"ok":true,"data":{...status fields...}}`
  - Error: `{"ok":false,"error":{"code":"...","message":"..."}}`
- Additional commands listed in the CLI protocol contract may be stubbed or return “not implemented” in Phase 1.

### Status Output
- Default fields:
  - `mode`, `runtime_state`, `phase`
  - `graph.component_count`, `graph.contract_count`
  - `last_error.count`, `last_error.last_at`, `last_error.last_message` (optional)
  - `runtime_version`
- `--verbose` adds (when available):
  - `queue.pending_count`, `queue.oldest_age`, `queue.last_checkpoint_at`
  - `graph.hash`, `graph.last_change_at`
  - `last_check.status`, `last_check.at`, `warnings_open`
  - `config_summary.active_profile`, `config_summary.watched_paths_count`, `config_summary.ignored_paths_count`
  - `tools.enabled`, `tools.last_run`
  - `errors.by_process` (optional)
- Fields not yet supported may be omitted in JSON and shown as `n/a` in human output.
- Human output formatting: sectioned pretty layout (ASCII only). JSON output via `--json`.
- Offline mode: include `source: offline` and omit runtime-only fields instead of showing `n/a`.

### Error Handling & Degraded Mode
- Input/config errors keep the runtime up in **degraded** mode with a clear error summary.
- Status should include a “last known good graph” timestamp when in degraded mode.
- Internal crashes are treated as bugs; surface clear error reporting and exit non-zero on CLI calls.

### Runtime Lifecycle & Environment Support
- One runtime per repo.
- Devcontainer: embedded runtime is the default; sidecar runtime is out of scope for Phase 1.
- Devcontainer start command: `mix run --no-halt`.
- Host: `lode run` builds a repo-local Docker image and starts a per-repo **Docker** container, persisting state via a volume.
- Milestone split: devcontainer boot lands in M‑02; host Docker boot lands in M‑03.
- Minimal auto-detect in Phase 1: if inside devcontainer, use embedded runtime; otherwise use host Docker; else fail with guidance.
- Overrides (highest to lowest):
  1. CLI flags (`--endpoint`, `--engine`)
  2. Environment variables (`LODE_RUNTIME_ENDPOINT`)
  3. Project config (`.lodetime/config.yaml`)
  4. User config (`~/.config/lode/config.yaml`)
- `lode run` behavior:
  - M‑02/M‑03: start-only (no preflight connect check).
  - After CLI socket exists (M‑05+): start-or-connect (if runtime is running, connect; otherwise start).

### Persistence
- Rebuild from disk each run; no durable queue/event log in Phase 1.

### Logging & Reports
- Output to CLI and log files under `logs/` in the repo, with per-component subfolders (e.g., `logs/graph-server/`).
- Log location should be configurable later (e.g., runtime env can redirect to `/var/log`).
- JSON reports opt-in via config or `--json`; write `lode-report.json` to project root (gitignored).

### Security
- Local loopback only; no auth in Phase 1.

### CLI Naming
- CLI binary name is `lode` (no `lodetime` alias in Phase 1).

### Docs
- Phase 1 usage + expectations live in `docs/phases/phase-1/`.

## Notes
Build order stays aligned with `docs/phases/IMPLEMENTATION-PHASES.md` and `CLAUDE.md`.

## Framework Gaps
- Epic Draft vs Planned Gate (see `.ai/GAPS.md`)
