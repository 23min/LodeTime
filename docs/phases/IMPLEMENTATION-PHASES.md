# Implementation Phases

> The complete roadmap from nothing to self-hosting

---

## Overview

```
Phase -1     Phase 0      Phase 1      Phase 2      Phase 3
Foundation   Manual LT    LT Larva     LT Pupa      LT Adult

Dev env +    .lodetime/   Basic        File watch   Full
scaffolding  files only   queries      + tests      system
```

---

## Phase -1: Foundation ✓

- Devcontainer setup
- Elixir/Go scaffolding
- Project structure
- Documentation

---

## Phase 0: Manual LodeTime (Current)

**Goal**: Validate architecture format before building runtime.

- Finalize .lodetime/ YAML schema
- Create all component definitions
- Create all contract definitions
- Claude Code reads files directly

**Success**: Can use Claude Code with .lodetime/ for context.

---

## Phase 1: LodeTime Larva

**Goal**: Basic querying works.

Build order:
1. config-loader (no deps)
2. graph-server (← config-loader)
3. cli-socket (← graph-server)
4. cli (← cli-socket)

**Success**: `lode status` works.

---

## Phase 2: LodeTime Pupa

**Goal**: LodeTime watches itself with checkpointed validation.

Build:
- file-watcher
- state-server
- validation runner (tests + contract checks)
- durable signal queue
- Basic notifications + severity

**Magic moment**: Edit a file → `lode check` runs validations and reports results.

**Success**: `lode check` validates changes; `lode status` shows queue + last check outcome.

---

## Phase 3: LodeTime Adult

**Goal**: Full system.

Build:
- Full notifications
- MCP server
- WebSocket dashboard (optional)
- Validation runner (expanded)

**Success**: Full self-hosting, AI integration works.

---

## The Bootstrap Philosophy

Each phase uses the previous to build the next.
By Phase 3, you're fully dog-fooding.
