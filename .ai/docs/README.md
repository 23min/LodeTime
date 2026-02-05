# AI-First Development Framework

**Version:** 1.0.0  
**Status:** Production-ready  
**Purpose:** Portable, self-contained AI agent and skill system for structured software development

This framework provides role-based personas, reusable workflows, and guardrails for AI-assisted development. It can be adapted to any project following epic/milestone-driven development.

---

## What is This Framework?

The AI-First Development Framework is a methodology and toolset for building software with AI assistance while maintaining human control and quality standards. It structures development work around:

- **Agents** - AI personas with specific roles (architect, implementer, tester, etc.)
- **Skills** - Reusable workflow procedures (epic-start, milestone-start, red-green-refactor, etc.)
- **Epics** - Large initiatives spanning multiple milestones
- **Milestones** - Discrete, shippable units of work
- **Human gates** - Approval points ensuring human oversight

---

## Quick Links

### For Humans
- **[Learning Guide](learning-guide.md)** - How to use the framework
- **[Architecture](architecture.md)** - How the framework is structured (coming soon)
- **[Flowchart](flowchart.md)** - Visual representation of framework components
- **[Branching Strategy](branching-strategy.md)** - Git workflow for framework evolution
- **[Rationale](rationale.md)** - Design decisions and comparisons

### For AI Agents
- **[Agents](../agents/)** - Role definitions and responsibilities
- **[Skills](../skills/)** - Step-by-step workflow procedures
- **[Instructions](../instructions/)** - Global rules (ALWAYS_DO, GETTING_STARTED)
- **[Framework Gaps](../GAPS.md)** - Known issues and improvements

---

## Core Principles

1. **AI-First** - Use AI by default for implementation; manual intervention is the exception
2. **Human-Gated** - Never commit without explicit human approval
3. **Traceable** - Document all decisions in appropriate tracking locations
4. **Test-Driven** - Write tests first (RED), implement (GREEN), then refactor
5. **Role-Based** - Respect agent boundaries, escalate appropriately
6. **Epic-Scoped** - Organize features into cohesive epics with clear milestones
7. **Framework-Aware** - The framework evolves through use (maintainer agent)

---

## Framework Components

### Directory Structure

```
ai/                          # Complete AI framework
├── agents/                  # Role definitions (canonical source)
├── skills/                  # Workflow procedures
├── instructions/            # Global rules
├── scripts/                 # Automation (sync-agents.sh)
├── docs/                    # Framework documentation (for humans)
│   ├── README.md            # This file
│   ├── flowchart.md         # Visual diagram
│   ├── rationale.md         # Design decisions
│   ├── learning-guide.md    # Usage guide
│   └── branching-strategy.md # Git workflow
├── GAPS.md                  # Framework issues
└── README.md                # Quick reference

.github/                     # VS Code integration
└── agents/                  # Custom agents (auto-synced from .ai/agents/)
```

### Agents (Roles)

Agents are role-based AI personas available in VS Code's agent switcher dropdown (e.g., @architect, @planner). Custom agent files (`.github/agents/*.agent.md`) are automatically synced from canonical definitions (`.ai/agents/*.md`) during dev container setup.

- **Architect** - System design, epic planning, architectural decisions
- **Implementer** - Coding with minimal risk, following TDD
- **Tester** - Test planning, validation, regression safety
- **Documenter** - Documentation quality, release notes
- **Deployer** - Infrastructure, packaging, releases
- **Maintainer** - Framework evolution, repository infrastructure

### Skills (Workflows)

**Epic Lifecycle:**
- `epic-refine` → `epic-start` → `epic-wrap`

**Milestone Lifecycle:**
- `milestone-draft` → `milestone-start` → `milestone-wrap`

**Development:**
- `red-green-refactor` (TDD cycle)
- `code-review`
- `branching`

**Infrastructure:**
- `deployment`
- `release`

**Maintenance:**
- `context-refresh`
- `session-start`
- `gap-triage`
- `framework-review`

---

## Getting Started

### For New Users

1. Read [Learning Guide](learning-guide.md) for framework basics
2. Review [Flowchart](flowchart.md) for visual overview
3. Check project's `.github/copilot-instructions.md` for project-specific setup
4. Use `session-start` skill when beginning work

### For AI Agents

1. Load `.ai/instructions/ALWAYS_DO.md` for global rules
2. Consult relevant agent definition in `.ai/agents/`
3. Follow skill procedures in `.ai/skills/`
4. Reference this documentation when context is unclear

---

## Adapting to Your Project

This framework is designed to be portable. To use in a new project:

1. **Copy directory:**
   - Copy entire `.ai/` directory to your project (includes framework documentation)

2. **Customize paths:**
   - Update `.ai/README.md` with your project conventions
   - Update agent responsibilities for your team structure

3. **Configure Copilot:**
   - Update `.github/copilot-instructions.md` to reference framework

4. **Adjust workflows:**
   - Modify skills to match your release strategy
   - Update branching strategy for your git workflow

---

## Contributing to Framework

Framework improvements are tracked in `.ai/GAPS.md` and developed on the `framework/ai-evolution` branch. See [Branching Strategy](branching-strategy.md) for workflow details.

---

## Philosophy

### Test-Driven Development (TDD)
Always RED → GREEN → REFACTOR:
1. **RED**: Write failing test first
2. **GREEN**: Implement minimum code to pass
3. **REFACTOR**: Improve structure with tests still passing

### No Time Estimates
Never include hours, days, or effort estimates in documentation. Focus on:
- Clear requirements
- Testable acceptance criteria
- Scope boundaries

### Human Oversight
AI assists, but humans decide:
- Review all changes before commit
- Approve architectural decisions
- Validate acceptance criteria
- Control release timing

---

## Version History

See [FRAMEWORK-CHANGELOG.md](../ai/FRAMEWORK-CHANGELOG.md) for detailed version history.

---

**Maintained by:** Maintainer agent  
**Last Updated:** 2026-02-03
