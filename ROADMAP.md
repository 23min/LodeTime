# LodeTime Roadmap (Epics)

This roadmap tracks **epics** and their status. Phases are defined separately in `docs/phases/IMPLEMENTATION-PHASES.md`.

Epics are planning units and do not have to map 1:1 to phases. We group epics by phase here for convenience, but epics may span phases or be sliced across them.

## Phase 0 — Manual LodeTime

- [x] EPIC: Phase 0 Manual LodeTime (`phase-0-manual-lodetime`) complete
  Includes `.lodetime/` schema and catalogs, Phase 0 manual usage/testing docs, and validator script.

## Phase 1 — LodeTime Larva

- [ ] EPIC: Phase 1 LodeTime Larva (`phase-1-lodetime-larva`) planned
  Basic query path (config-loader → graph-server → cli-socket → CLI)

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
