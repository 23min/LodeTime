# Architectural Decisions

> Record of key decisions with rationale

---

## ADR-001: Elixir/BEAM for Runtime
**Decision**: Use Elixir/BEAM
**Why**: Supervision trees, lightweight processes, hot reload, ETS

## ADR-002: Go for CLI
**Decision**: Go CLI + Elixir server
**Why**: Fast startup (<100ms), socket communication

## ADR-003: YAML for Config
**Decision**: YAML files
**Why**: Familiar, editor support, easy to generate

## ADR-004: File-Based Architecture
**Decision**: .lodetime/ directory with multiple files
**Why**: Version controlled, scalable, AI-readable

## ADR-005: Four-State Component Model
**Decision**: planned → implementing → implemented → deprecated
**Why**: "planned" is key differentiator

## ADR-006: Zone-Based Treatment
**Decision**: Different zones get different rules
**Why**: Acknowledges messy codebases

## ADR-007: Debounced File Watching
**Decision**: 2s debounce default
**Why**: Prevents noise from editor saves

## ADR-008: MCP for AI Integration
**Decision**: MCP protocol
**Why**: Designed for AI, growing adoption

## ADR-009: Self-Describing Bootstrap
**Decision**: Build LodeTime using LodeTime's format
**Why**: Proves format works, immediate dogfooding

## ADR-010: Two-Tier CLI
**Decision**: Static + Connected modes
**Why**: Lower barrier, works without server
