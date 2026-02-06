# Phase 0 Usage (No Runtime)

Phase 0 is intentionally "manual mode": you use `.lodetime/` as a machine-readable architecture map while you build the system.

## How Humans Use It
- Start at `.lodetime/config.yaml` to understand the project, current phase, and what parts of the repo matter.
- Browse `.lodetime/components/*.yaml` to see the component catalog, ownership boundaries, dependencies, and implementation status.
- Browse `.lodetime/contracts/*.yaml` to see what interfaces exist (and what is expected to be stable).

## How AI Assistants Use It
- Treat `.lodetime/` as authoritative intent (more reliable than narrative docs for structural facts).
- Use component `status` to decide whether an area is real or aspirational.
- When changing architecture intent, update `.lodetime/` first (or in the same change) and keep IDs stable.

## Status Meanings (Convention)
The project uses a simple component status vocabulary:
- `planned`: declared but not implemented
- `implementing`: in progress
- `implemented`: done and in use
- `deprecated`: being phased out

## Optional: Static CLI Convenience
This repo includes a CLI that can read `.lodetime/` directly (static mode). It is not the runtime.

From the repo root:
- `go run ./cmd/lodetime-cli status`
- `go run ./cmd/lodetime-cli component <id>`

## Editing Rules of Thumb
- Prefer small, mechanical edits to `.lodetime/` that keep IDs consistent.
- When you introduce a new component, add its dependencies explicitly via `depends_on`.
- When you introduce a new contract, keep it small and explicit; avoid inference-based semantics in Phase 0.
