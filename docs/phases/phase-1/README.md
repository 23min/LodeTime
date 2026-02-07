# Phase 1: Runtime Query Path

## Goal
Provide a minimal runtime path so the CLI can query status via a local socket instead of reading `.lodetime/` directly.

## What Exists In Phase 1
- Runtime process with graph server + CLI socket.
- CLI commands: `lode run`, `lode status`, `lode check`.
- Connected mode (socket) and offline mode (read `.lodetime/`).
- Sectioned ASCII output and JSON output.

## What Does Not Exist Yet
- No file watcher, queue, state server, or notifications.
- No daemon lifecycle commands (stop/restart).
- No auth or remote access.

## Phase 1 Inputs (Minimum)
- Project config: `.lodetime/config.yaml`
- Component catalog: `.lodetime/components/*.yaml`
- Contract catalog: `.lodetime/contracts/*.yaml`

## Next Phase Preview
Phase 2 adds watchers and state, enabling incremental updates instead of rebuild-on-each-query.
