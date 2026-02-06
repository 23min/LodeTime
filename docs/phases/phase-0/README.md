# Phase 0: Manual LodeTime

## Goal
Validate the architecture format and manual workflow before building the runtime.

Phase 0 is complete when the minimum `.lodetime/` schema and catalogs exist and are consistent enough for humans/AI to use in planning and implementation.

## What Exists In Phase 0
- `.lodetime/` files are the source of truth for architecture intent.
- Humans and AI read `.lodetime/` directly (no runtime required).
- Validation is manual and/or Phase-0-only scripts (if present).

## What Does Not Exist Yet
- No long-running LodeTime runtime services (watcher, state server, MCP server, etc.).
- No checkpoint protocol enforcement.
- No automatic test running or notifications.

## Phase 0 Inputs (Minimum)
- Project config: `.lodetime/config.yaml`
- Component catalog: `.lodetime/components/*.yaml`
- Contract catalog: `.lodetime/contracts/*.yaml`

## Next Phase Preview
Phase 1 introduces basic query capability (a minimal runtime path) so status and queries can be served rather than read purely from disk.
