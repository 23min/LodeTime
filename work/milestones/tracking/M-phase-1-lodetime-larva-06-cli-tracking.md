# M-phase-1-lodetime-larva-06-cli Tracking

**Status:** 🚧 In Progress  
**Started:** 2026-02-06

## Implementation Log
- 2026-02-06: Implemented `lode status` with connected/offline/auto modes, JSONL client, and sectioned ASCII/JSON output.
- 2026-02-06: Added `lode check` stub and updated `lode run` to start-or-connect with engine resolution.

## Tests (TDD)
- `lode status` connected mode parses JSONL and renders sectioned ASCII.
- `lode status --json` outputs JSON only.
- `lode status --offline` omits runtime-only fields and includes `source: offline`.
- `lode check` returns informational output and exit 0 when runtime is reachable.

## Checks
- `cd cmd/lodetime-cli && go test ./...`

## Release Notes
- None yet.
