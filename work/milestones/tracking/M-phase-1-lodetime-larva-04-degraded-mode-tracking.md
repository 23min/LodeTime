# M-phase-1-lodetime-larva-04-degraded-mode Tracking

**Status:** 🚧 In Progress  
**Started:** 2026-02-06

## Implementation Log
- 2026-02-06: Implemented degraded state, last-known-good tracking, and reload API in graph server.

## Tests (TDD)
- Invalid config puts server into degraded state (no crash).
- Last known good graph remains accessible after a failed reload.
- Degraded status includes last_good_at timestamp and error summary.

## Checks
- `mix test test/lodetime/graph/server_test.exs`

## Release Notes
- None yet.
