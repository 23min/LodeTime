# Skill: epic-wrap

**Maturity:** Production-ready

**Purpose:** Close out an epic, sync docs, and coordinate merge to main.

**Trigger phrases:**
- "Wrap up epic [name]"
- "Complete epic [name]"
- "Finish epic [name]"
- "Close epic [name]"

**Use when:**
- All milestones in the epic are complete
- Ready to merge epic work to main
- Time to create epic-level release

**Do not use when:**
- Milestones still in progress
- Individual milestone completion (use milestone-wrap instead)

## Inputs
- **Required:**
  - Epic slug
  - List of completed milestone IDs
- **Optional:**
  - Merge strategy preference (PR vs direct merge)

## Preconditions / preflight
- All milestones in epic have status ✅ Complete
- All milestone tests passing
- Epic integration branch exists (if used)
- Milestone release notes and tracking docs are finalized

## Process:
1) Verify each milestone status is ✅ Complete.

2) Move milestone specs from `dev/milestones/` to `dev/milestones/completed/` as a batch (e.g., `M-01.01.md`, `M-01.02.md`, etc.).

3) Create epic release document at `dev/epics/releases/<epic-slug>.md`:
   - Summarize milestone release notes (from milestone specs + tracking docs only)
   - Summarize epic achievements and impact
   - List all completed milestones
   - Document breaking changes (if any)
   - Template:
     ```markdown
     # Epic Release: [Epic Name]
     
     **Epic Slug:** <epic-slug>
     **Released:** YYYY-MM-DD
     **Git Tag:** epic/<epic-slug>
     
     ## Overview
     [High-level summary of what this epic delivered]
     
     ## Milestones Completed
     - M-XX.01: [Title] - [Brief description]
     - M-XX.02: [Title] - [Brief description]
     
     ## Key Features Delivered
     [Aggregated from milestone release notes]
     
     ## Breaking Changes
     [If any, aggregated from milestones]
     
     ## Impact
     [Business value and user impact]
     ```

4) Update root `CHANGELOG.md` (create if it doesn't exist) **before merge**:
   - Add high-level entry for this epic
   - Link to detailed epic release document
   - Keep it concise (1-3 lines per epic)
   - Format:
     ```markdown
     ## [Date] - Epic: [Epic Name]
     
     [One-sentence summary]. See [detailed release notes](dev/epics/releases/<epic-slug>.md).
     ```

5) Move epic spec from `dev/epics/active/<epic-slug>.md` to `dev/epics/completed/<epic-slug>.md`

6) Update:
   - EPIC_ROADMAP_PATH (high-level: mark epic complete; see `ai/instructions/PROJECT_PATHS.md`)
   - EPIC_TECH_ROADMAP_PATH (technical: mark complete, update status)

7) Ask whether the epic should merge via PR or directly to main.

8) Ensure release ceremony steps are ready or completed.

Outputs:
- Epic release document created in `dev/epics/releases/<epic-slug>.md`
- Root `CHANGELOG.md` updated with epic entry
- Epic docs and roadmap updated
- Milestones archived together in `dev/milestones/completed/`
- Merge strategy decided and documented
- Epic marked complete in roadmaps
- Ready for git tag: `epic/<epic-slug>`

## Decision points
- **Decision:** Merge strategy
  - **Options:** A) PR for review, B) Direct merge to main
  - **Default:** A (PR) for significant changes
  - **Record in:** Epic session log or PR description
  - **Authority:** Architect decides based on epic complexity and risk

## Guardrails
- Verify ALL milestones complete before archiving
- Update all affected epic roadmaps (EPIC_ROADMAP_PATH, EPIC_TECH_ROADMAP_PATH)
- Ensure release ceremony steps are planned or completed
- Don't skip documentation sync (prevents drift)
- Epic release doc must only summarize milestone release notes/tracking
- CHANGELOG.md updates happen here (not in milestone-wrap or release)

## Common Failure Modes
1. Incomplete milestones → Review each milestone status before proceeding
2. Forgotten documentation updates → Use checklist in step 3 of process
3. No release plan → Coordinate with architect before merging

## Handoff
- **Next skill:** release (documenter) for epic-level release ceremony

## Related Skills
- **Before this:** milestone-wrap (for each milestone)
- **After this:** release (epic-level release)
- **Involves:** documenter (archive, docs), architect (merge decision)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** documenter (with architect coordination)
