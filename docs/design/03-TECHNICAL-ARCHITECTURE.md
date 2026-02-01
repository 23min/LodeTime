# Technical Architecture

> Why BEAM/Elixir, system design, and implementation approach

---

## Why BEAM/Elixir?

| Requirement | BEAM Feature |
|-------------|--------------|
| Always running, resilient | Supervision trees |
| Watch many things | Lightweight processes (~2KB) |
| Handle concurrent events | Message passing |
| Update without restart | Hot code reloading |
| Fast queries | ETS tables |
| Future distribution | Built-in clustering |

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    LodeTime Application                         │
├─────────────────────────────────────────────────────────────────┤
│  Config.Server ─── Graph.Server ─── State.Server               │
│                         │                                       │
│  Watcher.Supervisor ────┤                                       │
│   ├─ FileSystem         │                                       │
│   ├─ Git                │                                       │
│   └─ Webhook            │                                       │
│                         │                                       │
│  Runner.Supervisor ─────┤                                       │
│   ├─ Test               │                                       │
│   └─ Validation         │                                       │
│                         │                                       │
│  Interface.Supervisor ──┘                                       │
│   ├─ CLI.Socket ──────► Go CLI                                  │
│   ├─ MCP.Server ──────► Claude Code                             │
│   └─ WebSocket                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Data Flow

```
File saved → FileWatcher (debounced) → Graph.Server.component_for_path()
         → Test.Runner.run() → State.Server.update()
         → Notify.Router.broadcast()
```

Checkpointed validation (Phase 2+):
- `lode check` triggers a checkpoint
- Runtime waits for quiescence, drains signal queue, runs validation, emits report

---

## Why Go for CLI?

- BEAM has ~1s startup time (too slow for quick commands)
- Go: <100ms startup, single binary, cross-platform
- CLI can work offline (read YAML directly)

---

## Storage Strategy

- **YAML files**: Source of truth, git-friendly (`.lodetime/`)
- **Runtime state**: `.lodetime/state/` (gitignored) or host-mounted state dir
- **Durable queue**: JSONL in state dir (e.g., `.lodetime/state/queue.jsonl`)
- **ETS tables**: In-memory runtime state, fast concurrent reads
- **No database**: Simplicity, YAML is enough

Write safety:
- LodeTime updates `.lodetime/` only with explicit approval.
- Use a `.lodetime/.lock` during “tell” updates to avoid concurrent edits.
