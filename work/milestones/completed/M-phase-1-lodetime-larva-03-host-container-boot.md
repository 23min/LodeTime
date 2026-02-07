# M-phase-1-lodetime-larva-03-host-container-boot: Host Container Boot (Docker)

**Status:** ✅ Completed  
**Epic:** phase-1-lodetime-larva

## Goal
Extend `lode run` to boot the runtime in a host Docker container.

## Technology & API
- Dockerfile: repo root `Dockerfile` builds the runtime image.
- CLI language: Go (Cobra) for `lode run`.
- Docker invocation: call `docker build` and `docker run` from CLI (no new dependencies).
- Image tag: `lodetime-runtime:local`; container name: `lodetime-runtime`.
- Runtime command in container: `mix run --no-halt`.

## Scope
In scope:
- Add a repo-root `Dockerfile` for the runtime.
- `lode run` builds the image and starts a per-repo Docker container.
- Image tag: `lodetime-runtime:local`; container name: `lodetime-runtime`.
- Repo is mounted into the container; runtime runs `mix run --no-halt`.
- Logs remain under repo `logs/` so they are visible on the host.
- `lode run` is start-only in this milestone (no preflight connect check).

Out of scope:
- Podman/nerdctl support.
- Auto-detect beyond minimal devcontainer vs docker.
- CLI socket protocol or `lode status`.

## Acceptance Criteria
- `lode run` outside devcontainer builds the Docker image and starts the runtime container.
- Container runs `mix run --no-halt` and keeps the runtime alive.
- Logs are written to `logs/graph-server/` in the host repo.
- If Docker is unavailable, `lode run` fails with clear guidance.

## TDD
- Follow RED → GREEN → REFACTOR where feasible.
- List tests first in the tracking doc before implementation.
- If automated tests are not viable, define a manual smoke test checklist in the tracking doc before implementation.

## Implementation Plan
- Add `Dockerfile` in repo root to build the runtime image.
- Implement `lode run` host path to call `docker build` then `docker run`.
- Mount repo into container and set working directory appropriately.
- Create log directory on runtime start if missing.

## Test Plan
- Manual test: `lode run` on host starts container and keeps runtime alive.
- Verify logs written under `logs/graph-server/` on host.

## Release Notes
- `lode run` can boot the runtime in a host Docker container.
