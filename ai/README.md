# AI-Assisted Development Framework

**Purpose:** Portable, self-contained AI agent and skill system for structured software development.

This framework provides role-based personas, reusable workflows, and guardrails for AI-assisted development. It can be adapted to any project following epic/milestone-driven development.

---

## Quick Start

**Starting a new session?**
→ Use [skills/session-start.md](skills/session-start.md) - it will guide you to the right agent and skill.

**Need specific help?**
- Planning an epic → [skills/epic-refine.md](skills/epic-refine.md)
- Planning milestones → [skills/milestone-plan.md](skills/milestone-plan.md)
- Implementing a milestone → [skills/milestone-start.md](skills/milestone-start.md)
- Writing tests → [skills/red-green-refactor.md](skills/red-green-refactor.md)
- Releasing → [skills/release.md](skills/release.md)
- Handling a gap → [skills/gap-triage.md](skills/gap-triage.md)

---

## Structure

### 📁 agents/
Role-based personas that define focus areas and responsibilities:
- **architect** - Design decisions, system boundaries, epic planning
- **planner** - Milestone decomposition, sequencing, dependencies
- **implementer** - Coding with minimal risk, following TDD
- **tester** - Test planning, TDD workflow, regression safety
- **documenter** - Documentation quality, release notes
- **maintainer** - AI framework evolution (agents/skills), repository infrastructure

### 📁 skills/
Reusable workflows for common development tasks:
- **Epic lifecycle**: epic-refine → epic-start → epic-wrap
- **Milestone lifecycle**: milestone-draft → milestone-start → milestone-wrap
- **Development**: red-green-refactor, code-review
- **Infrastructure**: branching, release (deployment is in inactive/)
- **Planning**: milestone-plan, roadmap, gap-triage
- **Framework maintenance**: framework-review, post-mortem

Project-specific skills live in `skills/custom/`.
Library but inactive skills live in `skills/inactive/`.

**Custom (LodeTime) skills:** architecture-spec-maintenance, component-refine, phase-progress

### Skills Index

**Active (core):** branching, code-review, epic-refine, epic-start, epic-wrap, framework-review, gap-triage, milestone-draft, milestone-plan, milestone-start, milestone-wrap, post-mortem, red-green-refactor, release, roadmap, session-start

**Custom (project):** architecture-spec-maintenance, component-refine, phase-progress

**Inactive (library):** deployment, ui-debug

### 📁 instructions/
Global guardrails that apply to every session:
- **ALWAYS_DO.md** - Core rules, session hygiene, build/test requirements

---

## Layering

Keep responsibilities clear to avoid leaking project specifics into the framework.

- **Framework layer (`ai/`)**: portable agents, skills, and instructions. Avoid project-specific paths here unless routed through overrides.
- **Project layer (repo root)**: product artifacts (`.lodetime/`, `docs/`, `lib/`, `cmd/`, `ROADMAP.md`).
- **Bridge layer (overrides)**: `ai/instructions/PROJECT_PATHS.md` and `skills/custom/` connect the framework to this project.

---

## Project Conventions

This framework assumes standard paths. If your project differs, update this section and global-search-replace references.

### Standard Paths
- Epic roadmap: `EPIC_ROADMAP_PATH` (high-level), `EPIC_TECH_ROADMAP_PATH` (detailed technical)
- Changelog: `CHANGELOG.md` (root, high-level epic releases)
- Architecture: `dev/architecture/<epic-slug>/` (planning phase, ADRs)
- Epics: `dev/epics/active/` (execution phase), `dev/epics/completed/` (archived)
- Epic releases: `dev/epics/releases/<epic-slug>.md` (authoritative release documentation)
- Milestones: `dev/milestones/` (active specs), `dev/milestones/completed/` (archived)
- Milestone tracking: `dev/milestones/tracking/` (progress logs)
- Milestone releases: Release notes section within milestone spec itself
- Milestone naming: `M-<epic-slug>-XX[-suffix]` (see dev/specs/templates/milestone-naming-convention.md)
- Gaps: `dev/gaps.md` (discovered work out of scope)
- Specs: `dev/specs/` (feature specifications)
- Development guides: `dev/development/`
- Copilot rules: `.github/copilot-instructions.md`
- Test results: tracking docs
- Git tags: `epic/<epic-slug>` (for epic releases only, no milestone tags)

See `ai/instructions/PROJECT_PATHS.md` for concrete values in this repo.

### Overrides for This Project
- **Path overrides live in** `ai/instructions/PROJECT_PATHS.md`.
- **Phase roadmap:** `docs/phases/IMPLEMENTATION-PHASES.md` (phases are not epics).
- **Architecture source of truth:** `.lodetime/`.

Note: Epics are tracked separately from phases; a phase can contain multiple epics.

---

## Development Lifecycle

**Note:** Agent labels show primary responsibility. Many steps involve coordination across multiple agents.

### 1. Epic-Level Work (Large Initiatives)

Epic work spans multiple milestones and culminates in a major release:

```
epic-refine (architect)
  ↓
epic-start (architect)
  ↓
milestone-plan (planner)
  ↓
milestone-draft (documenter)
  ↓
[Execute milestones - see Milestone Work below]
  ↓
epic-wrap (documenter + architect)
  ↓
[PR or direct merge to main]
  ↓
release (documenter) - Epic release ceremony
```

**Epic-wrap involves:**
- Documenter: Archive milestone specs, update roadmaps
- Architect: Verify architecture docs align with implementation

### 2. Milestone-Level Work (Discrete Features)

Individual milestones within an epic (or standalone):

```
milestone-draft (documenter)
  ↓
milestone-start (implementer)
  ↓
red-green-refactor (implementer + tester)
  ↓
code-review (tester)
  ↓
milestone-wrap (documenter)
```

**After milestone-wrap:**
- **If last milestone in epic** → epic-wrap (see Epic Work above)
- **If interim milestone** → Optional tag/deploy, continue to next milestone
- **If standalone milestone** → Optional release ceremony

---

## Ownership & Handoffs

Use this to prevent overlap and make cross‑agent sequencing explicit.

**Ownership (single source of truth):**
- Architect: `dev/architecture/**`, epic scope/decisions, merge strategy
- Planner: Milestone Plan section in `dev/architecture/<epic-slug>/README.md`
- Documenter: `dev/epics/**`, `dev/milestones/**` (specs), `CHANGELOG.md`
- Implementer: code + tests + **tracking progress only** in tracking docs
- Tester: test plan/coverage in tracking docs + review sign‑off
- Maintainer: `ai/**` only (framework), not project content

**Handoff artifacts (required):**
- Architect → Planner: epic summary + constraints + non‑goals
- Planner → Documenter: Milestone Plan section (IDs, scope, dependencies, order)
- Documenter → Implementer: finalized milestone spec + tracking doc
- Implementer → Tester: test results + status updates in tracking doc
- Documenter → Architect: release notes/roadmap updates for epic wrap

**Release sources of truth:**
- Milestone spec + tracking doc are authoritative for what shipped
- Epic-wrap summarizes milestone release notes; `CHANGELOG.md` updates only in epic-wrap
- Release skill tags/publishes only; no doc edits

**Gap handling:**
- Gaps are out-of-scope by default; review with architect/planner
- Rarely, include in the current milestone (requires architect + documenter approval)
- Otherwise plan into an epic/milestone or treat as one-off work on a separate branch
- One-off work requires explicit user approval and PROVENANCE.md logging

### 3. Release Strategies

**Milestone Release (interim/optional):**
```
milestone-wrap
  ↓
[Optional: Tag milestone version]
  ↓
[Optional: Deploy to staging/preview]
```

**Epic Release (major):**
```
epic-wrap (all milestones complete)
  ↓
[PR or direct merge to main - architect decides]
  ↓
release (documenter) - Version bump, changelog, tag
  ↓
[Deploy to production]
  ↓
[Notify team]
```

---

## Trigger Phrases

### When the user says...

| User Request | Use This Skill |
|-------------|----------------|
| "Start a new epic" | [epic-refine](skills/epic-refine.md) |
| "Plan milestones for epic X" | [milestone-plan](skills/milestone-plan.md) |
| "Plan milestone X" | [milestone-draft](skills/milestone-draft.md) |
| "Begin milestone X" / "Continue M-X" | [milestone-start](skills/milestone-start.md) |
| "Write tests for..." | [red-green-refactor](skills/red-green-refactor.md) |
| "Review this code" | [code-review](skills/code-review.md) |
| "Create a branch" | [branching](skills/branching.md) |
| "Complete milestone X" | [milestone-wrap](skills/milestone-wrap.md) |
| "Create a release" | [release](skills/release.md) |
| "We found a gap" / "This is missing" | [gap-triage](skills/gap-triage.md) |
| "Which task should I start?" | [session-start](skills/session-start.md) |

---

## Key Concepts

### Epics
Large architectural or product themes that span multiple milestones. Examples:
- Add class-based routing to engine
- Implement simulation service with buffer support
- Build UI performance dashboard

### Milestones
Discrete, shippable units of work with clear acceptance criteria. Examples:
- M-02.10: Add provenance query API
- UI-M-03.05: Build timeline visualization
- SIM-M-01.02: Parse YAML templates

### Branches
- **main** - Always green and releasable
- **epic/<slug>** - Integration branch for multi-milestone epics
- **milestone/mX** - Integration branch for multi-surface milestones
- **feature/<surface>-mX/<desc>** - Actual work branches

### Tracking
- **Milestone spec** - Authoritative requirements (stable)
- **Tracking doc** - Implementation progress (dynamic)
- Keep specs stable, update tracking docs frequently

---

## Glossary

**Core Terms:**
- **Epic** - Large architectural or product initiative spanning multiple milestones
- **Milestone** - Discrete, shippable unit of work with clear acceptance criteria
- **AC** - Acceptance Criteria; testable conditions that define milestone completion
- **DoD** - Definition of Done; checklist that must be satisfied before considering work complete
- **TDD** - Test-Driven Development; RED (write failing test) → GREEN (implement) → REFACTOR
- **Spec** - Milestone specification; authoritative requirements document (kept stable)
- **Tracking doc** - Implementation progress log (updated frequently)
- **Session log** - Record of decisions, tool usage, and actions during a work session

**Workflow Terms:**
- **Preflight checks** - Validations run before starting a skill (e.g., epic context exists)
- **Handoff** - Transition from one skill/agent to another with context transfer
- **Gap** - Discovered work not in current milestone scope; triaged for future work
- **Post-mortem** - Reflection on workflow failures to improve framework

**Agent Roles:**
- **Architect** - System design, epic planning, architectural decisions
- **Planner** - Milestone decomposition, sequencing, dependencies
- **Implementer** - Coding with minimal risk, following TDD
- **Tester** - Test planning, validation, regression safety
- **Documenter** - Documentation quality, release notes
- **Maintainer** - AI framework evolution (agents/skills), repository infrastructure (NOT solution development)

---

## Adapting to Your Project

To use this framework in a different project:

1. **Update ALWAYS_DO.md** with your project's conventions
2. **Customize agent responsibilities** for your team structure
3. **Adjust skill references** to match your documentation structure
4. **Modify trigger phrases** for your workflow terminology
5. **Update release skill** for your versioning strategy

---

## Philosophy

### Test-Driven Development (TDD)
Always RED → GREEN → REFACTOR:
1. **RED**: Write failing test first
2. **GREEN**: Implement minimum code to pass
3. **REFACTOR**: Improve structure with tests still passing

### No Time Estimates
Never include hours, days, or effort estimates in milestone docs. Focus on:
- Clear requirements
- Testable acceptance criteria
- Scope boundaries

### Milestone-First
Work is organized around milestones, not arbitrary sprints or dates:
- Milestones have clear success criteria
- Milestones ship to main when complete
- Next milestone branches from current branch

### Documentation Sync
When milestones or epics complete, documentation must be updated:
- Roadmaps reflect current status
- Architecture docs match reality
- Release notes capture what shipped

---

## Quick Reference Card

```
📋 Planning Phase
  ├─ epic-refine    → Clarify scope and decisions
  ├─ milestone-draft → Write specification
  ├─ gap-triage     → Record and route gaps
  └─ branching      → Create work branch

🔄 Implementation Phase
  ├─ milestone-start      → Begin work, create tracking
  ├─ red-green-refactor   → TDD loop
  └─ code-review          → Validate changes

✅ Completion Phase
  ├─ milestone-wrap → Mark complete, update docs
  ├─ milestone release summary → Capture what shipped
  ├─ release        → Version bump, tag, release notes
  └─ epic-wrap      → Archive milestone specs together

🔧 Framework Maintenance
  ├─ post-mortem     → Learn from workflow failures
  └─ framework-review → Evaluate framework effectiveness
```

---

## Anti-Patterns to Avoid

❌ **Don't:**
- Include time/effort estimates in milestone docs
- Skip writing tests before implementation
- Merge to main without updating documentation
- Use ASCII art diagrams (use Mermaid instead)
- Start coding without a clear milestone spec
- Create branches without checking current branch context

✅ **Do:**
- Write tests first (RED phase)
- Keep milestone specs stable, tracking docs dynamic
- Update roadmaps and docs when milestones complete
- Use Mermaid for diagrams
- Confirm epic context before starting milestones
- Follow conventional commit messages

---

## Getting Help

1. **Unclear which skill to use?** → Start with [session-start](skills/session-start.md)
2. **Need to plan big work?** → Use [epic-refine](skills/epic-refine.md)
3. **Ready to code?** → Use [milestone-start](skills/milestone-start.md)
4. **Tests failing?** → Review [red-green-refactor](skills/red-green-refactor.md)
5. **Wrapping up?** → Use [milestone-wrap](skills/milestone-wrap.md)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28
