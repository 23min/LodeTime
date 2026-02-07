# Phase 1 Testing

## CLI Unit Tests
From `cmd/lodetime-cli`:
- `go test ./...`

## Integration Test (Runtime + CLI)
The integration test starts the runtime and runs `lode status --connected --json`.

Requirements:
- `mix` available on PATH.
- Port `127.0.0.1:9998` is free.

Run:
- `LODE_INTEGRATION=1 go test ./...`
