# GitHub Copilot Instructions for LodeTime

This file routes to the canonical AI instructions maintained in `ai/`.

## Quick Reference

- **New to this project?** See `ai/instructions/GETTING_STARTED.md` for common workflows and questions
- **Always-on rules:** See `ai/instructions/ALWAYS_DO.md`
- **Agent definitions:** See `ai/agents/` for role-specific perspectives
- **Skills/workflows:** See `ai/skills/` for repeatable procedures
- **Project context:** See `docs/` for architecture, specs, and epics

## Core Principles (Summary)

1. **AI-First:** Use AI by default; manual intervention is the exception
2. **Human-gated:** Never commit without explicit approval
3. **Traceable:** Document decisions in PROVENANCE.md (ad-hoc) or epic trackers (formal)
4. **Test-driven:** Write tests first, implement, then refactor

## Project Context

This is an AI-First development project with three main pillars:
1. **Critical Flow Reporting** - Extracting functionality from PerfOps
2. **InfrastructureTemplate** - Deployment automation with AI assistance
3. **AI-First Methodology** - Reference framework for agent-driven development

## Project Structure

- `ai/instructions/` - Always-on rules and guidelines
- `ai/agents/` - Role-based agent definitions (WHO)
- `ai/skills/` - Workflow procedures (HOW)
- `docs/` - Architecture, specs, and epic documentation
- `wiki/` - Human-readable process documentation (Swedish)
- `PROVENANCE.md` - Ad-hoc change log

## Available Agents

- **Implementer** (`ai/agents/implementer.md`) - Software developer focused on code quality

*More agents coming soon: Architect, Tester, Documenter, Deployer*

## Available Skills

- **epic-start** (`ai/skills/epic-start.md`) - Initialize a new epic with proper structure

*More skills coming soon: epic-wrap, milestone-start, red-green-refactor, code-review*

## Context Refresh Protocol

If the user says "refresh context" or "reload instructions":
1. Re-read `ai/instructions/ALWAYS_DO.md`
2. Re-read the active agent file from `ai/agents/` (if in specific role)
3. Check `docs/epics/active/` and `docs/milestones/tracking/` for current work
4. Summarize current state and confirm understanding

This helps maintain accuracy during long sessions. See `ai/skills/context-refresh.md` for full procedure.

## Getting Started

1. Read `ai/instructions/ALWAYS_DO.md` for critical rules
2. Check `docs/epics/active/` to understand current work
3. Consult relevant agent definition for role-specific guidance
4. Use skills for repeatable workflows

For complete instructions, always consult the `ai/` directory.
