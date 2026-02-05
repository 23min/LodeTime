# Skill: ui-debug

**Maturity:** Production-ready

**Purpose:** Diagnose UI issues quickly and reproducibly.

**Trigger phrases:**
- "Debug UI issue"
- "Fix UI bug"
- "Reproduce UI problem"
- "UI not working correctly"

**Use when:**
- UI behavior is incorrect, flaky, or unclear
- Visual regressions detected
- User-reported UI issues

**Do not use when:**
- Backend/API issues (not UI-specific)
- Expected behavior (not a bug)

## Inputs
- **Required:**
  - Description of incorrect behavior
  - Expected vs actual behavior
- **Optional:**
  - Screenshots or videos
  - Browser/environment details
  - Steps to reproduce

## Preconditions / preflight
- UI development environment is set up
- Ability to run application locally or in test environment

## Process
1) Reproduce with the smallest possible scenario
2) Prefer Playwright tests for deterministic reproduction
3) If updating snapshots, note why and keep diffs minimal
4) Avoid external network calls; mock or stub where needed
5) Fix issue with TDD approach (write test, fix, verify)
6) Update tracking doc with reproduction steps and fix

## Outputs
- Reproduction steps documented
- Playwright test (if applicable)
- Fix implemented
- Test coverage for bug

## Decision points
- **Decision:** Snapshot update needed?
  - **Options:** A) Update snapshot (intentional change), B) Fix code (regression)
  - **Default:** B (fix code) unless design change is confirmed
  - **Record in:** Commit message and tracking doc

## Guardrails
- Always reproduce before fixing (don't guess)
- Prefer automated tests over manual verification
- Keep snapshot diffs minimal and justified
- Mock external dependencies (no network calls in tests)

## Common Failure Modes
1. Can't reproduce → Get more specific steps, browser details, or screenshots
2. Flaky test → Remove timing dependencies, use proper waits/assertions
3. Snapshot diff too large → Break into smaller changes

## Handoff
- **Next skill:** code-review (validate fix)

## Related Skills
- **Before this:** red-green-refactor (if adding new feature)
- **After this:** code-review (validate fix)
- **Used within:** milestone-start (during implementation)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** implementer + tester

**Notes:**
- If a Playwright test exists, run or update it before manual fixes
