# M-phase-1-lodetime-larva-05-cli-socket: CLI Socket (TCP + JSONL)

**Status:** ✅ Completed  
**Epic:** phase-1-lodetime-larva

## Goal
Expose runtime status over a TCP loopback JSONL socket for the CLI.

## Technology & API
- Language: Elixir/OTP.
- TCP server: `thousand_island` (already in deps).
- JSON: `jason` for encode/decode.
- Module: `LodeTime.Interface.CliSocket` in `lib/lodetime/interface/cli_socket/`.
- Protocol: JSONL over TCP at `127.0.0.1:9998`.

## Scope
In scope:
- TCP server on `127.0.0.1:9998`.
- JSONL request/response protocol.
- `status` command with optional `verbose` flag.
- Error responses for unknown or unimplemented commands.
- Logs under `logs/cli-socket/`.

Out of scope:
- Authentication or remote access.
- Non-status commands (may return "not implemented").

## Acceptance Criteria
- CLI socket accepts JSONL requests and returns JSONL responses.
- `status` returns the status payload from the graph server.
- Errors return `{ok:false}` with a code and message.
- Logs written to `logs/cli-socket/`.

## TDD
- Follow RED → GREEN → REFACTOR.
- List tests first in the tracking doc before implementation.

## Implementation Plan
- Implement `LodeTime.Interface.CliSocket` under `lib/lodetime/interface/cli_socket/`.
- Parse JSONL frames and route `status` requests to the graph server.
- Return `{ok:true,data:{...}}` for status and `{ok:false,error:{code,message}}` for errors.
- Add a simple protocol test for round-trip requests.
- If protocol changes are needed, update `.lodetime/contracts/cli-protocol.yaml` to match.

## Test Plan
- Unit tests for JSONL parsing and error handling.
- Integration test: start runtime and send a `status` request over TCP.

## Release Notes
- CLI socket server provides JSONL status responses on loopback.
