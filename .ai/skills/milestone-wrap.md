# Skill: milestone-wrap

**Purpose:** Complete a milestone, capture a milestone release summary, and prepare for PR or merge.

**Trigger phrases:**
- "Complete milestone [ID]"
- "Wrap up [ID]"
- "Finish milestone [ID]"
- "Close [ID]"
- "Mark [ID] as complete"

**Use when:**
- All acceptance criteria are met
- All tests are passing
- Code review is complete
- Ready to hand off for merge

---

## Prerequisites

**Before wrapping, verify:**

- [ ] All acceptance criteria checked off
- [ ] All tests passing (unit, integration, E2E)
- [ ] Build is green
- [ ] Tracking doc is up to date
- [ ] No WIP or commented-out code
- [ ] Conventional commit messages used

---

## Process

### Step 1: Final Test Run

Run complete test suite and record results:

```bash
# Full test suite
[your test command] --nologo

# Or per-project if full suite times out
[test each project individually]
```

Record in tracking doc:
```markdown
## Final Test Results

**Date:** [Date]
**Branch:** [branch-name]
**Commit:** [short SHA]

### Test Summary
- Unit Tests: X passed, 0 failed
- Integration Tests: Y passed, 0 failed
- Total: Z passed, 0 failed

### Build
- ✅ Build successful
- ✅ No warnings
```

### Step 2: Update Milestone Status

In the milestone spec file (`work/milestones/<milestone-id>.md`), update the header:

If any required directories are missing, create them first:
- `work/milestones/`
- `work/milestones/tracking/`

```markdown
# [ID] — [Title]

**Status:** ✅ Complete  
**Completed:** [Date]  
**Dependencies:** [List]  
**Target:** [Goal]
```

### Step 3: Finalize Tracking Doc

Add completion summary to tracking doc:

```markdown
## Completion Summary

**Completed:** [Date]  
**Final Commit:** [SHA]  
**Branch:** [branch-name]  

### What Shipped
- [Deliverable 1]
- [Deliverable 2]
- [Deliverable 3]

### Acceptance Criteria
- ✅ AC1: [Description]
- ✅ AC2: [Description]
- ✅ AC3: [Description]

### Test Coverage
- [Summary of tests added]

### Files Modified
- [List key files changed]

### Notes
- [Any important observations or decisions]
- [Known limitations or future work]
```

### Step 4: Documentation Sync

Update project documentation to reflect what shipped:

**Required updates:**

1. **High-level Roadmap** (`ROADMAP.md` in root)
   - Update milestone status from 🔄 In Progress to ✅ Complete
   - Update epic status if this was the last milestone

2. **Technical Epic Roadmap** (`work/epics/epic-roadmap.md`)
   - Mark milestone complete
   - Update epic progress percentage or status
   - Update dependencies and ordering if needed

3. **Milestone Release Notes** (required)
   - Add a "Release Notes" section to the milestone spec document itself (`work/milestones/<milestone-id>.md`)
   - Include: what shipped, why it matters, any breaking changes, version info
   - Format:
     ```markdown
     ## Release Notes
     
     **Released:** YYYY-MM-DD
     **Version:** [if applicable]
     
     ### What Shipped
     - [Feature 1]
     - [Feature 2]
     
     ### Why It Matters
     [Business value or user impact]
     
     ### Breaking Changes
     - [Change 1] (if any)
     
     ### Known Limitations
     - [Limitation 1] (if any)
     ```

4. **Reference Docs** (if new APIs or features)
   - Update API references
   - Update capability matrices
   - Update examples and tutorials

6. **Architecture Docs** (if design changed)
   - Update architecture diagrams
   - Update design decisions
   - Update component descriptions

**Documentation Sync Checklist:**
```markdown
## Documentation Updates

- [ ] Milestone spec marked ✅ Complete
- [ ] Milestone spec has Release Notes section added
- [ ] Tracking doc finalized
- [ ] ROADMAP.md updated (high-level)
- [ ] work/epics/epic-roadmap.md updated (technical)
- [ ] Reference docs updated (if applicable)
- [ ] Architecture docs updated (if applicable)
- [ ] Examples updated (if applicable)
```

### Step 5: Commit Documentation Updates

```bash
git add docs/
git commit -m "docs(milestone): mark M-XX.XX complete and sync docs

- Milestone spec status updated to Complete
- Release notes added to milestone spec
- Tracking doc finalized with test results
- Roadmap and epic roadmap updated"
```

### Step 6: Decide PR vs Direct Merge

Ask whether this milestone should be merged via PR or directly (per current process).

If PRs are used:
- Create a PR and route for review.
- Merge only after approval.

If direct merge is used:
- Merge only when explicitly instructed.

**Next steps handled separately:**
- Merge to milestone or epic branch
- Eventually merge to main
- Release ceremony (see [release](release.md))
---

## Outputs

- **Milestone spec** marked ✅ Complete with completion date and release notes section
- **Tracking doc** finalized with summary and test results
- **Documentation** synchronized across roadmaps, charters, and references
- **Branch** ready for review and merge
- **Clear handoff** to next milestone or release

---

## Example Completion

```markdown
# M-03.10 — Graph Query API

**Status:** ✅ Complete  
**Completed:** 2026-01-28  
**Dependencies:** ✅ M-03.08  
**Target:** Add graph traversal query endpoint

---

[Rest of spec unchanged]
```

```markdown
# M-03.10 Tracking

## Completion Summary

**Completed:** 2026-01-28  
**Final Commit:** a3f9d8c  
**Branch:** feature/api-m3/graph-queries  

### What Shipped
- POST /v1/graph/query endpoint
- GraphQueryHandler with depth-first traversal
- Validation for query parameters
- 15 unit tests, 4 integration tests

### Acceptance Criteria
- ✅ AC1: Endpoint accepts JSON query and returns nodes
- ✅ AC2: Handles invalid input with 400 response
- ✅ AC3: Respects max depth limits

### Test Coverage
- QueryHandler: 18 tests
- QueryController: 4 integration tests
- All edge cases covered

### Files Modified
- src/MyApp/Controllers/QueryController.cs
- src/MyApp.Core/QueryHandler.cs
- tests/MyApp.Tests/QueryControllerTests.cs
- tests/MyApp.Core.Tests/QueryHandlerTests.cs

### Notes
- Performance is good for large datasets
- Future work: add pagination support
- Future work: add caching for repeated queries
```

---

## Handoff

**To release:**
- Once merged to main, use [release](release.md) for version bump and tagging

**To next milestone:**
- Use [milestone-start](milestone-start.md) for the next milestone in the epic

**To epic wrap:**
- If this was the last milestone in the epic, use [epic-wrap](epic-wrap.md)

---

## Notes

- Milestone specs remain in `work/milestones/` (root) until the entire epic completes
- Tracking docs stay in `work/milestones/tracking/`
- Only archive specs to `work/milestones/completed/` when epic wraps (via epic-wrap skill)
- Tracking docs stay with specs until archiving
- Keep documentation sync as part of completion, not as a separate step
- "Complete" means ready for merge, not necessarily merged

---

## Decision points
- **Decision:** Merge strategy
  - **Options:** A) PR for review, B) Direct merge, C) Defer to epic-wrap
  - **Default:** C (defer to epic-wrap) if part of multi-milestone epic
  - **Record in:** Tracking doc completion summary

## Guardrails
- All acceptance criteria must be checked before marking complete
- Tests must pass (no "will fix later")
- Documentation must be synced (not deferred)
- No WIP or commented-out code in final commit

## Common Failure Modes
1. Incomplete ACs → Review each AC, don't skip any
2. Tests not recorded → Add final test results to tracking doc
3. Docs out of sync → Update architecture diagrams, API docs before completing
4. Forgotten DoD items → Review DoD checklist from milestone-start template

## Handoff
- **Next skill:** 
  - If last milestone in epic → epic-wrap
  - If standalone or interim → release (optional)
  - If continuing epic → milestone-start (next milestone)

## Related Skills
- **Before this:** milestone-start, red-green-refactor, code-review
- **After this:** epic-wrap (if last milestone) or milestone-start (if continuing)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** documenter

**Maturity:** Production-ready
