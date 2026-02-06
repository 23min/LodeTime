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

## Process:
1) Verify each milestone status is ✅ Complete.

2) Ensure required directories exist (create if missing):
   - `work/milestones/completed/`
   - `work/epics/releases/`
   - `work/epics/completed/`

3) Move milestone specs from `work/milestones/` to `work/milestones/completed/` as a batch (e.g., `M-01.01.md`, `M-01.02.md`, etc.).

4) Create epic release document at `work/epics/releases/<epic-slug>.md`:
   - Aggregate all milestone release notes
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

5) Update root `CHANGELOG.md` (create if it doesn't exist):
   - Add high-level entry for this epic
   - Link to detailed epic release document
   - Keep it concise (1-3 lines per epic)
   - Format:
     ```markdown
     ## [Date] - Epic: [Epic Name]
     
     [One-sentence summary]. See [detailed release notes](work/epics/releases/<epic-slug>.md).
     ```

6) Move epic spec from `work/epics/active/<epic-slug>.md` to `work/epics/completed/<epic-slug>.md`

7) Update:
   - `ROADMAP.md` (high-level: mark epic complete)
   - `work/epics/epic-roadmap.md` (technical: mark complete, update status)

8) Ask whether the epic should merge via PR or directly to main.

9) Ensure release ceremony steps are ready or completed.

Outputs:
- Epic release document created in `work/epics/releases/<epic-slug>.md`
- Root `CHANGELOG.md` updated with epic entry
- Epic docs and roadmap updated
- Milestones archived together in `work/milestones/completed/`
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
- Update all affected roadmaps (epic-roadmap.md, ROADMAP.md, charters)
- Ensure release ceremony steps are planned or completed
- Don't skip documentation sync (prevents drift)

## Common Failure Modes
1. Incomplete milestones → Review each milestone status before proceeding
2. Forgotten documentation updates → Use checklist in step 3 of process
3. No release plan → Coordinate with deployer before merging

## Handoff
- **Next skill:** release (deployer) for epic-level release ceremony

## Related Skills
- **Before this:** milestone-wrap (for each milestone)
- **After this:** release (epic-level release)
- **Involves:** documenter (archive, docs), architect (merge decision), deployer (release)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** documenter (with architect and deployer coordination)
