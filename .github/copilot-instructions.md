# Copilot Instructions
<!-- BEGIN AI-FRAMEWORK (auto-generated, do not edit) -->

## Core Principles

1. **AI-First:** Use AI by default; manual intervention is the exception
2. **Human-gated:** Never commit without explicit approval
3. **Traceable:** Document decisions in PROVENANCE.md (ad-hoc) or epic trackers (formal)
4. **Test-driven:** Write tests first, implement, then refactor

## Project Paths
- EPIC_ROADMAP_PATH: `ROADMAP.md` (high-level epic list + status)
- EPIC_TECH_ROADMAP_PATH: `work/epics/epic-roadmap.md` (detailed technical view)
- EPICS_PATH: `work/epics/` (epic specifications and planning documentation)
- MILESTONE_PATH: `work/milestones/` (milestone specifications)
- MILESTONE_TRACKING_PATH: `work/milestones/tracking/` (milestone tracking documents)
- MILESTONE_RELEASES_PATH: `work/milestones/releases/` (completed milestone archives)
- GAPS_PATH: `work/GAPS.md` (project-specific gaps and discovered work)
- PROVENANCE_PATH: `PROVENANCE.md` (ad-hoc change log)
- CHANGELOG_PATH: `CHANGELOG.md` (release changelog)
- DEVELOPMENT_GUIDES_PATH: `docs/guides/` (development guides and conventions)
- SPECS_PATH: `work/specs/` (reusable templates and specifications)

## Framework Paths

- `.ai/agents/` — Agent definitions (canonical source)
- `.ai/skills/` — Skill definitions (canonical source)
- `.ai/instructions/` — Framework instructions
- `.ai/docs/` — Framework documentation

## Available Agents

- **architect** (`.github/agents/architect.agent.md`) — design decisions, system boundaries, and alignment with architecture docs.
- **deployer** (`.github/agents/deployer.agent.md`) — infrastructure, packaging, and release execution.
- **documenter** (`.github/agents/documenter.agent.md`) — documentation quality, consistency, and release notes.
- **implementer** (`.github/agents/implementer.agent.md`) — coding changes with minimal risk and clear intent.
- **maintainer** (`.github/agents/maintainer.agent.md`) — Repository infrastructure and AI framework maintenance (NOT solution development)
- **planner** (`.github/agents/planner.agent.md`) — convert epic scope into a sequenced milestone plan.
- **tester** (`.github/agents/tester.agent.md`) — test planning, TDD workflow, and regression safety.

## Available Skills

- **branching** (`.github/skills/branching.skill.md`) — Apply the milestone-driven branching strategy.
- **code-review** (`.github/skills/code-review.skill.md`) — Review changes for correctness, regressions, and missing tests.
- **context-refresh** (`.github/skills/context-refresh.skill.md`) — Reload critical context to maintain accuracy during long sessions or when context seems stale.
- **epic-refine** (`.github/skills/epic-refine.skill.md`) — Run a human-in-the-loop preflight to confirm epic scope, decisions, and constraints before any milestone specs are drafted.
- **epic-start** (`.github/skills/epic-start.skill.md`) — Initialize or confirm epic context before milestone planning or work begins.
- **epic-wrap** (`.github/skills/epic-wrap.skill.md`) — Close out an epic, sync docs, and coordinate merge to main.
- **framework-review** (`.github/skills/framework-review.skill.md`) — Evaluate framework effectiveness and plan improvements.
- **gap-triage** (`.github/skills/gap-triage.skill.md`) — Record gaps discovered during work and decide whether to include now or defer.
- **milestone-draft** (`.github/skills/milestone-draft.skill.md`) — Draft milestone specification documents after milestone planning is complete.
- **milestone-plan** (`.github/skills/milestone-plan.skill.md`) — Convert an epic into a sequenced milestone plan before any specs are drafted.
- **milestone-start** (`.github/skills/milestone-start.skill.md`) — Start or resume work on an existing milestone with TDD discipline.
- **milestone-wrap** (`.github/skills/milestone-wrap.skill.md`) — Complete a milestone, capture a milestone release summary, and prepare for PR or merge.
- **post-mortem** (`.github/skills/post-mortem.skill.md`) — Learn from workflow failures to improve the framework.
- **red-green-refactor** (`.github/skills/red-green-refactor.skill.md`) — Enforce TDD cadence and test-first workflow.
- **release** (`.github/skills/release.skill.md`) — Execute release ceremony after epic is wrapped and merged to main. This creates git tags and updates documentation. For infrastructure deployment, use the separate `deployment.md` skill.
- **roadmap** (`.github/skills/roadmap.skill.md`) — Maintain the lifecycle of epics between the high-level roadmap and epic architecture docs.
- **session-start** (`.github/skills/session-start.skill.md`) — Interactive session kickoff that guides users to the right role and task.

## Context Refresh Protocol

If the user says "refresh context" or "reload instructions":
1. Re-read the active agent file from `.github/agents/`
2. Check `ROADMAP.md` for current state
3. Check `work/epics/` and `work/milestones/tracking/` for current work
4. Summarize current state and confirm understanding

## Always-On Rules

See `.ai/instructions/ALWAYS_DO.md` for critical guardrails that apply to every session.

<!-- END AI-FRAMEWORK -->

<!-- Project-specific instructions below this line are preserved across syncs -->

## My Project Notes

LodeTime is a BEAM-based development companion.
