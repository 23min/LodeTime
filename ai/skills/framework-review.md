# Skill: framework-review

**Maturity:** Production-ready

**Purpose:** Evaluate framework effectiveness and plan improvements.

**Trigger phrases:**
- "Review the framework"
- "How can we improve workflows?"
- "Evaluate skill effectiveness"
- "Framework health check"

**Use when:**
- After completing 3+ epics or 10+ milestones
- Multiple post-mortems identify recurring issues
- User requests framework assessment
- Regular maintenance cadence (quarterly, semi-annually)

**Do not use when:**
- Individual skill failure (use post-mortem instead)
- Mid-milestone (wait for natural breakpoint)

## Inputs
- **Required:** 
  - Time period to review (e.g., "last 3 months", "since v1.0")
- **Optional:** 
  - Specific skills to evaluate
  - Known pain points or feedback
  - Post-mortem records

## Preconditions / preflight
- Framework has been in use (not initial setup)
- Some work history exists (milestones, epics, or sessions completed)
- Access to tracking docs and session logs

## Process

### Step 1: Gather Usage Data

Collect information about framework usage:
- **How many epics/milestones completed?**
- **Which skills were used most frequently?**
- **Which skills were never used?** (candidates for removal or better documentation)
- **Review post-mortem records** (recurring issues?)
- **Check session logs** for patterns

### Step 2: Evaluate Skill Health

For each skill (or focus on top 10 most-used):

**Questions to answer:**
- Is the skill documentation clear and complete?
- Are preconditions properly validated?
- Are decision points explicit?
- Is the handoff to next skill smooth?
- Does it follow the standard template?
- Are there common failure modes documented?

**Rate each skill:**
- ✅ Healthy (works well, few issues)
- ⚠️ Needs improvement (some friction, unclear sections)
- 🔴 Broken (frequently fails, requires rework)

### Step 3: Identify Gaps

**Are there missing skills?**
- Repeated ad-hoc workflows that should be standardized
- Handoff points with no corresponding skill
- Frequently asked "how do I...?" questions

**Are there redundant skills?**
- Multiple skills doing similar things
- Skills that could be consolidated

### Step 4: Review Agent Definitions

For each agent:
- Are responsibilities clear?
- Are Key Skills accurate?
- Are escalation triggers helpful?
- Do agents follow the standard template?

### Step 5: Check Global Guardrails

Review `instructions/ALWAYS_DO.md`:
- Are rules being followed?
- Are there conflicts or ambiguities?
- Should new guardrails be added based on recurring issues?

### Step 6: Assess Framework Maturity

Overall framework health:
- **Adoption:** Is the team using it consistently?
- **Effectiveness:** Does it improve workflow quality/speed?
- **Maintenance:** Is it kept up-to-date?
- **Documentation:** Is it discoverable and clear?

### Step 7: Create Improvement Plan

Prioritize findings:

**Tier 1 (Fix immediately):**
- Broken skills (🔴)
- Critical missing skills
- Ambiguous guardrails

**Tier 2 (Plan for next cycle):**
- Skills needing improvement (⚠️)
- Template compliance
- Documentation gaps

**Tier 3 (Nice-to-have):**
- Redundant skill consolidation
- Advanced features
- Optimization

### Step 8: Document and Execute

Create or update `FRAMEWORK-CHANGELOG.md`:
```markdown
## Framework Review: [Date]

**Period Reviewed:** [Start date] - [End date]
**Epics/Milestones Completed:** [Count]

### Findings
- [Key finding 1]
- [Key finding 2]

### Skills Evaluated
- ✅ [skill-name]: Healthy
- ⚠️ [skill-name]: Needs improvement ([reason])
- 🔴 [skill-name]: Broken ([reason])

### Gaps Identified
- Missing: [skill or feature]
- Redundant: [skill to consolidate]

### Improvement Plan
**Tier 1 (Immediate):**
- [ ] [Action item]

**Tier 2 (Next cycle):**
- [ ] [Action item]

**Tier 3 (Future):**
- [ ] [Action item]

### Next Review
Scheduled for: [Date]
```

## Outputs
- Framework health report in FRAMEWORK-CHANGELOG.md
- Prioritized improvement backlog
- Updated skills (if immediate fixes applied)
- Optional: Framework version bump if significant changes

## Decision points
- **Decision:** Should we version-bump the framework?
  - **Options:** A) Major changes (breaking), B) Minor (new features), C) Patch (fixes), D) No bump
  - **Default:** C (patch) if any fixes applied
  - **Record in:** FRAMEWORK-CHANGELOG.md

## Guardrails
- Be objective (data-driven, not opinion-based)
- Focus on patterns, not individual incidents
- Include positive findings (what works well)
- Keep improvement plan realistic (don't overcommit)
- Time-box review to 2-4 hours max

## Common Failure Modes
1. Too broad (trying to review everything) → Focus on most-used skills first
2. No actionable outcomes → Ensure Tier 1 has specific, achievable tasks
3. Review never executed → Schedule next review date immediately

## Handoff
- **Next skill:** 
  - Update individual skills based on findings
  - Create new skills if gaps identified
  - Use post-mortem for specific skill failures

## Related Skills
- **Before this:** Multiple post-mortem records (input data)
- **After this:** Skill updates, new skill creation
- **Regular cadence:** Repeat quarterly or after major milestones

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** maintainer
