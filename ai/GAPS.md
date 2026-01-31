# AI Framework Gaps

Discovered gaps, inconsistencies, and improvement opportunities in the AI-First development framework.

**Scope:** Framework issues, skill gaps, process improvements  
**Not included:** Solution/code bugs (use `dev/gaps.md` for those)

---

## Format

Each framework gap entry should include:
- **ID**: Sequential gap number (FW-GAP-XXX)
- **Discovered**: When and where the gap was found
- **Category**: Skill, Process, Documentation, Tooling
- **Impact**: Why it matters
- **Status**: Identified, In Progress, Resolved, Won't Fix
- **Recommendation**: Proposed solution

---

## Active Framework Gaps

### FW-GAP-001 - Milestone Spec Links in Epic README
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
**Related Docs:** dev/development/milestone-documentation-guide.md, ai/skills/milestone-draft.md

### FW-GAP-002 - Maintainer vs Documenter Role Confusion
**Discovered:** 2026-01-30 during wiki translation discussion  
**Category:** Agent Roles  
**Impact:** Medium - Unclear ownership of documentation tasks  
**Status:** Resolved  

**Issue:**
Maintainer agent responsibilities included "Keep documentation structure consistent (dev/, wiki/)" which conflated:
- Framework documentation (ai/ directory) - framework maintenance
- Project documentation (dev/, wiki/) - project content and translation

**Resolution:**
- **Maintainer agent:** Owns ai/ directory only (framework code, skills, agents, instructions)
- **Documenter agent:** Owns project documentation (dev/, wiki/, specs, translations)

**Action Items:**
- [x] Update maintainer.md to clarify framework-only scope
- [x] Update documenter.md to include wiki/ and translation responsibilities
- [x] Document wiki translation sync as documenter task (not maintainer)

**Rationale:**
- Framework (ai/) is code-like infrastructure maintained separately
- Project docs (dev/, wiki/) are content that evolves with project features
- Translations (English → Swedish) are content work, not framework work

**Related Agents:** maintainer, documenter

### FW-GAP-003 - Lack of Prescriptive Spec Templates
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
- [ ] Create milestone spec template in dev/specs/templates/
- [ ] Create epic spec template with similar rigor
- [ ] Update milestone-draft skill to enforce template usage
- [ ] Add spec quality checklist to code-review skill
- [ ] Document WHAT/WHY/HOW separation principle

**Related Skills:** milestone-draft, epic-refine, code-review  
**Related Docs:** dev/specs/templates/ (to be created)

### FW-GAP-004 - Context Loading Strategy and Session State
**Discovered:** 2026-01-30 during framework review  
**Category:** Process, Memory Model  
**Impact:** High - Context loss when sessions restart, unclear what gets loaded  
**Status:** Identified  

**Issue:**
No clear strategy for context loading and session state management:

1. **Global vs Session Context Confusion:**
   - **Global context** (static baseline): ai/instructions/ALWAYS_DO.md, agents, skills, architecture decisions, ROADMAP.md
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
Create `ai/sessions/session-[id].md` for ephemeral session state (regular directory, not hidden):

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
- 15:20: DevOps links in wiki for org accessibility

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
1. Session starts → Create `ai/sessions/session-[id].md`
2. During work → Append when user signals ("note that", "yes, go with that", "remember this")
3. Context-refresh → Reload global (ai/instructions/) + session file + tracking doc
4. Milestone-wrap → Migrate important entries to tracking doc
5. Cleanup → Delete old session files (>7 days or milestone complete)

**Context-Refresh Behavior (Documented):**
1. Reload global: ai/instructions/ALWAYS_DO.md, current agent definition
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
**Related Gap:** FW-GAP-005 (frequent progress recording - sessions complement tracking docs)

### FW-GAP-005 - Infrequent Progress Recording
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
- SESSION-CONTEXT.md (see FW-GAP-004) updated after each significant step
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
**Related Docs:** dev/milestones/tracking/

### FW-GAP-006 - Informal Governance vs Constitutional Principles
**Discovered:** 2026-01-30 during Spec Kit comparison  
**Category:** Process, Documentation  
**Impact:** Medium - Inconsistent adherence to principles, harder to enforce quality gates  
**Status:** Identified  
**Inspiration:** GitHub Spec Kit's Constitutional Governance

**Issue:**
`ai/instructions/ALWAYS_DO.md` provides guardrails but lacks the formal, immutable structure of Spec Kit's 9-article constitution (library-first, test-first, CLI-first, etc.). This results in:
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

**Related Files:** ai/instructions/ALWAYS_DO.md  
**Related Skills:** All skills (should enforce constitution)

### FW-GAP-007 - Missing Phase Gates
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
**Related Gap:** FW-GAP-006 (constitutional governance supports gate enforcement)

### FW-GAP-008 - No Formalized Development Principles
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
Create `ai/instructions/DEVELOPMENT_PRINCIPLES.md`:
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
- [ ] Create ai/instructions/DEVELOPMENT_PRINCIPLES.md
- [ ] Document 7-10 core principles with rationale
- [ ] Link from README and ALWAYS_DO.md
- [ ] Reference in skill documentation
- [ ] Add to session-start orientation

**Related Files:** ai/instructions/ALWAYS_DO.md (will reference principles)  
**Related Gap:** FW-GAP-006 (constitutional governance), FW-GAP-007 (phase gates enforce principles)

### FW-GAP-009 - No Uncertainty Markers Convention
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
- Searchable: `grep -r "\[NEEDS" dev/`
- Documented in spec templates (FW-GAP-003)

**Action Items:**
- [ ] Document uncertainty marker convention
- [ ] Add to milestone spec template (FW-GAP-003)
- [ ] Add to epic spec template
- [ ] Add gate check: "No unresolved markers before milestone-start"
- [ ] Add to code-review checklist: "Are all uncertainties resolved?"

**Related Gap:** FW-GAP-003 (spec templates), FW-GAP-007 (phase gates)  
**Related Skills:** milestone-draft, epic-refine, milestone-start, code-review

---

## Resolved Framework Gaps

*None yet*

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
