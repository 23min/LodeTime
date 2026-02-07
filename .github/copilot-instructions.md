# GitHub Copilot Instructions for LodeTime

This file routes to the synced AI instructions maintained in `.github/`.

## Quick Reference

- **Project state:** See `ROADMAP.md` for current phase, active epic, and context
- **Always-on rules:** See `.github/instructions/ALWAYS_DO.md` (if synced) or `.ai/instructions/ALWAYS_DO.md`
- **Agent definitions:** See `.github/agents/` for role-specific perspectives
- **Skills/workflows:** See `.github/skills/` for repeatable procedures
- **Project context:** See `docs/` for architecture/design and `work/` for epics/milestones

## Core Principles (Summary)

1. **AI-First:** Use AI by default; manual intervention is the exception
2. **Human-gated:** Never commit without explicit approval
3. **Traceable:** Document decisions in PROVENANCE.md (ad-hoc) or epic trackers (formal)
4. **Test-driven:** Write tests first, implement, then refactor

## Project Context

LodeTime is a BEAM-based living development companion. See `ROADMAP.md` for current phase and active work.

## Project Structure

- `.lodetime/` - Architecture definitions (source of truth)
- `lib/lodetime/` - Elixir runtime source
- `cmd/lodetime-cli/` - Go CLI source
- `docs/` - Architecture and design documentation
- `work/` - Epics, milestones, and tracking docs

## Available Agents

- **Architect** (`.github/agents/architect.agent.md`) - System design, epic planning
- **Planner** (`.github/agents/planner.agent.md`) - Milestone planning
- **Implementer** (`.github/agents/implementer.agent.md`) - Code quality focused development
- **Tester** (`.github/agents/tester.agent.md`) - Test planning and validation
- **Documenter** (`.github/agents/documenter.agent.md`) - Documentation and release notes
- **Deployer** (`.github/agents/deployer.agent.md`) - Release and deployment
- **Maintainer** (`.github/agents/maintainer.agent.md`) - Framework evolution

## Available Skills

- **session-start** (`.github/skills/session-start.skill.md`) - Interactive session kickoff
- **epic-start** (`.github/skills/epic-start.skill.md`) - Initialize a new epic
- **epic-wrap** (`.github/skills/epic-wrap.skill.md`) - Close out an epic
- **milestone-plan** (`.github/skills/milestone-plan.skill.md`) - Define milestone plan
- **red-green-refactor** (`.github/skills/red-green-refactor.skill.md`) - TDD cycle
- **gap-triage** (`.github/skills/gap-triage.skill.md`) - Handle scope gaps
- **code-review** (`.github/skills/code-review.skill.md`) - Review checklist

## Context Refresh Protocol

If the user says "refresh context" or "reload instructions":
1. Re-read the active agent file from `.github/agents/`
2. Check `ROADMAP.md` for current state
3. Check `work/epics/` and `work/milestones/tracking/` for current work
4. Summarize current state and confirm understanding

## Getting Started

1. Check `ROADMAP.md` for current phase and active work
2. Check `work/epics/` to understand current epic
3. Consult relevant agent definition for role-specific guidance
4. Use skills for repeatable workflows

---

**Note:** Agents and skills in `.github/` are synced from `.ai/` (canonical source).
To update, edit files in `.ai/` and run `.ai/scripts/sync-to-copilot.sh`.
