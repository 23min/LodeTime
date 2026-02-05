# Skill: post-mortem

**Maturity:** Production-ready

**Purpose:** Learn from workflow failures to improve the framework.

**Trigger phrases:**
- "That was confusing"
- "This skill needs improvement"
- "Post-mortem on [skill/workflow]"
- "What went wrong with [task]?"

**Use when:**
- After ANY skill execution that felt unclear, failed, or required multiple retries
- User expresses frustration or confusion
- Agent detects repeated attempts at same task (3+ tries)
- Workflow didn't produce expected results

**Do not use when:**
- Normal successful workflow completion
- Expected complexity (not a failure or confusion)

## Inputs
- **Required:** 
  - Which skill(s) were used
  - What went wrong or was unclear
- **Optional:** 
  - Context (milestone ID, epic slug, session date)
  - Proposed fix or improvement

## Preconditions / preflight
- A workflow has been attempted (successful or failed)
- User or agent has identified a learning opportunity

## Process

### Step 1: Identify the Issue
Quick 2-minute reflection:
- **What skill(s) were used?** (e.g., milestone-start, epic-refine)
- **What was the expected outcome?**
- **What actually happened?**
- **Where did it break down?** (ambiguous instructions, missing preconditions, unclear outputs)

### Step 2: Analyze Root Cause
- **Was the skill documentation unclear?**
- **Were preconditions not validated?**
- **Was a decision point ambiguous?**
- **Was required context missing?**
- **Was the handoff to next skill unclear?**

### Step 3: Record Findings
Document in appropriate location:
- **Milestone work:** Add to tracking doc's Implementation Log
- **Epic work:** Add to `work/epics/<epic-slug>/session-log.md`
- **Framework work:** Note in FRAMEWORK-CHANGELOG.md or create issue

**Template:**
```markdown
### Post-Mortem: [Date]

**Skills involved:** [skill names]

**What went wrong:**
[Brief description]

**Root cause:**
[Why it happened]

**Proposed fix:**
[How to improve the skill/framework]

**Priority:** Low | Medium | High
```

### Step 4: Optionally File Improvement
If the issue is significant or recurring:
- Create issue in framework repository
- File PR with skill improvement
- Add to maintainer's backlog

## Outputs
- Post-mortem record in tracking doc or session log
- Optional: Issue or PR for framework improvement
- Learning captured for future reference

## Decision points
- **Decision:** Should this be filed as an issue?
  - **Options:** A) Record only in log, B) Create issue for later, C) Fix immediately
  - **Default:** A (record in log)
  - **Record in:** Implementation log or session log

## Guardrails
- Keep post-mortems blame-free (focus on process, not people)
- Be specific about what failed (not just "it didn't work")
- Propose actionable improvements (not just complaints)
- Time-box reflection to 5 minutes max

## Common Failure Modes
1. Post-mortem too vague → Add specific examples and context
2. No proposed fix → Suggest at least one improvement idea
3. Blame-focused → Reframe as process improvement opportunity

## Handoff
- **Next skill:** 
  - If immediate fix → Update the problematic skill
  - If deferred → Add to maintainer backlog (framework-review)
  - If recorded only → Continue with original workflow

## Related Skills
- **After this:** framework-review (if multiple post-mortems accumulate)
- **Alternatives:** Direct skill update (if fix is obvious and small)

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** maintainer (any agent can trigger, maintainer executes)
