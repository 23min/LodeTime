# Phase 1 Usage (Runtime + CLI)

Phase 1 introduces a minimal runtime so `lode status` can query a live graph over a local socket.

## Run the CLI
If `lode` is not on your PATH yet, use one of these from the repo root:
- `go run ./cmd/lodetime-cli <command>`
- `go build -o bin/lode ./cmd/lodetime-cli` then `./bin/lode <command>`
- Or run `./build.sh` to build `./bin/lode` (and compile the runtime if deps exist).

## Start the Runtime
From the repo root:
- `go run ./cmd/lodetime-cli run`
  - Or `lode run` if installed

Behavior by environment:
- Devcontainer: runs `mix run --no-halt`.
- Host: builds a repo-local Docker image and runs it.

If a runtime is already reachable, `lode run` connects and exits cleanly.

## Status Modes
`lode status` supports three modes:
- `--auto` (default): tries connected, falls back to offline.
- `--connected`: require runtime; error if unreachable.
- `--offline`: read `.lodetime/` directly.

Output formats:
- Human: sectioned ASCII layout (default).
- JSON: `--json`.

Examples:
- `lode status`
- `lode status --connected --json`
- `lode status --offline`

Offline mode includes `source: offline` and omits runtime-only fields.

## Check Command
`lode check` is a Phase-1 stub that confirms the runtime is reachable and exits 0. It does not run validations yet.

## Logs
Runtime and interface logs live under `logs/` in the repo, organized by component.
