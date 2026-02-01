# ALWAYS_DO

Purpose: global guardrails that apply to every session, regardless of role.

## ⚠️ CRITICAL: Never Commit Without Approval

**NEVER run `git commit` without explicit human approval.**

Always:
1. Stage changes with `git add`
2. Show what will be committed
3. Wait for human approval
4. Only then commit when explicitly instructed

Violating this rule breaks the AI-First workflow and removes human oversight.

---

## Core guardrails
- Follow the project’s AI/dev instructions (for example: `.github/copilot-instructions.md`) and relevant development docs (for example under `dev/development/`).
- No time or effort estimates in docs or plans.
- Search efficiently (prefer fast tools like `rg`/`fd` when available).
- Avoid history-rewriting / destructive git operations unless explicitly instructed (e.g., `reset --hard`, force-push, mass rebase).
- Keep dev/schemas/templates aligned when touching contracts.
- Tests must be deterministic; avoid external network calls.
- Use Mermaid for diagrams; avoid ASCII art boxes.
- Prefer minimal, precise edits; avoid broad refactors without context.

## Security & privacy
- Do not paste secrets/tokens into prompts, docs, issues, or logs.
- Avoid including customer/PII data in examples; use sanitized fixtures.
- **Dependency gating:** All new dependencies must be approved by user before installation; flag packages < 1 year old or with < 100 stars for review.
- **Decision logging:**
  - Significant architectural decisions: Create ADR in `dev/architecture/<epic-slug>/adrs/XXX-decision-title.md`
  - Epic progress/scope changes: Add brief note to epic spec's Progress Notes section
  - Milestone work: Use tracking doc's Implementation Log section
  - Gaps discovered: Add to `dev/gaps.md` and reference from epic/milestone
  - Ad-hoc work: Use PROVENANCE.md

## Conflict Resolution

When instructions conflict, precedence is:
1. Explicit user directive in current session
2. Project-specific docs (.github/copilot-instructions.md)
3. ALWAYS_DO.md (this file)
4. Skill-specific guidance
5. Agent role defaults

When in doubt: ask the user.

## Performance & Efficiency

- Read only what you need (use grep/search before full file reads)
- Summarize long documents; don't paste full contents into responses
- Use incremental workflows (don't rewrite entire files)
- Keep tracking docs concise (link to details rather than embedding)
- Archive completed milestone docs to reduce context pollution
- **Prefer subagents for handoffs (when available):**
  - VSCode Copilot: Use `runSubagent` tool to spawn fresh context
  - Other environments: Provide concise context summary (max 500 tokens)
  - Avoid full state transfer; focus handoff on next-action requirements
- **Multi-agent handoffs:** For complex workflows (architect → implementer → tester → documenter), use subagents with focused context summaries rather than full state transfer

## Session hygiene
- Confirm epic context before milestone execution; if missing, run `epic-refine`/`epic-start`.
- Use TDD: RED -> GREEN -> REFACTOR; list tests first in tracking docs.
- Keep milestone specs stable; use tracking docs for progress updates.

## Ownership & handoffs (required)
- **Single source of truth:**
  - Architect: `dev/architecture/**`, epic scope/decisions, merge strategy
  - Planner: Milestone Plan section in `dev/architecture/<epic-slug>/README.md`
  - Documenter: `dev/epics/**`, `dev/milestones/**` (specs), `CHANGELOG.md`
  - Implementer: code + tests + **tracking progress only** in tracking docs
  - Tester: test plan/coverage in tracking docs + review sign-off
  - Maintainer: `ai/**` only (framework), not project content
- **Required handoff artifacts:**
  - Architect → Planner: epic summary + constraints + non-goals
  - Planner → Documenter: Milestone Plan section (IDs, scope, dependencies, order)
  - Documenter → Implementer: finalized milestone spec + tracking doc
  - Implementer → Tester: test results + status updates in tracking doc
  - Documenter → Architect: release notes/roadmap updates for epic wrap
- **Release sources of truth:**
  - Milestone spec + tracking doc are authoritative for what shipped
  - Epic-wrap summarizes milestone release notes; `CHANGELOG.md` is updated only in epic-wrap
  - Release skill tags/publishes only; no doc edits

## Gap handling
- Gaps are out-of-scope by default; record them in dev/ROADMAP.md
- Review gaps with architect or planner before deciding placement
- Rarely, include in the current milestone (requires architect + documenter approval)
- Otherwise plan into an epic/milestone (preferred) or treat as one-off work on a separate branch
- One-off work requires explicit user approval and must be logged in PROVENANCE.md

## Build/test
- Build and test before handoff when asked to implement changes.
- If full test suite is too slow, run per-project tests and record results.

---

## When to Update PROVENANCE.md

Update `PROVENANCE.md` for **ad-hoc work only**, such as:
- Quick bug fixes from manual prompts
- Exploratory changes and experiments
- Documentation improvements
- Unplanned refactoring
- Any work NOT part of a formal agent task/milestone

**Do NOT update PROVENANCE.md** for formal agent tasks that have their own tracker files in `agent-tasks/` or epic tracking documents.

### After Completing Ad-hoc Work Sessions

When you've made significant ad-hoc changes or completed a work session, update `PROVENANCE.md`:

1. **Add entry at the TOP** (newest first)
2. **Include:**
   - Date (YYYY-MM-DD) and optionally time
   - Brief description of what changed
   - Author name + AI tool used (e.g., "xpetbru + GitHub Copilot")
   - Git commit hash if available (optional)
   - List of key files modified

3. **Format:**
   ```markdown
   ### YYYY-MM-DD [HH:MM] - Brief Description
   **By:** Author + AI Tool | **Commit:** `hash` (if available)

   Description of changes made.

   **Files:** file1.ts, file2.md
   ```

---

## Commit Message Format

Use Conventional Commits format:

**Structure:**
```
<type>(<scope>): <brief summary in imperative mood>

<optional body with bullet points>

<optional footer>
```

**Types:**
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `chore:` Maintenance, config, dependencies
- `refactor:` Code restructuring without behavior change
- `test:` Adding or updating tests

**Guidelines:**
- Keep subject line under 72 characters
- Use imperative mood: "add" not "added" or "adds"
- Body explains what and why, not how
- Reference issues/PRs if relevant
- Add `Co-authored-by: GitHub Copilot` for AI-assisted work

**Examples:**
```
docs(ai): update agent handoff rules

feat(reporting): implement data extraction from PerfOps

chore(deps): update dependencies to latest versions
```

---

## Language Guidelines

**Repository language:** English

The entire repository is maintained in English to optimize AI performance. This includes:
- Code and comments
- Technical documentation
- README files
- AI instructions
- Commit messages
- PROVENANCE.md

---

## 🔄 Long Session Protocol

**For conversations >20 exchanges or when context seems stale:**

1. **Proactively suggest context refresh** when:
   - User asks about something covered earlier
   - You notice potential context drift
   - Before starting new major work (epic/milestone)
   - Session has been going for extended period

2. **Refresh by using context-refresh skill:**
   - Re-read `ai/instructions/ALWAYS_DO.md`
   - Re-read active agent definition
   - Check active epic/milestone docs
   - Confirm current state with user

3. **User can trigger refresh anytime** by saying:
   - "Refresh context"
   - "Reload instructions"
   - "What's my current state?"

See `ai/skills/context-refresh.md` for full procedure.

---

## General Guidelines

- Prefer creating working code over theoretical discussions
- Document decisions and rationale
- Update relevant documentation when making changes
- Follow the AI-First methodology: use AI by default, manual intervention is the exception
- **Never commit without human approval** - always stage changes and wait
