# LodeTime

> A living development companion

LodeTime is a BEAM-based development companion that keeps a project’s intent, architecture, and health “alive” while you work. Instead of being a one‑off CLI, it’s designed to run alongside your editor, continuously watching the codebase, tracking how it maps to your planned architecture, and surfacing what’s drifting, broken, or unfinished.

Use it when you want more than tests-in-CI: you want a system that remembers what you meant to build, checks whether the code still matches that intent, and gives you a real‑time view of progress. It aims to bridge humans, code, and AI tools by turning your architecture docs into a living source of truth that can answer questions, flag mismatches, and guide the next step.

In short: LodeTime is for teams who want a persistent, always‑on “project brain” that combines architecture awareness, continuous validation, and fast, conversational status checks.

## Status

🚧 **Bootstrapping** - Using LodeTime's architecture format to build LodeTime itself.

## Quick Start

### Prerequisites

- Docker & Docker Compose
- VS Code with Dev Containers extension
- Git

### Setup

```bash
# 1. Clone the repo
git clone <repo-url>
cd lodetime

# 2. Create persistent workspace (run on host)
./setup-host.sh

# 3. Open in VS Code
code .

# 4. Reopen in Container (VS Code prompt)
# Or: Cmd/Ctrl + Shift + P → "Dev Containers: Reopen in Container"

# 5. Inside container
mix deps.get
mix compile
./bin/lodetime status
```

## Persistent Workspace & Dropzone

To prevent losing files on container rebuilds, a host directory is mounted into the container:

- Host: `~/lodetime-workspace/`
- Container: `/workspace-data/`

`./setup-host.sh` creates the host directory and subfolders like `dropzone/`, `backups/`, `exports/`, and `chat-sessions/`. Anything placed in `~/lodetime-workspace/dropzone/` will appear in the container at `/workspace-data/dropzone/`.

On WSL, the script also creates a Windows-accessible dropzone and symlinks it to `/workspace-data/win-dropzone` for easy drag-and-drop.

Codex state is configured to live in `/workspace-data/.codex` so chat history and settings persist across container rebuilds.

## Project Structure

```
lodetime/
├── .lodetime/           # Architecture definitions (source of truth)
│   ├── config.yaml      # Main configuration
│   ├── components/      # Component specifications
│   └── contracts/       # Interface contracts
├── lib/                 # Elixir source code
├── cmd/lodetime-cli/    # Go CLI
├── test/                # Tests
└── docs/                # Documentation
    ├── design/          # Design documents
    ├── phases/          # Implementation roadmap
    └── discussion/      # Design journey
```

## Documentation

- [Vision](docs/design/01-VISION.md) - What LodeTime is and why
- [Technical Architecture](docs/design/03-TECHNICAL-ARCHITECTURE.md) - How it's built
- [Implementation Phases](docs/phases/IMPLEMENTATION-PHASES.md) - The roadmap
- [Decisions](docs/DECISIONS.md) - Architectural decisions
- [CLAUDE.md](CLAUDE.md) - Development guide
- [AI Framework](ai/README.md) - Agents, skills, and AI workflow

## Current Phase

See `docs/phases/IMPLEMENTATION-PHASES.md` for full roadmap.

| Phase | Description | Status |
|-------|-------------|--------|
| -1 | Foundation (dev environment) | ✓ |
| 0 | Manual LodeTime (YAML only) | Current |
| 1 | LodeTime Larva (basic queries) | Pending |
| 2 | LodeTime Pupa (file watching) | Pending |
| 3 | LodeTime Adult (full system) | Pending |

## Key Commands

```bash
# Elixir
mix test           # Run tests
mix format         # Format code
iex -S mix         # Interactive console

# Go CLI
./bin/lodetime status        # Project status
./bin/lodetime component X   # Component details
./bin/lodetime deps X        # Dependencies

# Development
backup             # Backup current work
export-work        # Export uncommitted changes
```

## Why LodeTime?

Existing tools don't track:
- **Planned components** - What you intend to build
- **Human-curated intent** - Why things exist
- **Development state** - What's working, what's broken
- **Continuous validation** - Not just in CI

LodeTime fills this gap with a living, always-running companion.

## Why Elixir/BEAM?

- **Supervision trees**: Components crash and restart independently
- **Lightweight processes**: Natural for watching many things
- **Message passing**: Perfect for event-driven architecture
- **Hot code reloading**: Update without losing state
- **ETS**: Fast concurrent reads for the graph

## License

TBD
