# Framework Rationale: Why Not GitHub Spec Kit?

**Date:** 2026-01-29  
**Context:** Evaluation of GitHub Spec Kit vs our custom AI framework  
**Decision:** Continue with custom framework, optionally enhance with Spec Kit concepts

---

## Background

Both [GitHub Spec Kit](https://github.com/github/spec-kit) and the framework in this repository (`.ai/`) share a common ambition: **specification-driven development**. Rather than writing code directly and documenting it afterwards, both approaches elevate specifications to be the primary artifact that drives implementation.

**GitHub Spec Kit** is an open-source toolkit from GitHub that implements **Specification-Driven Development (SDD)**—a methodology where specifications become executable, directly generating working implementations. It provides CLI tools, templates, and slash commands (`/speckit.specify`, `/speckit.plan`, `/speckit.implement`) to transform natural language requirements into structured specifications and then into code, with AI handling much of the generation autonomously.

**Our AI Framework** (in the `.ai/` directory) implements **AI-First Development**—a structured approach using role-based AI agents (architect, implementer, tester, documenter, deployer, maintainer) and reusable skills (epic-refine, milestone-start, red-green-refactor, etc.) to manage the full software development lifecycle from epic planning through milestone execution to releases. The framework emphasizes human oversight at every commit while leveraging AI assistance for implementation.

Given their similar goals of using structured specifications to drive development quality and consistency, **a comparison is warranted** to determine whether adopting Spec Kit makes sense, or whether our custom framework better serves projects with specific needs around multi-epic orchestration, brownfield integration, and compliance requirements.

---

## Executive Summary

After evaluating GitHub's Spec Kit against our custom AI framework in `.ai/`, we've determined that **our framework is better suited for this project type**. While Spec Kit excels at feature-level specification-driven development, our framework provides the epic-level orchestration, human oversight, and brownfield flexibility required for complex enterprise projects.

**Key Reasons:**
- ✅ Multi-epic project management (Spec Kit is feature-flat)
- ✅ Human-gated process with approval requirements (Spec Kit is more autonomous)
- ✅ Agent role separation models real teams (Spec Kit assumes solo/pair)
- ✅ Brownfield/legacy integration support (Spec Kit optimized for greenfield)
- ✅ Zero tooling dependencies (Spec Kit requires Python CLI)
- ✅ Self-evolving framework (maintainer agent + framework-review skill)

---

## What is GitHub Spec Kit?

GitHub Spec Kit is an open-source toolkit for **Specification-Driven Development (SDD)**. It inverts the traditional code-first approach by making specifications executable—they generate working implementations rather than just guiding them.

**Core Philosophy:**
- Specifications are the source of truth, code is disposable output
- Features follow: constitution → specify → plan → tasks → implement
- AI generates code autonomously from detailed specifications
- Heavy use of templates to constrain LLM behavior for quality

**Key Components:**
- **CLI Tool** (`specify`): Automates project setup, branch creation, directory structure
- **Slash Commands**: `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`
- **Constitution**: 9 immutable articles (library-first, test-first, CLI-first, etc.)
- **Templates**: Structured specs with checklists, phase gates, `[NEEDS CLARIFICATION]` markers

---

## The Spec-Driven Development Landscape

GitHub Spec Kit is part of a broader movement toward specification-driven and AI-assisted development:

**[Kiro](https://kiro.work/work/specs/):** Spec-driven development platform with structured specification format, product specs as source of truth

**[Tessl](https://tessl.io/):** Spec-driven framework with registry/marketplace approach, emphasizes AI-native development with executable specifications

**Our Framework's Position:**
We're an **experimental, holistic SDLC framework** exploring AI integration from epic planning through release. While Spec Kit/Kiro/Tessl are mature, specialized tools focused on feature-level specification and code generation, we combine project orchestration, role-based collaboration, and human governance across the full lifecycle.

**Trade-offs:**
- Spec Kit/Kiro/Tessl: Proven products with automation, templates, ecosystems, team collaboration features
- Our framework: Experimental, minimal tooling, gaps in spec discipline (templates, formal WHAT/WHY/HOW separation), untested at scale
- Our ambition: Better spec generation guidance is a priority (see FW-GAP-003)

**Complementary:** These tools could be used *within* our framework (e.g., Spec Kit for milestone implementation)

---

## Framework Comparison

### Scope & Purpose

| Aspect | GitHub Spec Kit | Our Framework |
|--------|----------------|---------------|
| **Focus** | Single-feature spec → implementation | Multi-epic SDLC orchestration |
| **Granularity** | Features (001-photo-albums) | Epics → Milestones → Features |
| **Workflow** | Linear: constitution → specify → plan → tasks → implement | Hierarchical: epic-refine → milestone-draft → red-green-refactor → epic-wrap |
| **Output** | Generated code from specs | Managed development with human gates |
| **Scale** | Best for <100 features | Designed for multi-epic, multi-year projects |

### Philosophical Differences

**Spec Kit (Specification-Driven Development):**
- Specifications are **executable** - they directly generate code
- Code is treated as disposable, regenerated from specs
- AI works autonomously through full task lists
- Minimal human intervention during implementation

**Our Framework (AI-First Development):**
- Specifications **guide** AI-assisted development
- Code and specs co-evolve through iterative TDD
- AI assists, humans gate every commit
- Heavy human oversight: **"Never commit without approval"**

### Structure Comparison

**Spec Kit:**
```
project/
├── memory/
│   └── constitution.md (9 development articles)
├── specs/
│   └── 001-feature-name/
│       ├── spec.md (WHAT/WHY - no HOW)
│       ├── plan.md (HOW - tech stack, architecture)
│       ├── tasks.md (executable task list)
│       ├── data-model.md
│       ├── contracts/ (API specs)
│       └── quickstart.md
└── src/ (generated implementation)
```

**Our Framework:**
```
project/
├── ai/
│   ├── agents/ (WHO - roles: architect, implementer, tester, etc.)
│   ├── skills/ (HOW - reusable workflows)
│   └── instructions/ (ALWAYS_DO, GETTING_STARTED)
├── docs/
│   ├── architecture/ (epic planning phase)
│   ├── epics/
│   │   ├── active/ (execution phase)
│   │   └── completed/ (archived)
│   ├── milestones/
│   │   ├── tracking/ (progress logs)
│   │   └── completed/
│   └── specs/ (feature specifications)
├── PROVENANCE.md (ad-hoc change log)
└── src/ (AI-assisted implementation)
```

---

## Detailed Analysis

### ✅ Advantages of Our Framework

#### 1. Multi-Level Planning
- Handles complex projects with multiple epics spanning months/years
- Clear hierarchy: Epic → Milestone → Task
- Epic-level releases with proper wrap-up ceremonies
- **Spec Kit doesn't have "epic" concept** - it's flat feature lists

#### 2. Agent Role Clarity
- Explicit separation: architect, implementer, tester, documenter, deployer, maintainer
- Models real team dynamics and responsibilities
- Clear escalation paths: "Escalate to architect when spec is unclear"
- **Spec Kit assumes one AI assistant** does everything

#### 3. Human-Gated Process
- **Critical for compliance:** Never commits without approval
- Stage changes, show diff, wait for approval, then commit
- Better for regulated environments, auditing, traceability
- **Spec Kit encourages autonomous generation** via `/speckit.implement`

#### 4. Process Flexibility
- Handles ad-hoc work (PROVENANCE.md for quick fixes)
- Gap tracking for discovered out-of-scope work
- Post-mortems for learning from failures
- Brownfield integration patterns
- **Spec Kit is more prescriptive** - optimized for greenfield

#### 5. Lightweight & Portable
- Pure markdown, works with any AI assistant (Copilot, Claude, Cursor, etc.)
- No external dependencies (Python, uv, etc.)
- Skills automate file operations (tracking docs, roadmaps, specs)
- **Spec Kit requires:** Python 3.11+, uv, specify-cli tool for project scaffolding
- **Our gap:** No CLI for initial project setup (epic folders created manually)

#### 6. Framework Self-Improvement
- `maintainer` agent owns framework evolution
- `framework-review` skill for periodic assessment
- `post-mortem` skill captures learnings
- Framework designed to evolve with project
- **Spec Kit is external** - harder to customize deeply

#### 7. Epic-Level Release Management
- `epic-wrap` handles major releases (changelog, tags, PRs)
- Supports both epic and milestone releases
- Clear branching strategies (epic integration vs mainline)
- **Spec Kit focuses on feature completion** only

#### 8. Incremental TDD Workflow
- `red-green-refactor` skill for disciplined development
- Explicit RED → GREEN → REFACTOR phases
- Milestones have Definition of Done checklists
- **Spec Kit generates larger code blocks** autonomously

### ✅ Advantages of Spec Kit

#### 1. Automated Tooling
- `specify init` creates full project structure
- Auto-generates branch names, feature numbers
- Slash commands streamline workflow (`/speckit.specify`, `/speckit.plan`)
- **Our framework requires manual file/directory management**

#### 2. Stronger Specification Discipline
- Enforces strict WHAT/WHY (spec.md) vs HOW (plan.md) separation
- `[NEEDS CLARIFICATION]` convention forces explicit uncertainty
- Templates act as "unit tests for English"
- Checklists prevent common specification errors
- **Our framework has less formal spec structure**

#### 3. Constitutional Governance
- 9 immutable articles (library-first, test-first, CLI-first, etc.)
- Phase gates enforce principles before implementation:
  - Simplicity Gate (≤3 projects?)
  - Anti-Abstraction Gate (use framework directly?)
  - Integration-First Gate (contracts defined?)
- **Our ALWAYS_DO.md has guardrails but less formal enforcement**

#### 4. AI-First Code Generation
- Designed for AI to generate large amounts of code autonomously
- `/speckit.implement` executes full task list without human per-line approval
- Optimized for speed (15 min spec → plan → tasks → code)
- **Our framework is more incremental** (human reviews each change)

#### 5. Consistency Validation
- `/speckit.analyze` checks cross-artifact consistency
- `/speckit.checklist` generates quality validation checklists
- `/speckit.clarify` identifies underspecified areas
- **Our framework relies on manual code-review skill**

#### 6. Feature Isolation
- Each feature fully self-contained: spec, plan, contracts, tests, data model
- Easier to parallelize work or regenerate features
- Clear feature boundaries with explicit contracts
- **Our framework is more monolithic** (epic-level tracking docs)

#### 7. Better for Greenfield
- Optimized for 0→1 "build from scratch" scenarios
- Templates assume no legacy constraints
- Quick feature exploration and iteration
- **Our framework is more adaptable to existing codebases**

---

## Why NOT Use Spec Kit for This Framework

### 1. Lock-In Concerns (Valid)

**Tooling Dependency:**
- Requires Python 3.11+, uv package manager, specify-cli
- Slash commands require compatible AI assistants
- Tightly coupled to Spec Kit's directory structure
- Migration cost to restructure existing `docs/` hierarchy

**Template Dependency:**
- Features must follow spec/plan/tasks structure
- Hard to adapt for epic-level work
- Would need to fork/modify templates extensively

**Risk:** If Spec Kit changes or becomes unmaintained, we're stuck.

### 2. Mismatched Scale

**Spec Kit is feature-focused:**
```
001-photo-albums → spec → plan → tasks → implement
002-user-auth → spec → plan → tasks → implement
003-settings → spec → plan → tasks → implement
```

**This framework needs epic orchestration:**
```
Epic: Large Initiative (6+ months)
├── M-01: Foundation Setup (3 weeks)
├── M-02: Data Migration (2 weeks)
├── M-03: API Layer (3 weeks)
├── M-04: UI Dashboard (4 weeks)
└── Epic Wrap → Release v1.0.0 → Git tag

Epic: Infrastructure Work (4+ months)
├── M-01: Template Foundation
├── M-02: Deployment Automation
...
```

**Spec Kit has no concept of "epics" or "milestones"** - just a flat list of features. Our project spans multiple interconnected epics with dependencies, sequencing, and major release milestones.

### 3. Compliance/Control Requirements

Our `ALWAYS_DO.md` states:
> **⚠️ CRITICAL: Never Commit Without Approval**
> 
> NEVER run `git commit` without explicit human approval.
> Always: 1) Stage changes, 2) Show what will be committed, 3) Wait for human approval, 4) Only then commit when explicitly instructed

**Spec Kit's `/speckit.implement`** is designed to:
- Execute full task list autonomously
- Generate code without line-by-line review
- Commit changes as part of automated workflow

This **directly conflicts** with our human-gated philosophy. We need oversight at every commit for:
- Compliance/audit trails
- Knowledge retention (humans understand changes)
- Risk mitigation (no surprise AI changes)

### 4. Brownfield Complexity

**Many real projects involve:**
- Extracting functionality from legacy systems
- Working with existing data pipelines and dashboards
- Infrastructure templates that integrate with existing cloud resources
- Incremental modernization, not greenfield development

**Spec Kit is optimized for greenfield:**
- "Build an application that can help me organize my photos..."
- Assumes starting from empty repository
- Templates don't address legacy integration patterns
- Constitution (library-first, CLI-first) may not fit existing systems

**Our framework handles brownfield better:**
- Gap tracking for discovered constraints
- Ad-hoc work support (PROVENANCE.md)
- Flexible milestone structure adapts to existing code
- Post-mortems capture integration learnings

### 5. Already Have Working Process

**We've invested significant effort:**
- 6 agent definitions (architect, implementer, tester, documenter, deployer, maintainer)
- 16 production-ready skills (epic-refine, milestone-start, red-green-refactor, etc.)
- Epic/milestone tracking infrastructure in `docs/`
- Framework v1.0.0 with comprehensive changelog
- Active epic (Critical Flow Reporting) using current framework

**Switching cost >> benefit:**
- Would need to migrate all `work/epics/` and `work/milestones/` to Spec Kit structure
- Retrain AI assistants on new slash commands
- Install and maintain specify-cli tooling
- Re-document all workflows
- Risk: disrupting active development

**Better strategy:** Evolve current framework with lessons from Spec Kit.

---

## What We Can Borrow from Spec Kit

Rather than wholesale adoption, we can enhance our framework with Spec Kit's best ideas:

### 1. Specification Templates

**Create:** `work/specs/templates/`
- `feature-spec-template.md` - Enforce WHAT/WHY only (no HOW)
- `implementation-plan-template.md` - HOW separately (tech stack, architecture)

**Benefits:**
- Clearer separation of concerns
- Better specs that don't mix requirements and implementation
- Easier to regenerate implementations from stable specs

**Effort:** 1-2 hours

### 2. Phase Gates

**Enhance:** `.ai/skills/milestone-start.md` tracking doc template

Add:
```markdown
## Phase -1: Pre-Implementation Gates

### Requirement Completeness
- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] All requirements are testable and unambiguous
- [ ] Success criteria are measurable

### Simplicity Check
- [ ] Using ≤3 new components/projects?
- [ ] No future-proofing or speculative features?
- [ ] Minimal abstraction layers?

### Test Readiness
- [ ] Test strategy defined (unit, integration, e2e)
- [ ] Contracts/interfaces documented
- [ ] Test fixtures/mocks identified
```

**Benefits:**
- Catches issues before coding starts
- Forces explicit readiness assessment
- Reduces rework from incomplete planning

**Effort:** 1 hour

### 3. Development Principles (Constitution-Like)

**Create:** `docs/development/principles.md`

Document our architectural principles:
- **Test-First Imperative:** No code before failing tests
- **Minimal Abstraction:** Use framework features directly, avoid wrapper layers
- **Integration Over Mocks:** Prefer real databases/services in tests
- **Simplicity Gate:** Justify every component (max 3 new projects per milestone)
- **Library-First Design:** Reusable modules over monolithic code

**Reference from:** `.ai/instructions/ALWAYS_DO.md`

**Benefits:**
- Explicit architectural guardrails
- Consistent decision-making across agents
- Onboarding documentation for new contributors

**Effort:** 1-2 hours

### 4. Uncertainty Markers Convention

**Add to:** `.ai/instructions/ALWAYS_DO.md`

Adopt `[NEEDS CLARIFICATION: specific question]` convention:
- Use in specs when requirements are ambiguous
- Use in tracking docs when design decisions are uncertain
- Forces explicit acknowledgment of unknowns
- Better than "TBD" or "TODO" (no specificity)

**Benefits:**
- AI can't make silent assumptions
- Human reviews know exactly what to clarify
- Reduces miscommunication

**Effort:** 30 minutes

### 5. Consistency Validation Skill

**Create:** `.ai/skills/consistency-check.md`

New skill that validates:
- Do tests cover all requirements from spec?
- Are API contracts consistent with data models?
- Are acceptance criteria met by implementation?
- Cross-document traceability (spec → plan → code)

Run before `milestone-wrap` as final quality gate.

**Benefits:**
- Catches specification drift
- Ensures completeness
- Quality assurance automation

**Effort:** 2-3 hours

---

## Recommended Path Forward

### Phase 1: Continue with Our Framework ✅

**No immediate changes required.** Our framework is production-ready (v1.0.0) and well-suited for complex enterprise projects.

**Active work continues:**
- Complete Critical Flow Reporting epic using current framework
- Use existing agent/skill system
- Follow current epic → milestone → release lifecycle

### Phase 2: Selective Enhancements (Optional)

If we want Spec Kit's discipline without lock-in:

**Priority 1 (High Value, Low Effort):**
1. Add `[NEEDS CLARIFICATION]` convention to ALWAYS_DO.md (30 min)
2. Create phase gates in milestone-start.md (1 hour)
3. Document development principles (1-2 hours)

**Priority 2 (Medium Value, Medium Effort):**
4. Create specification templates (1-2 hours)
5. Build consistency-check skill (2-3 hours)

**Total effort:** 5-8 hours spread over multiple sessions

**Benefit:** Improved specification quality and consistency validation without framework disruption.

### Phase 3: Framework Review (After Epic Completion)

Use `framework-review` skill after completing Critical Flow Reporting epic:
- What worked well? What was painful?
- Are there more Spec Kit concepts worth adopting?
- Should we formalize our constitution?
- Do we need automation tooling (like specify CLI)?

Decision point for deeper integration or divergence.

---

## Comparison Matrix

| Criterion | GitHub Spec Kit | Our Framework | Winner |
|-----------|----------------|----------------|--------|
| **Feature-level specs** | ★★★★★ (excellent templates) | ★★★☆☆ (less formal) | Spec Kit |
| **Epic-level orchestration** | ★☆☆☆☆ (no concept) | ★★★★★ (core strength) | **Our Framework** |
| **Automation (CLI tools)** | ★★★★★ (full CLI) | ★☆☆☆☆ (manual) | Spec Kit |
| **Human oversight** | ★★☆☆☆ (autonomous) | ★★★★★ (gated) | **Our Framework** |
| **Brownfield support** | ★★☆☆☆ (greenfield-first) | ★★★★☆ (flexible) | **Our Framework** |
| **Portability** | ★★☆☆☆ (Python deps) | ★★★★★ (pure markdown) | **Our Framework** |
| **Specification discipline** | ★★★★★ (strict templates) | ★★★☆☆ (informal) | Spec Kit |
| **Process flexibility** | ★★★☆☆ (prescriptive) | ★★★★★ (adaptable) | **Our Framework** |
| **Greenfield 0→1** | ★★★★★ (optimized) | ★★★☆☆ (capable) | Spec Kit |
| **Multi-epic projects** | ★☆☆☆☆ (not designed) | ★★★★★ (designed for) | **Our Framework** |
| **Team role modeling** | ★★☆☆☆ (solo/pair) | ★★★★★ (6 agents) | **Our Framework** |
| **Self-evolution** | ★★☆☆☆ (external) | ★★★★★ (maintainer agent) | **Our Framework** |

**Overall:** Our framework wins on most criteria that matter for multi-epic enterprise projects. Spec Kit excels at feature-level work, but we need epic-level orchestration.

---

## Conclusion

**Decision: Continue with our custom framework.**

**Rationale:**
1. **Scale Match:** Our framework handles multi-epic, multi-year projects. Spec Kit is feature-focused.
2. **Control Requirements:** Human-gated commits are critical. Spec Kit is more autonomous.
3. **Brownfield Fit:** Many projects involve legacy extraction, not greenfield. Our framework handles this better.
4. **Investment Protection:** We have a working v1.0.0 framework with active epics. Switching cost is high.
5. **Flexibility:** Our framework adapts to ad-hoc work, gaps, post-mortems. Spec Kit is prescriptive.
6. **Portability:** No tooling dependencies means we work anywhere. Spec Kit needs Python ecosystem.

**Lock-In Concerns are Valid:**
- Spec Kit requires Python CLI, uv, specific directory structure
- Hard to migrate away once adopted
- External project (harder to customize deeply)

**Best of Both Worlds:**
- Adopt Spec Kit's specification discipline (templates, phase gates, `[NEEDS CLARIFICATION]`)
- Keep our framework's orchestration, agent roles, human gates, and flexibility
- Enhance rather than replace

**When Spec Kit Would Be Better:**
- Pure greenfield project (no legacy)
- Solo developer or small team
- Feature factory (many independent features)
- Trust AI for autonomous code generation
- Python-first ecosystem

**For complex projects:** Our framework is the right tool for the job.

---

**Version:** 1.0
**Last Updated:** 2026-01-29
**Review Status:** Initial analysis, to be revisited after first epic completion