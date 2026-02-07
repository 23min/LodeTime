# ALWAYS_DO

Purpose: global guardrails that apply to every session, regardless of role.

## CRITICAL: Never Commit Without Approval

**NEVER run `git commit` without explicit human approval.**

Always:
1. Stage changes with `git add`
2. Show what will be committed
3. Wait for human approval
4. Only then commit when explicitly instructed

---

## Core Guardrails

- Follow the project's AI/dev instructions (`ROADMAP.md` for current state, `docs/` for design) and relevant development docs under `work/`.
- No time or effort estimates in docs or plans.
- Search efficiently (prefer fast tools like `rg`/`fd` when available).
- Avoid history-rewriting / destructive git operations unless explicitly instructed.
- Keep docs/schemas/templates aligned when touching contracts.
- Tests must be deterministic; avoid external network calls.
- Use Mermaid for diagrams; avoid ASCII art boxes.
- Prefer minimal, precise edits; avoid broad refactors without context.

## Security & Privacy

- Do not paste secrets/tokens into prompts, docs, issues, or logs.
- Avoid including customer/PII data in examples; use sanitized fixtures.
- **Dependency gating:** All new dependencies must be approved by user before installation; flag packages < 1 year old or with < 100 stars for review.

## Decision & Gap Logging

- Architectural decisions: Create ADR in `work/epics/<epic-slug>/adrs/XXX-decision-title.md`
- Epic progress/scope changes: Add note to epic spec's Progress Notes section
- Milestone work: Use tracking doc's Implementation Log section
- Gaps discovered: Add to `work/GAPS.md` and reference from epic/milestone
- Ad-hoc work: Log in `PROVENANCE.md` (see `.ai/docs/provenance-format.md`)
- Gaps are out-of-scope by default; review with architect/planner before placement
- One-off work requires explicit user approval and must be logged in PROVENANCE.md

## Conflict Resolution

When instructions conflict, precedence is:
1. Explicit user directive in current session
2. Project-specific docs (CLAUDE.md, ROADMAP.md, project config)
3. ALWAYS_DO.md (this file)
4. Skill-specific guidance
5. Agent role defaults

When in doubt: ask the user.

## Efficiency

- Read only what you need (use grep/search before full file reads)
- Summarize long documents; don't paste full contents into responses
- Use incremental workflows (don't rewrite entire files)
- Keep tracking docs concise (link to details rather than embedding)
- Archive completed milestone docs to reduce context pollution

## Ownership & Handoffs

- Follow agent ownership boundaries defined in agent specs (`.ai/agents/`)
- Follow skill-defined handoff procedures
- See `.ai/docs/handoff-guide.md` for the full handoff chain

## Session Hygiene

- Confirm epic context before milestone execution; if missing, run `epic-refine`/`epic-start`.
- Use TDD: RED -> GREEN -> REFACTOR; list tests first in tracking docs.
- Keep milestone specs stable; use tracking docs for progress updates.
- Build and test before handoff when asked to implement changes.

## Commit Messages

- Use Conventional Commits format (see `.ai/docs/commit-format.md`)
- Keep subject line under 72 characters, imperative mood

## Language

**Repository language:** English — all code, comments, documentation, commit messages, and AI instructions.

## General

- Prefer creating working code over theoretical discussions
- Document decisions and rationale
- Update relevant documentation when making changes
- Follow the AI-First methodology: use AI by default, manual intervention is the exception
- **Never commit without human approval** — always stage changes and wait
