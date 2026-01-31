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

## Current Phase: 0 (Manual LodeTime)

Check `.lodetime/config.yaml` for status.

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

## Project Structure

- `.lodetime/` - Architecture definitions
- `lib/lodetime/` - Elixir source
- `cmd/lodetime-cli/` - Go CLI
- `docs/` - Documentation
