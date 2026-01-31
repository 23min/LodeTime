# Skill: red-green-refactor

**Maturity:** Production-ready

**Purpose:** Enforce TDD cadence and test-first workflow.

**Trigger phrases:**
- "Write tests for [feature]"
- "TDD for [task]"
- "Implement [feature] with tests"
- "Test-first [implementation]"

**Use when:**
- Implementing milestone tasks
- Adding new functionality
- Fixing bugs with test coverage

**Do not use when:**
- Tests already exist and passing (refactor only)
- Documentation-only changes

## Inputs
- **Required:**
  - Feature or task description
  - Milestone context
- **Optional:**
  - Existing test structure
  - Performance requirements

## Preconditions / preflight
- Milestone spec exists with clear acceptance criteria
- Test framework is set up and working

## Process
1) **RED**: Write failing tests first (record in tracking doc)
2) **GREEN**: Implement minimum change to pass tests
3) **REFACTOR**: Improve structure with tests still passing
4) Repeat per task; keep tests deterministic

## Outputs
- Failing test (RED phase)
- Passing implementation (GREEN phase)
- Refactored code (REFACTOR phase)
- Updated tracking doc with TDD cycle notes

## Decision points
- **Decision:** Test scope
  - **Options:** A) Unit tests only, B) Unit + integration, C) Full stack
  - **Default:** A (unit tests) for each cycle, add integration as separate cycle
  - **Record in:** Tracking doc test results

## Guardrails
- Always write tests BEFORE implementation (RED first)
- Tests must be deterministic (no external network calls)
- Keep refactoring small and incremental
- Run tests after each refactor (ensure still GREEN)

## Common Failure Modes
1. Writing implementation before tests → Stop, write failing test first
2. Non-deterministic tests → Remove external dependencies, use mocks/fixtures
3. Too much refactoring at once → Break into smaller steps, test between each

## Handoff
- **Next skill:** code-review (after completing implementation)

## Related Skills
- **Before this:** milestone-start (provides context)
- **After this:** code-review (validate changes)
- **Used within:** milestone-start process

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** implementer + tester
