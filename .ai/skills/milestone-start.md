# Skill: milestone-start

**Purpose:** Start or resume work on an existing milestone with TDD discipline.

**Trigger phrases:**
- "Start milestone [ID]"
- "Begin milestone [ID]"
- "Continue working on [ID]"
- "Resume [ID]"
- "Implement milestone [ID]"

**Use when:**
- The milestone spec exists and is marked 📋 Planned or 🔄 In Progress
- You're ready to set up tracking and begin implementation

**Do not use when:**
- You only need to run the next TDD cycle (use red-green-refactor)
- The milestone spec doesn't exist yet (use milestone-draft)

---

## Inputs

- **Milestone ID** (e.g., M-03.10, SIM-M-02.05, UI-M-01.08)
- **Epic context** (which epic owns this milestone)
- **Current branch** (to determine if branching is needed)

---

## Preflight Checks

**Before starting, verify:**

1. **Epic context exists** - If unclear, run [epic-start](epic-start.md) first
2. **Milestone spec exists** - Look for the spec file (status should be 📋 Planned or 🔄 In Progress)
3. **Current branch** - Are you on main, epic branch, or milestone branch?
4. **Build is green** - No existing errors
5. **Ownership sanity check** - Spec is owned by documenter; tracking doc updates are owned by implementer/tester

If any context is missing, gather it before proceeding.

---

## Process

### Step 1: Review Milestone Spec

Open and review the milestone specification:
- Confirm status (📋 Planned or 🔄 In Progress)
- Read target and acceptance criteria
- Identify dependencies
- Review implementation phases
- Note test plan requirements

### Step 2: Create or Resume Tracking Doc

**Location:** `work/milestones/tracking/<milestone-id>-tracking.md`

**If starting fresh (no tracking doc exists):**

Ensure required directories exist (create if missing):
- `work/milestones/`
- `work/milestones/tracking/`

Create tracking document with this structure:

```markdown
# [MILESTONE-ID] Tracking

**Status:** 🔄 In Progress  
**Started:** [Date]  
**Branch:** [branch-name]  

---

## Progress Summary

[High-level status update]

---

## Implementation Log

### [Date] - Session [N]

**Focus:** [What you're working on]

**Completed:**
- ✅ [Task completed]
- ✅ [Task completed]

**In Progress:**
- 🔄 [Current task]

**Next:**
- [ ] [Upcoming task]

**Tests:**
- RED: [Test written that fails]
- GREEN: [Implementation that passes]
- REFACTOR: [Improvements made]

**Notes:**
- [Any important observations]

---

## Test Results

### Unit Tests
- ✅ [Test name] - Passing
- 🔄 [Test name] - In progress

### Integration Tests
- [ ] [Test name] - Not started

---

## Acceptance Criteria Status

- [ ] AC1: [Description]
- [ ] AC2: [Description]
- [ ] AC3: [Description]

---

## Definition of Done Checklist

### Must (blocking)
- [ ] All acceptance criteria marked complete
- [ ] Test results recorded in this tracking doc
- [ ] Build passes on target branch
- [ ] Docs updated (API changes, architecture diagrams)

### Should (strongly recommended)
- [ ] Code review completed (self or peer)
- [ ] Performance impact assessed (if relevant)
- [ ] Migration/rollback plan documented (if DB/schema changes)

### Nice-to-have (defer if time-constrained)
- [ ] Integration tests added
- [ ] User-facing documentation updated

---

## Build/Test Commands

[Project-specific build and test commands]
```

**If resuming (tracking doc exists):**
- Read the latest session entry
- Note what's completed, in progress, and next
- Continue from where you left off

### Step 3: Confirm or Create Branch

**Branch naming:**
- Single-surface: `feature/<surface>-mX/<short-desc>`
- Multi-surface: `milestone/mX`
- Epic integration: work from `epic/<epic-slug>`

**Examples:**
- `feature/api-m3/auth-endpoints`
- `feature/ui-m2/dashboard-layout`
- `milestone/m4`
- `epic/api-redesign`

**Commands:**
```bash
# Create feature branch from main
git checkout main
git pull
git checkout -b feature/api-m3/auth-endpoints

# Or from milestone branch
git checkout milestone/m3
git pull
git checkout -b feature/api-m3/auth-endpoints

# Or from epic branch
git checkout epic/api-redesign
git pull
git checkout -b feature/api-m3/auth-endpoints
```

### Step 4: Plan TDD Phases

From the milestone spec's implementation plan, identify:

**Phase 1 tasks** (typically):
- Which tests to write first (RED)
- What code passes those tests (GREEN)
- What refactoring improves the solution (REFACTOR)

**Optional:** Use @plan as subagent for complex TDD planning:
- Ask @plan to decompose phase into granular test→code→refactor cycles
- @plan operates at tactical level, bridging spec requirements to specific steps
- Particularly useful for unfamiliar codebases or complex acceptance criteria

Record this plan in the tracking doc before writing code.

### Step 5: Begin RED → GREEN → REFACTOR

Start the TDD cycle (see [red-green-refactor](red-green-refactor.md)):

1. **RED**: Write failing test
2. **GREEN**: Write minimum code to pass
3. **REFACTOR**: Improve structure
4. Update tracking doc with each cycle

Once the first cycle is underway, continue with red-green-refactor for execution.

---

## Session Guardrails

**Always:**
- ✅ Write tests FIRST (RED phase)
- ✅ Keep tracking doc updated with each commit
- ✅ Run build and tests before handoff
- ✅ Use conventional commit messages
- ✅ Keep tests deterministic (no external network calls)

**Never:**
- ❌ Write implementation before tests
- ❌ Commit without updating tracking doc
- ❌ Skip running tests
- ❌ Use time estimates
- ❌ Modify milestone spec during implementation (use tracking doc and escalate to documenter if changes are needed)

---

## Build and Test Commands

**Generic patterns** (adapt to your project):

```bash
# Build
dotnet build  # .NET
npm run build  # Node.js
make build     # Makefile

# Test all
dotnet test --nologo
npm test
make test

# Test specific project
dotnet test path/to/Project.Tests.csproj --nologo
npm test -- --testPathPattern=specific-test

# Test with coverage
dotnet test --collect:"XPlat Code Coverage"
npm test -- --coverage
```

---

## Outputs

- **Active tracking doc** with initial session entry
- **Work branch** created and checked out
- **TDD plan** documented
- **First RED test** written (if starting implementation)
- **Status** updated to 🔄 In Progress

---

## Handoff to Next Skill

**Once milestone is complete:**
- Use [milestone-wrap](milestone-wrap.md) to finalize

**If stuck or need review:**
- Use [code-review](code-review.md) for validation

**For ongoing implementation:**
- Continue with [red-green-refactor](red-green-refactor.md) cycles

---

## Example Session Start

```
User: "Start milestone M-03.10"

AI: "Reviewing milestone M-03.10...
     Status: 📋 Planned
     Target: Add graph query API endpoint
     Dependencies: ✅ M-03.08 (Core graph traversal)
     
     Current branch: main
     
     Actions:
     1. Creating tracking doc: work/milestones/tracking/M-03.10-tracking.md
     2. Creating branch: feature/api-m3/auth-endpoints
     3. Planning TDD phases from spec...
     
     Phase 1 TDD plan:
     - RED: Test_GraphQuery_ValidInput_ReturnsNodes()
     - GREEN: Implement GraphQueryHandler.Query()
     - REFACTOR: Extract validation logic
     
     Ready to begin RED phase. Writing first test..."
```

---

## Notes

- Keep milestone spec **stable** - it's the contract
- Keep tracking doc **dynamic** - it's the progress log
- If implementation reveals spec issues, note them in tracking and discuss with architect
- When wrapping milestone, tracking doc becomes the historical record
