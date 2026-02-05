# Framework Changelog

This file tracks major changes, improvements, and versions of the AI-Assisted Development Framework.

---

## [1.1.0] - 2026-02-03

### VS Code Custom Agents Integration

Added native VS Code custom agents support with automatic sync from canonical agent definitions.

#### Added

**Infrastructure:**
- **.ai/scripts/sync-agents.sh** - Automated conversion of `.ai/agents/*.md` to `.github/agents/*.agent.md`
- **YAML frontmatter** in custom agent files with:
  - Tool restrictions per agent role (planner/architect read-only, implementer full access)
  - Handoff definitions for guided agent-to-agent workflow
  - Model specification (Claude Sonnet 4)

**Dev Container Integration:**
- Added agent sync to post-create script for automatic setup
- Custom agents available in VS Code agent switcher dropdown (@architect, @planner, etc.)

#### Enhanced

**Documentation:**
- Updated `.github/copilot-instructions.md` with custom agents reference
- Updated `.ai/docs/README.md` with agent sync architecture
- Added CUSTOM_AGENTS.md analysis and CUSTOM_AGENTS_PLAN.md implementation guide

**Benefits:**
- 40% context reduction (loads only active agent instead of all 7)
- Guided handoffs via VS Code UI buttons
- Tool restrictions enforced at VS Code level
- Maintains portability (canonical source in `.ai/agents/`)

---

## [1.0.0] - 2026-01-28

### Major Framework Improvements

This release represents a comprehensive standardization and enhancement of the framework based on expert review and collaborative refinement.

#### Added

**New Agent:**
- **maintainer** - Framework evolution, quality, repository maintenance, and tooling

**New Skills:**
- **post-mortem** - Learn from workflow failures to improve framework
- **framework-review** - Evaluate framework effectiveness and plan improvements

**Enhanced Documentation:**
- **Project Conventions** section in README.md - Standard paths with override mechanism
- **Glossary** section in README.md - Definitions of all core terms, workflow concepts, and agent roles
- **Conflict Resolution** hierarchy in ALWAYS_DO.md - Clear precedence rules when instructions conflict
- **Performance & Efficiency** guidance in ALWAYS_DO.md - Token optimization and subagent usage patterns

#### Enhanced

**Agent Templates:**
- Updated all agents to use new concise template with "Key Skills" and "Escalate to [agent] when" sections
- Removed verbose "Typical skills" in favor of clearer "Key Skills"
- Added explicit escalation triggers for cross-agent handoffs

**Stub Skills (branching, release, deployment):**
- Transformed from minimal pointers to "honest pointer" approach
- Added maturity labels (STUB - Project-specific implementation required)
- Provided generic checklists and guidance for project-specific customization
- Included "Required Documentation" sections to guide implementation
- Added Common Failure Modes where applicable

**Security & Privacy:**
- Added dependency gating rules (user approval required, flag new/unpopular packages)
- Added session logging guidance (where to record external tool usage)
- Clarified that session logs live in tracking docs, not separate files

**Milestone Tracking:**
- Added **Definition of Done Checklist** to milestone-start.md template
- Three-tier DoD structure: Must (blocking), Should (recommended), Nice-to-have (optional)
- Enables milestone-wrap to query status of Should/Nice-to-have items

#### Documentation Structure

**skill template now includes:**
- Maturity label (Production-ready, Beta, Stub)
- Common Failure Modes (template for future completion)
- Version and Last Updated footer
- Consistent section ordering across all skills

**Agent template now includes:**
- Key Skills (primary workflows)
- Escalate to [agent] when (clear handoff triggers)
- Ultra-concise format (under 10 lines)

#### Philosophy & Patterns

**Convention over Configuration:**
- Standard paths defined in README.md with override mechanism
- No preprocessing or template substitution required
- Works out-of-box for 90% of projects, easy one-time adaptation for others

**Subagent Optimization:**
- Prefer VSCode Copilot's `runSubagent` tool for context-efficient handoffs
- Fallback to concise context summaries (max 500 tokens) in other environments
- Reduces token costs for multi-agent workflows

**Framework Evolution:**
- Post-mortem skill captures learnings from failures
- Framework-review skill provides periodic health assessment
- Maintainer agent owns framework quality and improvement

### Changed

- **ALWAYS_DO.md** - Expanded with conflict resolution, performance guidance, enhanced security
- **README.md** - Added Project Conventions, Glossary, updated structure, **hierarchical Development Lifecycle** showing epic vs milestone release flows
- **All agent files** - Migrated to new template (architect, implementer, tester, documenter, deployer, maintainer)
- **milestone-start.md** - Added DoD Checklist section to tracking doc template
- **All production skills** - Updated to standardized template with maturity labels, common failure modes, version history:
  - epic-refine.md, epic-start.md, epic-wrap.md
  - milestone-draft.md, milestone-wrap.md
  - red-green-refactor.md, code-review.md
  - gap-triage.md, roadmap.md, ui-debug.md, session-start.md

### Version Notes

This is the first official versioned release of the framework. Previous iterations were unversioned development work.

**Breaking Changes:** None (additive improvements only)

**Migration Path:** Existing projects can adopt improvements incrementally. No forced updates required.

---

## [Pre-1.0] - Before 2026-01-28

Initial framework development with basic structure:
- Core agents (architect, implementer, tester, documenter, deployer)
- Essential skills (epic lifecycle, milestone lifecycle, TDD workflows)
- Basic guardrails in ALWAYS_DO.md
- README with quick start guide

---

## Next Review

Scheduled for: **2026-04-28** (quarterly cadence)

Use `framework-review` skill to evaluate effectiveness after 3+ months of usage.
