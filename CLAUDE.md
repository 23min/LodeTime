# LodeTime Development Guide

## What is LodeTime?

A living development companion built with Elixir/OTP that watches your codebase, understands its architecture, runs tests continuously, and communicates with AI tools.

## Quick Orientation

```
docs/design/    # WHY - Vision, architecture, concepts
docs/phases/    # WHEN - Implementation roadmap
docs/discussion/# HOW WE GOT HERE - Design journey
.lodetime/      # THE ARCHITECTURE (source of truth)
```

## Current State

See `ROADMAP.md` for current phase, active epic, and project context.

## Build Order

1. config-loader → 2. graph-server → 3. cli-socket → 4. cli

## Before Implementing

1. Read `docs/design/` for context
2. Read `.lodetime/components/<component>.yaml`
3. Check build order - don't build before dependencies

## Key Commands

```bash
# Elixir
mix test
mix format
iex -S mix

# Go CLI
cd cmd/lodetime-cli && go build -o ../../bin/lodetime .

# LodeTime (once built)
./bin/lodetime status
```

## Persistent Workspace & Dropzone

The devcontainer mounts a host directory for persistence:

- Host: `~/lodetime-workspace/`
- Container: `/workspace-data/`

Run `./setup-host.sh` on the host to create it. Use `/workspace-data/dropzone` for quick file exchange, and `/workspace-data/backups` or `/workspace-data/exports` for manual backups.

## Project Structure

- `.lodetime/` - Architecture definitions
- `lib/lodetime/` - Elixir source
- `cmd/lodetime-cli/` - Go CLI
- `docs/` - Documentation

## AI Framework

This project uses role-based agents and skills defined in `.ai/`. Read the relevant agent definition before acting in a role:

- **architect** (`.ai/agents/architect.md`) — design decisions, epic scoping
- **planner** (`.ai/agents/planner.md`) — milestone decomposition
- **documenter** (`.ai/agents/documenter.md`) — specs, tracking docs, release notes
- **implementer** (`.ai/agents/implementer.md`) — coding, TDD execution
- **tester** (`.ai/agents/tester.md`) — test planning, verification
- **deployer** (`.ai/agents/deployer.md`) — infrastructure, releases
- **maintainer** (`.ai/agents/maintainer.md`) — framework (.ai/) only

Guardrails: `.ai/instructions/ALWAYS_DO.md`
Handoff flow: `.ai/docs/handoff-guide.md`
