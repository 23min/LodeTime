# Learning the AI-First Framework

**Date:** 2026-01-29  
**Purpose:** Document framework usage patterns for data pipeline validation epic

---

## Epic Naming & Structure

When creating a new epic, especially foundational work, naming matters:

### Epic Name: "Critical Flow Data Pipeline Foundation"
**Epic Slug:** `critical-flow-data-foundation`

**Rationale:**
- **"Data Pipeline Foundation"** - Emphasizes this is groundwork for everything else
- **Not "Exploration"** - Exploration sounds optional; this is required validation
- **Not "Discovery"** - Discovery is open-ended; you have specific deliverables
- **Foundation** - Clearly signals this is prerequisite work

### Epic Structure

This epic would contain:

**Milestones:**
1. **Query Refinement** - Iterate KUSTO queries until they return correct data
2. **Schema Validation** - Verify output structure matches requirements for charts/tables
3. **Fixture Export** - Generate reusable test fixtures for all 8 critical flows
4. **Documentation** - Document query patterns, gotchas, data characteristics

---

## Using the Framework

Here's the sequence for formalizing work:

### 1. Create Epic Spec (manual or with architect agent)

Create `/work/epics/critical-flow-data-foundation/README.md` with:

- **Status** - Planning → Active
- **Branch** - Epic integration branch name
- **Owner** - Who's responsible
- **Priority** - P0/P1/P2 (P0 blocks other work)
- **Purpose** - Why this epic exists
- **Success Criteria** - What "done" looks like
- **Deliverables** - Concrete outputs
- **Milestones** - Sequenced work units (high-level descriptions)
- **Out of Scope** - What this epic doesn't do

**Note:** At this stage, milestones are defined at a high level in the epic spec (objectives, scope). Detailed milestone specs are created later using the **milestone-draft** skill.

### 2. Run epic-start skill

Tell the agent: **"Start epic critical-flow-data-foundation"**

This will:
- Move the spec to `work/epics/active/`
- Update roadmaps (ROADMAP.md, work/epics/epic-roadmap.md)
- Confirm branch strategy
- Summarize scope

### 3. Draft Milestone Specs (using milestone-draft skill)

**When:** After epic-start, before implementing any milestone

Tell the agent: **"Draft milestone M1"** (or use milestone ID like `m-cfdf-01-query-schema`)

This will:
- Create detailed milestone spec in `work/milestones/m-cfdf-01-query-schema.md`
- Include testable acceptance criteria
- Define explicit scope boundaries
- Create TDD-ready implementation plan (RED → GREEN → REFACTOR phases)
- Add test plan
- Update epic roadmap

**Who creates milestone specs:** The **documenter** agent (via milestone-draft skill), though **architect** agent may also help draft technical milestones.

**Format:** Milestone specs follow `docs/development/milestone-documentation-guide.md`

### 4. Run milestone-start for implementation

Tell the agent: **"Start milestone M1"** 

This will:
- Create milestone tracking doc in `work/milestones/tracking/`
- Create feature branch from epic branch
- Set up progress tracking structure
- Begin RED-GREEN-REFACTOR cycle

### 4. Work in TDD cycles

For each feature/task:
1. **RED:** Write failing test
2. **GREEN:** Implement minimum code to pass
3. **REFACTOR:** Clean up and optimize

Document progress in milestone tracking doc.

### 5. Complete milestones

Use **milestone-wrap** skill after each milestone completes.

### 6. Complete epic

Use **epic-wrap** skill when all milestones done.

---

## Current State Assessment

We're actually **partially through M1** already:
- ✅ Notebook environment set up
- ✅ Queries executing against Application Insights
- ✅ Parameter substitution working
- 🔄 Still need to validate output and iterate queries
- ⏳ Export fixtures pending
- ⏳ Documentation pending

---

## Formalization Options

### Option A: Formalize what you've done (RECOMMENDED)

1. Create the epic spec (architect agent can help)
2. Run `epic-start` to make it official
3. Create M1 tracking doc with what's done vs. pending
4. Continue with formal milestone tracking

**Benefits:**
- Clear tracking of what's validated
- Proper handoff to implementation epic
- Reusable framework for similar validation work

### Option B: Continue ad-hoc, wrap later

1. Finish query validation in current session
2. Export fixtures
3. Document in PROVENANCE.md as ad-hoc work
4. Later formalize as epic when starting implementation work

**When to use:**
- Very small exploratory work
- Uncertain if work will continue
- Prototyping only

---

## Decision Points

### Branch Strategy

**Options:**
- A) Epic integration branch (recommended for multi-milestone epics)
- B) Work directly from main (for single milestone or small changes)

**For this epic:** Use option A - create `arch/critical-flow-data-foundation` branch

### Milestone Granularity

**Too coarse:** "Validate data pipeline" (single milestone)
- Loses tracking visibility
- Hard to measure progress
- Can't parallelize work

**Too fine:** "Fix BA query", "Fix BC query", etc. (one per query)
- Too much overhead
- Loses big picture
- Creates many small PRs

**Just right:** "Query Refinement", "Schema Validation", "Fixture Export"
- Logical checkpoints
- Measurable outcomes
- Reasonable PR sizes

---

## Framework Skills Reference

### epic-start
- **Trigger:** "Start epic [name]"
- **Purpose:** Initialize or confirm epic context before milestone work
- **Outputs:** Epic moved to active/, roadmaps updated, branch confirmed

### milestone-draft
- **Trigger:** "Draft milestone [ID]"
- **Purpose:** Create detailed milestone specification with acceptance criteria and test plan
- **Outputs:** Milestone spec in `work/milestones/`, roadmaps updated
- **Agent:** documenter (or architect for technical milestones)

### milestone-start
- **Trigger:** "Start milestone [ID]"
- **Purpose:** Begin implementation work on milestone
- **Outputs:** Tracking doc created, feature branch created, TDD cycle begins

### milestone-wrap
- **Trigger:** "Wrap milestone M1"
- **Purpose:** Complete milestone, prepare for PR
- **Outputs:** Tests validated, docs updated, ready for review

### epic-wrap
- **Trigger:** "Wrap epic [name]"
- **Purpose:** Complete epic, merge to main
- **Outputs:** Epic moved to completed/, roadmaps updated, cleanup done

### red-green-refactor
- **Trigger:** "Red-green-refactor for [feature]"
- **Purpose:** TDD cycle for feature implementation
- **Outputs:** Tests written, code implemented, refactored

---

## Agent Roles

### Architect Agent
- Creates epic specs
- Designs system architecture
- Makes technology decisions
- Documents ADRs

### Implementer Agent
- Writes code
- Implements features
- Follows TDD
- Refactors

### Tester Agent
- Reviews test coverage
- Validates functionality
- Creates test scenarios
- Reports gaps

### Documenter Agent
- Updates documentation
- Creates user guides
- Maintains consistency
- Reviews clarity

---

## When to Use PROVENANCE.md vs. Epic Tracking

### Use PROVENANCE.md for:
- Quick bug fixes from manual prompts
- Exploratory changes and experiments
- Documentation improvements
- Unplanned refactoring
- Any work NOT part of a formal epic/milestone

### Use Epic Tracking for:
- Multi-step projects
- Architectural changes
- Feature development
- Work that needs review
- Work that should be documented formally

---

## Key Learnings

1. **Start with architecture docs, move to active** - `work/epics/` is for planning, `work/epics/active/` is for execution
2. **Epic integration branches protect main** - Prevents half-implemented features on main
3. **Milestones are logical checkpoints** - Not arbitrary time windows
4. **TDD from the start** - Don't skip RED phase
5. **Documentation is part of done** - Not optional cleanup
6. **Framework enables AI handoffs** - Clear context for agent transitions

---

## Example: This Data Foundation Epic

### Before Framework (Ad-hoc)
```
User: "Let's query Application Insights"
Agent: [Creates notebook]
User: "Fix this error"
Agent: [Edits notebook]
User: "Try this query"
Agent: [Updates query]
...
Result: Working code, but no clear handoff point
```

### With Framework (Structured)
```
User: "Start epic critical-flow-data-foundation"
Agent: [Creates epic spec, branches, tracking]
User: "Start milestone M1 Query Refinement"
Agent: [Creates M1 tracking, defines tests]
Agent: RED - Define expected query outputs
Agent: GREEN - Iterate queries until passing
Agent: REFACTOR - Clean up, document patterns
User: "Wrap milestone M1"
Agent: [Validates, documents, ready for PR]
...
Result: Clear progress, documented decisions, ready for implementation epic
```

---

## Next Steps for This Epic

1. ✅ Create epic spec in `work/epics/critical-flow-data-foundation/` (you're here)
2. ⏳ Run `epic-start` to activate
3. ⏳ Run `milestone-start` for M1
4. ⏳ Complete M1 work (query refinement)
5. ⏳ Export fixtures (M2)
6. ⏳ Document findings (M3)
7. ⏳ Run `epic-wrap` to complete

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-29  
**Author:** xpetbru + GitHub Copilot
