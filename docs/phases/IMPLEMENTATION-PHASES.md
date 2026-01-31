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

**Success**: `lodetime status` works.

---

## Phase 2: LodeTime Pupa

**Goal**: LodeTime watches itself.

Build:
- file-watcher
- test-runner
- state-server
- Basic notifications

**Magic moment**: Edit a file, LodeTime detects it, runs tests, reports.

**Success**: LodeTime tests itself on save.

---

## Phase 3: LodeTime Adult

**Goal**: Full system.

Build:
- Full notifications
- MCP server
- WebSocket dashboard
- Validation runner

**Success**: Full self-hosting, AI integration works.

---

## The Bootstrap Philosophy

Each phase uses the previous to build the next.
By Phase 3, you're fully dog-fooding.
