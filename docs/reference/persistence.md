# Reference: Persistence (Workspace & Dropzone)

## Why this exists

Container rebuilds can wipe anything that isn’t mounted or stored in named volumes. This reference explains the persistence strategy so rebuilds don’t lose files, chat exports, or ad‑hoc work, and so there is a predictable file exchange path between host and container.

## Goals ("Phase -1: Foundation")

- Reproducible environment: anyone can clone and start developing
- Persistent state: container rebuilds don’t lose work
- Easy file exchange: drop zone between host and container
- Tools ready: Elixir, Go, extensions
- Documented: future you (and AI) knows how it works

## Two-directory model (host)

This project uses two host directories:

- `~/projects/lodetime/` (git repo; tracked)
- `~/lodetime-workspace/` (persistent; not tracked)

Why two?

- Git repo is safe for code and tracked files.
- Workspace is safe for backups, exports, and dropzone; survives rebuilds and repo resets.

Note: runtime state lives in `.lodetime/state/` (gitignored) or an external host state dir; it should not be committed.

ASCII map:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   ~/projects/lodetime/              ~/lodetime-workspace/               │
│   ───────────────────               ─────────────────────               │
│                                                                         │
│   Git-tracked                       NOT git-tracked                      │
│   Container rebuilds: SAFE          Container rebuilds: SAFE             │
│                                                                         │
│   Contains:                         Contains:                            │
│   - Source code                     - Backups                            │
│   - .devcontainer/                  - Secrets                            │
│   - .lodetime/                      - Experiments                        │
│   - Documentation                   - Chat exports                       │
│                                    - Dropzone                            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## What’s mounted into the container

The devcontainer binds the persistent host workspace into the container:

- Host: `~/lodetime-workspace/`
- Container: `/workspace-data/`

This is configured in:

- `.devcontainer/devcontainer.json` (mounts)
- `.devcontainer/docker-compose.yml` (volumes)

## Dropzone and persistent folders

`./setup-host.sh` creates these on the host:

```
~/lodetime-workspace/
├── backups/
├── dropzone/
├── exports/
├── scratch/
└── chat-sessions/
```

In the container, you’ll see the same structure under:

```
/workspace-data/
```

Common uses:

- `/workspace-data/dropzone` – quick file exchange with host
- `/workspace-data/backups` – manual backup targets
- `/workspace-data/exports` – `export-work` outputs

## WSL dropzone (Windows + WSL2)

If you run on WSL2, `./setup-host.sh` also creates a Windows-accessible
`%USERPROFILE%\lodetime-dropzone` and symlinks it to:

- `/workspace-data/win-dropzone`

This allows drag‑and‑drop from Windows Explorer into the container.

## What survives a rebuild

Safe:

- `/workspace` (git repo content)
- `/workspace-data` (host bind mount)
- Named volumes (build caches, deps, shell history, VS Code extensions)
- Git commits

Unsafe (rebuild wipes):

- Anything outside `/workspace`, `/workspace-data`, or named volumes
- Apt packages not in the Dockerfile
- Running processes

## Pre-rebuild checklist

1. `git status` — commit or stash changes
2. `export-work` — saves diffs to `/workspace-data/exports/`
3. Check `/workspace-data/dropzone` for anything important

## Quick verification

Run inside the container:

```bash
ls /workspace-data/
echo "test" > /workspace-data/dropzone/test.txt
```

You should see the file on the host at:

```text
~/lodetime-workspace/dropzone/test.txt
```

## Related files

- `setup-host.sh` – creates the host workspace and WSL dropzone
- `.devcontainer/devcontainer.json` – mount config
- `.devcontainer/docker-compose.yml` – volume config
- `.devcontainer/scripts/post-create.sh` – container setup (folders/aliases)
- `.devcontainer/scripts/post-start.sh` – startup checks
