# M-phase-1-lodetime-larva-03-host-container-boot Tracking

**Status:** 🚧 In Progress  
**Started:** 2026-02-06

## Implementation Log
- 2026-02-06: Started host container boot implementation.
- 2026-02-06: Added Dockerfile and host Docker path to `lode run` (build + run).

## Tests (TDD)
- Manual smoke test checklist (host Docker):
  - `lode run` builds `lodetime-runtime:local` and starts container `lodetime-runtime`.
  - Container runs `mix run --no-halt` and stays up.
  - `logs/graph-server/runtime.log` is created on the host.
  - `lode run` fails with clear guidance when Docker is unavailable.

## Checks
- None yet.

## Release Notes
- None yet.
