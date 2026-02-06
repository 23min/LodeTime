# AI Framework Gaps

Discovered gaps, inconsistencies, and improvement opportunities in the AI-First development framework.

**Scope:** Framework issues, skill gaps, process improvements  
**Not included:** Solution/code bugs (use `work/GAPS.md` for those)

---

## Format

Each framework gap entry should include:
- **Title**: Descriptive heading (no sequential ID to avoid merge conflicts)
- **Discovered**: When and where the gap was found
- **Category**: Skill, Process, Documentation, Tooling, Agent Roles
- **Impact**: Why it matters
- **Status**: Identified, In Progress, Resolved, Won't Fix
- **Recommendation**: Proposed solution

**Note:** We use descriptive titles instead of sequential IDs (FW-GAP-XXX) to prevent merge conflicts when multiple branches add gaps simultaneously. Reference gaps by title in discussions and documentation.

---

## Gap Prioritization

This section provides strategic prioritization of active framework gaps to guide improvement efforts.

### 🎯 High Priority - Address Soon

**1. Lack of Prescriptive Spec Templates**
- **Impact:** High - Core to AI-driven development quality
- **Why:** Better specs directly improve AI code generation quality. Currently causing inconsistent milestone specifications and missing critical details.
- **Dependencies:** None - can start immediately
- **Effort:** Medium (8-12 hours)
- **ROI:** Immediate improvement in every milestone created
- **Action:** Create templates in `work/specs/templates/` with WHAT/WHY/HOW sections, checklists, and validation

**2. Context Loading Strategy and Session State**
- **Impact:** High - Context loss in long sessions is critical for AI-First
- **Why:** Epic planning and complex work spans multiple sessions. Without context preservation, decisions and reasoning get lost.
- **Dependencies:** Need to test session ID generation (GUID vs GitHub API)
- **Effort:** Medium-High (10-15 hours including testing)
- **ROI:** Prevents context loss, enables reliable session resumption
- **Blocker:** Must validate session ID approach before implementing
- **Action:** Test session ID options, implement `.ai/sessions/` with context-refresh integration

**3. Missing Phase Gates (Phase 1: Milestone-Start)**
- **Impact:** Medium-High - Quality issues slip through without systematic checks
- **Why:** Prevents bad implementations by enforcing spec completeness before coding starts
- **Dependencies:** Works better with spec templates and uncertainty markers, but not required
- **Effort:** Low-Medium (3-4 hours for Phase 1 only)
- **ROI:** Reduces rework, enforces TDD discipline, creates teachable moments
- **Action:** Add milestone-start gate checklist first, expand to other gates later

### 📋 Medium Priority - Useful Improvements

**4. No Formalized Development Principles**
- **Impact:** Medium - Inconsistent approaches, harder to onboard
- **Why:** Principles are scattered across skills. Codifying makes them explicit and referenceable.
- **Effort:** Low (4-6 hours)
- **ROI:** Better onboarding, clearer framework philosophy, supports phase gates
- **Action:** Create `.ai/instructions/DEVELOPMENT_PRINCIPLES.md` with 7-10 core principles

**5. No Uncertainty Markers Convention**
- **Impact:** Medium - Ambiguity in specs, unclear what needs clarification
- **Why:** Makes uncertainty explicit and searchable. Prevents proceeding with unclear specs.
- **Effort:** Low (2-3 hours)
- **ROI:** Clearer specs, better phase gate enforcement, less ambiguity
- **Dependencies:** Pairs well with spec templates
- **Action:** Document `[NEEDS CLARIFICATION]` markers, add to spec templates

**6. Context-Refresh Skill Not Linked to Epic-Level Workflows**
- **Impact:** Medium - Context loss during epic planning
- **Why:** Epic work is long and context-heavy. Need explicit refresh points.
- **Effort:** Low (2-3 hours)
- **ROI:** Better context management during epic planning
- **Action:** Update epic-refine, epic-start documentation; update flowchart

**7. Infrequent Progress Recording**
- **Impact:** Medium - Risk of losing work details between checkpoints
- **Why:** Tracking docs updated only at milestone boundaries. Need continuous recording.
- **Effort:** Medium (4-6 hours)
- **ROI:** Better audit trail, easier resumption, complements session state
- **Dependencies:** Complements session state solution
- **Action:** Add checkpoint steps to red-green-refactor and other skills

### 📝 Low Priority - Documentation Polish

**8. Built-in @plan Subagent Not Documented**
- **Impact:** Low - Users unaware of helpful feature
- **Why:** Quick documentation win, but not blocking work
- **Effort:** Very Low (1 hour)
- **Action:** Add explanation to `.ai/docs/README.md` or create guide

**9. Milestone Spec Links in Epic README**
- **Impact:** Low - Minor consistency issue
- **Why:** Inconsistent linking behavior across epics
- **Effort:** Very Low (1-2 hours)
- **Recommendation:** Don't link (Option A) - epic README stays strategic, epic-roadmap provides navigation
- **Action:** Update milestone-draft skill documentation to clarify

**10. Deployer Agent Conflates Release and Infrastructure Roles**
- **Impact:** Low - Naming clarity, not a functional problem
- **Why:** Agent mostly does release coordination, rarely does deployment. Name suggests infrastructure focus.
- **Effort:** Medium (if renaming: 4-6 hours), Low (if clarifying description: 30 min)
- **Recommendation:** Clarify agent description, don't rename (low value, high churn cost)
- **Action:** Update deployer.md description to clarify release coordinator primary role

**11. Informal Governance vs Constitutional Principles**
- **Impact:** Low-Medium - Structure improvement, not a functionality gap
- **Why:** ALWAYS_DO.md could be more formal/immutable like Spec Kit's constitution
- **Effort:** Medium (6-8 hours)
- **ROI:** Better enforcement, clearer boundaries
- **Action:** Restructure ALWAYS_DO.md with "articles" and formal status

### 🚀 Recommended Implementation Sequence

1. **Spec Templates** (weeks 1-2) - Foundation for quality specs
2. **Session State** (weeks 2-3) - Test session ID, implement if viable
3. **Milestone-Start Gate** (week 3) - First phase gate, builds on spec templates
4. **Uncertainty Markers** (week 4) - Complements templates and gates
5. **Development Principles** (week 4-5) - Codifies framework philosophy
6. **Remaining Medium Priority** (ongoing) - As time permits
7. **Low Priority** (backlog) - Polish when framework stabilizes

### Decision Factors

**Choose High Priority when:**
- Directly improves AI code generation quality
- Prevents context loss or information loss
- Enforces core principles (TDD, spec-first)
- High frequency of use

**Defer Low Priority when:**
- Theoretical rather than observed problems
- High effort for low benefit
- Naming/structure preferences vs functional needs
- Can work around easily

---

## Active Framework Gaps

### Built-in @plan Subagent Not Documented
**Discovered:** 2026-02-03 during framework reconciliation with external project  
**Category:** Documentation  
**Impact:** Low - Users unaware of helpful feature  
**Status:** Identified  

**Issue:**
GitHub Copilot provides a built-in `@plan` subagent (similar to `@workspace`) that can be delegated to for tactical implementation planning. The implementer and documenter agents reference this feature, but it's not documented in the framework.

**Current State:**
- implementer.md mentions: "May delegate to @plan for tactical implementation planning"
- milestone-draft.md suggests: "Use @plan as subagent to decompose complex implementation phases"
- No explanation of what @plan is or when to use it
- Users may not know this feature exists

**Recommendation:**
1. Add brief explanation in framework documentation (.ai/docs/README.md or new guide)
2. Document common @plan use cases:
   - Breaking milestone specs into granular TDD steps
   - Decomposing complex implementation phases
   - Tactical planning within a milestone
3. Clarify that @plan is a built-in Copilot feature, not a framework agent

**References:**
- External framework projects document @plan usage
- GitHub Copilot supports @workspace, @plan, and other built-in agents

---

### Milestone Spec Links in Epic README
**Discovered:** 2026-01-29 during critical-flow-data-foundation epic creation  
**Category:** Skill (milestone-draft)  
**Impact:** Low-Medium - Inconsistent documentation structure, manual work to add/remove links  
**Status:** Identified  

**Issue:**
When the documenter agent creates milestone specifications using the milestone-draft skill, it updates epic-roadmap.md but NOT the epic README to add links to the newly created milestone specs. This creates inconsistency across epics.

**Current Behavior:**
- Some milestone sections in epic READMEs have spec links (added manually)
- Some don't have links
- epic-roadmap.md is correctly updated with milestone information

**Options Considered:**
- **Option A (Recommended):** Never link from epic README - keep strategic overview separate from tactical specs
- **Option B:** Always link - update milestone-draft skill to modify epic README
- **Option C:** Conditional linking - link only after milestone-start

**Recommendation:**
**Option A** - Epic README remains strategic overview, epic-roadmap.md provides navigation to detailed milestone specs.

**Rationale:**
- Epic README is strategic/planning document
- Milestone specs are tactical/implementation documents
- epic-roadmap.md is the proper index/navigation document
- Reduces coupling between documents
- Keeps epic README stable during milestone work

**Action Items:**
- [ ] Update milestone-draft skill documentation to clarify linking behavior
- [ ] Update epic template (if exists) to not include spec links
- [ ] Document this pattern in milestone-documentation-guide.md
- [ ] Add to framework-review skill checklist

**Related Skills:** milestone-draft, epic-refine, epic-start  
**Related Docs:** docs/development/milestone-documentation-guide.md, .ai/skills/milestone-draft.md

### Maintainer vs Documenter Role Confusion
**Discovered:** 2026-01-30 during documentation ownership discussion  
**Category:** Agent Roles  
**Impact:** Medium - Unclear ownership of documentation tasks  
**Status:** Resolved  

**Issue:**
Maintainer agent responsibilities included "Keep documentation structure consistent (docs/)" which conflated:
- Framework documentation (.ai/ directory) - framework maintenance
- Project documentation (docs/, work/specs/) - project content

**Resolution:**
- **Maintainer agent:** Owns ai/ directory only (framework code, skills, agents, instructions)
- **Documenter agent:** Owns project documentation (docs/, work/specs/)

**Action Items:**
- [x] Update maintainer.md to clarify framework-only scope
- [x] Update documenter.md to include docs/ and specs responsibilities
- [x] Remove translation sync as a documenter task (not maintainer)

**Rationale:**
- Framework (.ai/) is code-like infrastructure maintained separately
- Project docs (docs/, work/specs/) are content that evolves with project features
- Translations (if any) are content work, not framework work

**Related Agents:** maintainer, documenter

### Lack of Prescriptive Spec Templates
**Discovered:** 2026-01-30 during framework comparison with Spec Kit/Kiro/Tessl  
**Category:** Skill (milestone-draft, epic-refine)  
**Impact:** High - Inconsistent spec quality, missing critical details, harder for AI to generate good code  
**Status:** Identified  

**Issue:**
Our framework uses freeform specifications without structured templates. This leads to:
- Inconsistent spec quality across milestones
- Missing critical sections (what vs why vs how separation)
- No formal gates or checklists to prevent specification errors
- Harder for AI to understand intent and generate correct implementations

**Comparison:**
- **GitHub Spec Kit:** Strict templates with WHAT/WHY (spec.md) vs HOW (plan.md) separation, `[NEEDS CLARIFICATION]` markers, checklists
- **Kiro/Tessl:** Structured spec formats with clear sections
- **Our framework:** Freeform markdown with general guidance in skills

**Recommendation:**
Create structured milestone specification templates with:
- Clear sections: Purpose, Context, Success Criteria, Architecture, Implementation Plan
- Checklists for common mistakes ("Did you define the API contract?", "Are dependencies explicit?")
- Formal separation of WHAT/WHY/HOW
- `[NEEDS CLARIFICATION]` convention for explicit uncertainty
- Template validation in milestone-draft skill

**Ambition:** This is a priority - better spec generation is a core framework goal

**Action Items:**
- [ ] Create milestone spec template in work/specs/templates/
- [ ] Create epic spec template with similar rigor
- [ ] Update milestone-draft skill to enforce template usage
- [ ] Add spec quality checklist to code-review skill
- [ ] Document WHAT/WHY/HOW separation principle

**Related Skills:** milestone-draft, epic-refine, code-review  
**Related Docs:** work/specs/templates/ (to be created)

### Deployer Agent Conflates Release and Infrastructure Roles
**Discovered:** 2026-02-03 during AI framework flowchart analysis  
**Category:** Agent Roles  
**Impact:** Medium - Unclear ownership and naming confusion  
**Status:** Identified  
**Branch:** docs/ai-framework-flowchart

**Issue:**
The `deployer` agent has two distinct and separable responsibilities:
1. **Release ceremony** - Git tagging, version management, release documentation, stakeholder communication
2. **Infrastructure deployment** - Actual deployment to environments, CI/CD pipelines, infrastructure management

This conflates what are typically two separate roles in DevOps teams:
- **Release Manager** - Coordinates release planning, version control, release notes, stakeholder communication
- **DevOps Engineer / SRE** - Handles infrastructure, deployments, CI/CD pipelines, monitoring

**Current Behavior:**
- Agent named "deployer" but primarily executes release ceremonies
- Skills include both `release` (git tags, docs) and `deployment` (infrastructure)
- Flowchart shows epic-wrap → deployer → release → deployment
- Naming suggests infrastructure focus but work is release coordination

**Recommendation:**
**Option A (Recommended):** Rename agent to "releaser" to better reflect primary responsibility:
- More accurately describes git tagging, versioning, release documentation
- Distinguishes from day-to-day deployment operations
- Most teams have automated deployments but manual release coordination
- Clearer separation of concerns

**Option B:** Keep "deployer" but add clarity:
- Update agent description to emphasize BOTH roles explicitly
- Consider if this creates too broad a responsibility

**Option C:** Split into two agents:
- "release-manager" - Tags, docs, coordination
- "platform-engineer" - Infrastructure, deployments
- May be overkill for most projects

**Action Items:**
- [ ] Decide on agent naming (releaser vs deployer vs split)
- [ ] Update .ai/agents/deployer.md (or rename file)
- [ ] Update all skill references to use correct agent name
- [ ] Update ai/framework-flowchart.md if agent renamed
- [ ] Update trigger phrase documentation

**Related Skills:** release, deployment  
**Related Agents:** deployer (current), releaser (proposed)  
**Related Docs:** .ai/agents/deployer.md, ai/framework-flowchart.md

### Context-Refresh Skill Not Linked to Epic-Level Workflows
**Discovered:** 2026-02-03 during AI framework flowchart analysis  
**Category:** Skill  
**Impact:** Medium - Context loss during long epic-level sessions  
**Status:** Identified  
**Branch:** docs/ai-framework-flowchart

**Issue:**
The `context-refresh` skill documentation states it should be used:
> "Before starting major work (epic/milestone)"

However:
1. **Flowchart only shows connection to milestone-start**, not epic-level skills
2. **epic-refine and epic-start don't mention context-refresh** as preflight step
3. **Epic work can be lengthy** with extensive Q&A and decision making
4. **No guidance on when to refresh** during long epic planning sessions

**Impact:**
Epic-level work often involves:
- Long conversation sessions (>20 exchanges)
- Complex architectural discussions
- Multiple stakeholder inputs
- Switching between planning topics
- Sessions spanning multiple days

Without explicit context-refresh linkage, AI may lose critical context during epic planning.

**Recommendation:**
Make context-refresh explicit for all major workflow entry points:

1. **Update skill documentation:**
   - `epic-refine` - Add optional preflight: "If returning to epic after time away, use context-refresh first"
   - `epic-start` - Add optional preflight: "For long-dormant epics, use context-refresh to reload context"
   - `milestone-start` - Already implied, make explicit
   - `release` - Add optional preflight for complex release coordination

2. **Update flowchart:**
   - Show dotted lines from context-refresh to: epic-refine, epic-start, milestone-start, release
   - Indicate these are optional/as-needed connections

3. **Add trigger guidance:**
   - Document when to proactively suggest context-refresh
   - Add to long-running skill checklists

**Current Workaround:**
Users can manually invoke context-refresh, but without explicit guidance they may not know to do so.

**Action Items:**
- [ ] Update .ai/skills/epic-refine.md to mention context-refresh as optional preflight
- [ ] Update .ai/skills/epic-start.md to mention context-refresh as optional preflight
- [ ] Update .ai/skills/milestone-start.md to make context-refresh explicit
- [ ] Update .ai/skills/release.md to mention context-refresh for complex releases
- [ ] Update ai/framework-flowchart.md to show additional context-refresh connections
- [ ] Document "when to suggest context-refresh" in ALWAYS_DO.md or context-refresh skill

**Related Skills:** context-refresh, epic-refine, epic-start, milestone-start, release  
**Related Docs:** ai/framework-flowchart.md

### Context Loading Strategy and Session State
**Discovered:** 2026-01-30 during framework review  
**Category:** Process, Memory Model  
**Impact:** High - Context loss when sessions restart, unclear what gets loaded  
**Status:** Identified  

**Issue:**
No clear strategy for context loading and session state management:

1. **Global vs Session Context Confusion:**
   - **Global context** (static baseline): .ai/instructions/ALWAYS_DO.md, agents, skills, architecture decisions, ROADMAP.md
   - **Session context** (active work): Current epic/milestone, today's decisions, conversation insights
   - Unclear which is automatically loaded vs manually loaded

2. **Context-Refresh Behavior Undefined:**
   - What does context-refresh actually reload?
   - How does it detect current session (epic, milestone, branch)?
   - No documented contract for context recovery

3. **Session State Loss:**
   - Important conversation context lost when session ends:
     - Design reasoning ("chose A over B because...")
     - Q&A outcomes ("user confirmed two schemas approach")
     - Open questions and blockers
   - **Currently:** No mechanism to preserve conversation context at all
   - **Proposed:** Append to session file when user signals ("record this", "note that", "remember this")

4. **No Session Identity:**
   - Multiple parallel sessions can conflict
   - No way to identify/resume specific session
   - Tracking docs exist but not used for session recovery

**Recommendation:**

**Session Context Files:**
Create `.ai/sessions/session-[id].md` for ephemeral session state (regular directory, not hidden):

```markdown
# Session Context

**Session ID:** [id]
**Started:** 2026-01-30 14:00
**Branch:** arch/critical-flow-mvp-plan
**Epic:** critical-flow-data-foundation
**Milestone:** m-cfdf-01-query-schema

## Current Focus
Working on schema design - decided two schemas approach

## Recent Decisions
- 14:35: Two schemas (bar-chart, trend-table) for independent evolution
- 15:20: DevOps links in docs for org accessibility

## Open Questions
- Session ID generation method (see below)

## Next Steps
- Complete schema definition in M1
```

**Session ID Generation (NEEDS TESTING):**
- ⚠️ **Not branch name** (conflicts if multiple sessions on same branch)
- ⚠️ **Not timestamp** (constantly changing, can't reliably identify which session file is "mine")
- 🔍 **Viable options to test:**
  - GitHub Copilot session ID (if accessible via API)
  - Random GUID/UUID (guaranteed unique, reliable)
- **Action:** Test what's actually available and works reliably

**Add to .gitignore:**
```
ai/sessions/
```

**Workflow:**
1. Session starts → Create `.ai/sessions/session-[id].md`
2. During work → Append when user signals ("note that", "yes, go with that", "remember this")
3. Context-refresh → Reload global (.ai/instructions/) + session file + tracking doc
4. Milestone-wrap → Migrate important entries to tracking doc
5. Cleanup → Delete old session files (>7 days or milestone complete)

**Context-Refresh Behavior (Documented):**
1. Reload global: .ai/instructions/ALWAYS_DO.md, current agent definition
2. Detect session: Check for session file matching current session ID
3. Detect active work: Branch name, epic-roadmap.md status, tracking docs
4. Summarize: "You're working on epic X, milestone Y, last decision Z"

**Benefits:**
- ✅ Multiple parallel sessions (unique session IDs)
- ✅ Lightweight, append-only during session
- ✅ Conversation context preserved automatically
- ✅ Context-refresh can recover session state
- ✅ No git noise during work

**Action Items:**
- [ ] **TEST session ID generation** - determine what works reliably
- [ ] Create ai/sessions/ directory structure
- [ ] Add ai/sessions/ to .gitignore
- [ ] Document session-context.md template
- [ ] Update context-refresh skill to use session files
- [ ] Add session file creation to session-start skill
- [ ] Add session migration logic to milestone-wrap
- [ ] Document when to append to session file (user signals)

**Related Skills:** context-refresh, session-start, milestone-wrap  
**Related Gap:** Context Loading Strategy and Session State (sessions complement tracking docs)

### Infrequent Progress Recording
**Discovered:** 2026-01-30 during framework review  
**Category:** Process  
**Impact:** Medium-High - Risk of losing work, hard to resume after interruption  
**Status:** Identified  

**Issue:**
Progress is recorded only at milestone boundaries (milestone-wrap, epic-wrap), not continuously during work. If session crashes or context is lost, work done since last commit may be forgotten.

**Current State:**
- Tracking docs updated periodically but not systematically
- PROVENANCE.md updated after work is done
- No "save point" mechanism during long implementation sessions

**Recommendation:**
Implement continuous progress recording:
- Update tracking doc after each RED-GREEN-REFACTOR cycle
- Add "checkpoint" step in long-running skills
- Documenter agent prompted: "Record progress every 30 minutes of work"
- SESSION-CONTEXT.md (see Context Loading Strategy and Session State) updated after each significant step
- Git commits are already frequent (good), but docs should match

**Benefits:**
- Work is never lost
- Easy to resume after interruption
- Better audit trail for learning/post-mortems
- Helps AI maintain context across long sessions

**Action Items:**
- [ ] Add progress checkpoint step to red-green-refactor skill
- [ ] Add progress recording reminders to milestone-start
- [ ] Document "when to update tracking doc" guidelines
- [ ] Consider automated prompts every N tool calls

**Related Skills:** red-green-refactor, milestone-start, all implementation skills  
**Related Docs:** work/milestones/tracking/

### Informal Governance vs Constitutional Principles
**Discovered:** 2026-01-30 during Spec Kit comparison  
**Category:** Process, Documentation  
**Impact:** Medium - Inconsistent adherence to principles, harder to enforce quality gates  
**Status:** Identified  
**Inspiration:** GitHub Spec Kit's Constitutional Governance

**Issue:**
`.ai/instructions/ALWAYS_DO.md` provides guardrails but lacks the formal, immutable structure of Spec Kit's 9-article constitution (library-first, test-first, CLI-first, etc.). This results in:
- Principles stated as suggestions rather than laws
- No explicit enforcement mechanism
- Easier to skip principles when convenient
- Less clarity about what's negotiable vs absolute

**Spec Kit's Approach:**
- 9 immutable articles of development
- Explicit constitutional status
- Enforced through phase gates
- Clear consequences for violation

**Recommendation:**
Formalize `ALWAYS_DO.md` into constitutional governance:
- Elevate critical principles to "articles" (immutable)
- Number and name them explicitly (Article 1: Human Approval, Article 2: Test-First, etc.)
- Add preamble explaining their status
- Reference in all skill documentation
- Consider enforcement checkpoints in skills

**Action Items:**
- [ ] Restructure ALWAYS_DO.md as formal constitution
- [ ] Identify which principles are immutable vs guidelines
- [ ] Add constitutional references to skills
- [ ] Document what happens when principles are violated

**Related Files:** .ai/instructions/ALWAYS_DO.md  
**Related Skills:** All skills (should enforce constitution)

### Missing Phase Gates
**Discovered:** 2026-01-30 during Spec Kit comparison  
**Category:** Process, Quality  
**Impact:** Medium-High - Quality issues slip through, principles not enforced systematically  
**Status:** Identified  
**Inspiration:** GitHub Spec Kit's Phase Gates

**Issue:**
No formal gates between phases to enforce principles before proceeding. Spec Kit uses gates like:
- Simplicity Gate (before implementation: "≤3 external dependencies?")
- Anti-Abstraction Gate ("Using framework APIs directly, not wrapping?")
- Integration-First Gate ("API contracts defined?")

We lack systematic checkpoints to prevent:
- Premature implementation before spec is clear
- Skipping test-first discipline
- Missing architecture decisions
- Over-engineering / premature abstraction

**Recommendation:**
Add phase gates to critical transitions:
- **epic-start gate:** Epic refined? Dependencies clear? Success criteria testable?
- **milestone-start gate:** Spec complete? Acceptance criteria defined? Entry criteria met?
- **implementation gate:** Tests written first? Architecture reviewed? Contracts defined?
- **milestone-wrap gate:** All tests passing? Docs updated? DoD checklist complete?

Gates should be:
- Explicit checklists in skills
- Enforced by AI (refuse to proceed if gate fails)
- Documented in skill files

**Action Items:**
- [ ] Design gate checklists for each transition
- [ ] Add gates to epic-start, milestone-start, red-green-refactor
- [ ] Document gate criteria in skills
- [ ] Add gate enforcement to skill procedures

**Related Skills:** epic-start, milestone-start, red-green-refactor, milestone-wrap  
**Related Gap:** Informal Governance vs Constitutional Principles (constitutional governance supports gate enforcement)

### No Formalized Development Principles
**Discovered:** 2026-01-30 during Spec Kit comparison  
**Category:** Documentation, Process  
**Impact:** Medium - Inconsistent approaches, reinventing patterns  
**Status:** Identified  
**Inspiration:** GitHub Spec Kit's Development Principles (library-first, test-first, CLI-first, etc.)

**Issue:**
We have scattered principles (TDD in skills, "no time estimates" in ALWAYS_DO) but no unified, documented development philosophy. Spec Kit explicitly defines:
- Library-first (write libraries, not applications)
- Test-first (tests before implementation)
- CLI-first (programs are CLIs with optional UIs)
- Integration-first (define contracts before implementation)
- Anti-abstraction (use framework directly, don't wrap)

**Current State:**
- Principles implied in skills but not explicitly documented
- No single "Development Principles" document
- Hard to onboard new developers or AI sessions
- Easy to forget or contradict principles

**Recommendation:**
Create `.ai/instructions/DEVELOPMENT_PRINCIPLES.md`:
- Document core principles explicitly (Test-First, Human-Gated, Milestone-First, etc.)
- Explain rationale for each principle
- Provide examples and counter-examples
- Link from ALWAYS_DO.md and README
- Reference in skill documentation

**Candidate Principles:**
1. **Human-Gated:** Never commit without approval
2. **Test-First:** RED-GREEN-REFACTOR discipline
3. **Milestone-First:** Work organized around milestones, not dates
4. **Spec-Guided:** Specifications guide implementation (not prescriptive like Spec Kit, but guided)
5. **Role-Based:** Respect agent boundaries, escalate appropriately
6. **Epic-Scoped:** Features organized into cohesive epics
7. **Framework-Aware:** Framework evolves through use (maintainer agent)

**Action Items:**
- [ ] Create .ai/instructions/DEVELOPMENT_PRINCIPLES.md
- [ ] Document 7-10 core principles with rationale
- [ ] Link from README and ALWAYS_DO.md
- [ ] Reference in skill documentation
- [ ] Add to session-start orientation

**Related Files:** .ai/instructions/ALWAYS_DO.md (will reference principles)  
**Related Gap:** Informal Governance vs Constitutional Principles (constitutional governance), Missing Phase Gates (phase gates enforce principles)

### No Uncertainty Markers Convention
**Discovered:** 2026-01-30 during Spec Kit comparison  
**Category:** Documentation, Specification Quality  
**Impact:** Medium - Ambiguity in specs, unclear what needs clarification  
**Status:** Identified  
**Inspiration:** GitHub Spec Kit's `[NEEDS CLARIFICATION]` convention

**Issue:**
No standardized way to mark uncertain or incomplete parts of specifications. Spec Kit uses explicit markers:
- `[NEEDS CLARIFICATION]` - Placeholder requiring stakeholder input
- Forces explicit acknowledgment of uncertainty
- Searchable (can find all unclear points with grep)
- Prevents proceeding with ambiguous specs

**Current State:**
- Uncertainty expressed informally ("TBD", "TODO", "?", or just missing)
- No way to systematically find all unclear points
- Easy to forget what needs clarification
- No enforcement that uncertainties are resolved before implementation

**Recommendation:**
Adopt standardized uncertainty markers:
- `[NEEDS CLARIFICATION]` - Requires stakeholder/architect input
- `[NEEDS RESEARCH]` - Requires technical investigation
- `[NEEDS DECISION]` - Requires architectural or design decision
- `[PLACEHOLDER]` - Known gap, to be filled later

**Usage:**
- Required in milestone specs when something is unclear
- Must be resolved before milestone-start (gate enforcement)
- Searchable: `grep -r "\[NEEDS" docs/`
- Documented in spec templates (see Lack of Prescriptive Spec Templates)

**Action Items:**
- [ ] Document uncertainty marker convention
- [ ] Add to milestone spec template (see Lack of Prescriptive Spec Templates)
- [ ] Add to epic spec template
- [ ] Add gate check: "No unresolved markers before milestone-start"
- [ ] Add to code-review checklist: "Are all uncertainties resolved?"

**Related Gap:** Lack of Prescriptive Spec Templates (spec templates), Missing Phase Gates (phase gates)  
**Related Skills:** milestone-draft, epic-refine, milestone-start, code-review

---

## Resolved Framework Gaps

### Sequential Gap IDs Cause Merge Conflicts
**Discovered:** 2026-02-03 during GAPS.md format discussion  
**Category:** Documentation, Process  
**Impact:** Medium - Guaranteed merge conflicts when multiple branches add gaps  
**Status:** Resolved  
**Resolved:** 2026-02-03  
**Branch:** docs/ai-framework-flowchart

**Issue:**
GAPS.md originally used sequential numbering (FW-GAP-001, FW-GAP-002, etc.). When multiple users or branches add gaps simultaneously:
- Branch A adds FW-GAP-004
- Branch B also adds FW-GAP-004 (same number!)
- Guaranteed merge conflict on ID

**Alternatives Considered:**
- **Date-based IDs** (FW-GAP-2026-02-03-A) - Reduces conflicts but still has collision risk with letter suffixes
- **UUID/hash** (FW-GAP-a3f9) - No collisions but not human-friendly
- **Category prefixes** (FW-SKILL-001) - Semantic but still sequential conflicts
- **Timestamp + number** (FW-GAP-20260203-0001) - Low collision but requires coordination
- **No IDs, use titles** - No conflicts, human-readable (CHOSEN)

**Resolution:**
Use descriptive titles without sequential IDs:
```markdown
### Context-Refresh Skill Not Linked to Epic-Level Workflows
**Discovered:** 2026-02-03
**Category:** Skill
```

**Benefits:**
- ✅ No merge conflicts on IDs
- ✅ Human-readable, easier to reference by name
- ✅ Discovered date provides chronological ordering
- ✅ Forces better documentation (unique, descriptive titles)
- ✅ Similar to how GitHub Issues work (title-based with auto-assigned numbers)

**Implementation:**
- Updated format section to remove sequential ID requirement
- Removed IDs from all existing gaps
- Added note explaining rationale
- Updated all gap cross-references to use titles

**Action Items:**
- [x] Update GAPS.md format section
- [x] Remove IDs from existing gaps
- [x] Add explanation note
- [x] Update all cross-references to use titles
- [ ] Update gap-triage skill to reflect new format

**Related Skills:** gap-triage  
**Related Docs:** ai/GAPS.md (this file), work/GAPS.md (project-level gaps)

---

## Won't Fix

*None yet*

---

## Legend

- 🔍 **Identified** - Discovered but not yet addressed
- 🔄 **In Progress** - Being worked on
- ✅ **Resolved** - Addressed and documented
- ⏸️ **Won't Fix** - Decided not to address

---

**Last Updated:** 2026-01-29
