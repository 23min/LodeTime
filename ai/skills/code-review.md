# Skill: code-review

**Maturity:** Production-ready

**Purpose:** Review changes for correctness, regressions, and missing tests.

**Trigger phrases:**
- "Review this code"
- "Code review for [milestone]"
- "Check this implementation"
- "Validate changes"

**Use when:**
- Asked for a review or before wrapping a milestone
- After completing implementation
- Before merging or creating PR

**Do not use when:**
- Work in progress (not ready for review)
- No changes to review

## Inputs
- **Required:**
  - Code changes (diff, commit, or file paths)
  - Context (milestone ID, acceptance criteria)
- **Optional:**
  - Specific concerns or areas to focus

## Preconditions / preflight
- Implementation is complete (at least one feature/fix ready)
- Tests exist and are passing

## Process

Review checklist:

**Behavior:**
- Regressions: does it break existing functionality?
- Edge cases: are boundaries and error conditions handled?
- Error handling: are errors caught and reported appropriately?

**Tests:**
- Coverage: is there test coverage for new logic?
- Deterministic: are tests repeatable (no flaky tests)?
- Edge cases: are edge cases tested?

**Contracts:**
- Schema/API compatibility: are existing contracts preserved?
- Breaking changes: are they intentional and documented?

**Docs:**
- Updated: are docs synced with behavior/contract changes?
- Comments: are complex sections explained?

**Style:**
- Patterns: does it match existing code patterns?
- Refactors: are broad refactors avoided (unless scoped)?

## Outputs
- Review findings (list of issues or ✅ approval)
- Risk items flagged
- Suggested improvements

## Decision points
- **Decision:** Approve or request changes?
  - **Options:** A) Approve (ready), B) Request changes (issues found), C) Conditional (minor tweaks)
  - **Default:** B if any blocking issues found
  - **Record in:** Tracking doc or PR comments

## Guardrails
- Focus on correctness and regressions, not style preferences
- Flag breaking changes (require explicit decision)
- Ensure test coverage for new code paths

## Common Failure Modes
1. Missing test coverage → Request tests for new logic
2. Undocumented breaking changes → Flag and require documentation
3. Overly broad refactors → Suggest narrowing scope or separate PR

## Handoff
- **Next skill:** milestone-wrap (if review passes and milestone complete)

## Related Skills
- **Before this:** red-green-refactor (implementation)
- **After this:** milestone-wrap (completion)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** tester
