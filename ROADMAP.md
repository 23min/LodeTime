# LodeTime Roadmap (Epics)

## Project Context

LodeTime is a BEAM-based living development companion that keeps a project's intent, architecture, and health "alive" while you work. It bridges humans, code, and AI tools by turning architecture docs into a living source of truth.

- **Current phase:** 2 (Pupa) — see `docs/phases/IMPLEMENTATION-PHASES.md`
- **Active epic:** (none yet)
- **Epic tracker:** `work/epics/epic-roadmap.md`
- **AI framework:** `.ai/` (skills, agents, instructions)

## Epics

This roadmap tracks **epics** and their status. Phases are defined separately in `docs/phases/IMPLEMENTATION-PHASES.md`.

Epics are planning units and do not have to map 1:1 to phases. We group epics by phase here for convenience, but epics may span phases or be sliced across them.

## Phase 0 — Manual LodeTime

- [x] EPIC: Phase 0 Manual LodeTime (`phase-0-manual-lodetime`) complete
  Includes `.lodetime/` schema and catalogs, Phase 0 manual usage/testing docs, and validator script.

## Phase 1 — LodeTime Larva

- [x] EPIC: Phase 1 LodeTime Larva (`phase-1-lodetime-larva`) complete
  Delivered basic query path (config-loader → graph-server → cli-socket → CLI), runtime boot (`lode run`), status/check CLI, and Phase 1 docs/build bootstrap.

## Phase 2 — LodeTime Pupa

- [ ] EPIC: (TBD) File watcher + checkpoint validation + durable queue

## Phase 3 — LodeTime Adult

- [ ] EPIC: (TBD) MCP server + validation runner
- [ ] EPIC: (TBD) Notifications (dashboard optional)

---

### Status Legend
- [ ] Planned
- [~] In progress
- [x] Complete
