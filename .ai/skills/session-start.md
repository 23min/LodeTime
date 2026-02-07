# Skill: session-start

**Purpose:** Interactive session kickoff that guides users to the right role and task.

**Trigger phrases:**
- "Start a session"
- "What should I work on?"
- "Help me get started"
- "Which task should I do?"
- "Begin work"

---

## Process

### Step 1: Greet and Orient

Present a brief orientation:

```
Welcome! I'll help you start working with the right approach.

This project uses AI-assisted development with:
- Agents (architect, implementer, tester, documenter, deployer)
- Skills (reusable workflows for epics, milestones, releases)
- Guardrails (TDD, no time estimates, milestone-first)
```

### Step 2: Determine Context

Ask the user:

**"What would you like to work on?"**

Provide menu:
```
1. Plan a new epic (large architectural initiative)
2. Draft a milestone specification (discrete feature)
3. Start or continue implementing a milestone
4. Write or fix tests for existing code
5. Review code changes
6. Wrap up a completed milestone
7. Create a release
8. Create or switch branches
9. Something else (describe it)
```

### Step 3: Route to Appropriate Skill

Based on the user's choice, hand off to the right skill and agent:

| Choice | Agent | Skill | Action |
|--------|-------|-------|--------|
| 1 | architect | [epic-refine](epic-refine.md) | Run structured Q&A for epic planning |
| 2 | documenter | [milestone-draft](milestone-draft.md) | Draft milestone spec |
| 3 | implementer | [milestone-start](milestone-start.md) | Begin or resume milestone |
| 4 | tester | [red-green-refactor](red-green-refactor.md) | TDD workflow |
| 5 | tester | [code-review](code-review.md) | Review checklist |
| 6 | documenter | [milestone-wrap](milestone-wrap.md) | Complete milestone |
| 7 | deployer | [release](release.md) | Release ceremony |
| 8 | architect | [branching](branching.md) | Branch strategy |
| 9 | - | - | Ask for more details and route accordingly |

### Step 4: Context Gathering

Before handing off to the selected skill, gather any additional context:

**For epic work:**
- Epic name/slug
- High-level goal
- Known constraints

**For milestone work:**
- Milestone ID
- Epic context (if applicable)
- Current branch

**For release work:**
- What merged to main
- Last version number
- Milestone ID completed

### Step 5: Handoff

State clearly which skill is being invoked and which agent persona you're adopting:

```
Switching to [AGENT] role and using [SKILL] skill.

Context summary:
- [Key context item 1]
- [Key context item 2]

Proceeding with [SKILL]...
```

---

## Example Session Flows

### Flow 1: New Epic Planning
```
User: "Start a session"
AI: [Presents menu]
User: "1 - Plan a new epic"
AI: "What's the epic name and high-level goal?"
User: "Epic: api-redesign, Goal: Modernize the REST API"
AI: "Switching to architect role and using epic-refine skill.
     Epic: api-redesign
     Goal: Modernize the REST API
     Proceeding with structured Q&A..."
[epic-refine skill executes]
```

### Flow 2: Continue Milestone Work
```
User: "What should I work on?"
AI: [Presents menu]
User: "3 - Continue milestone M-03.10"
AI: "Which branch are you on?"
User: "feature/api-m3/graph-queries"
AI: "Switching to implementer role and using milestone-start skill.
     Milestone: M-03.10
     Branch: feature/api-m3/graph-queries
     Resuming implementation..."
[milestone-start skill checks for tracking doc and continues]
```

### Flow 3: TDD Focus
```
User: "Help me get started"
AI: [Presents menu]
User: "4 - Write tests"
AI: "What component or feature needs tests?"
User: "Graph traversal logic in Core"
AI: "Switching to tester role and using red-green-refactor skill.
     Focus: Graph traversal in Core
     Starting RED phase..."
[red-green-refactor skill guides test-first workflow]
```

---

## Shortcuts

If the user's initial request is clear enough, skip the menu and go directly:

| User Request | Skip to Skill |
|-------------|---------------|
| "Plan epic X" | [epic-refine](epic-refine.md) |
| "Start milestone M-X" | [milestone-start](milestone-start.md) |
| "Write tests for..." | [red-green-refactor](red-green-refactor.md) |
| "Review my changes" | [code-review](code-review.md) |
| "Complete milestone M-X" | [milestone-wrap](milestone-wrap.md) |
| "Release version X" | [release](release.md) |

---

## Session Hygiene

Before starting any skill, verify:

1. **Current branch** - Are we on the right branch?
2. **Current state** - Any uncommitted changes? Build errors?
3. **Epic context** - Do we know which epic this work belongs to?
4. **Milestone context** - Do we have a milestone spec or tracking doc?

If any context is missing, gather it before proceeding.

---

## Outputs

- Clear identification of role and skill being used
- Context summary for the selected task
- Seamless handoff to the appropriate skill
- No ambiguity about what happens next

## Decision points
- **Decision:** Which skill to route to?
  - **Options:** Based on user's menu selection or inferred from request
  - **Default:** milestone-start (most common workflow)
  - **Record in:** Session begins with chosen skill

## Guardrails
- Verify session hygiene before handoff (branch, state, context)
- Don't proceed without clear direction (menu or explicit request)
- Always state which agent and skill you're switching to
- Gather missing context before starting work

## Common Failure Modes
1. Missing context \u2192 Ask for epic/milestone context before proceeding
2. Ambiguous request \u2192 Present menu to clarify
3. Wrong branch \u2192 Verify branch before starting work

## Handoff
- **Next skill:** Varies based on user selection (see routing table in Step 3)

## Related Skills
- **After this:** Any skill (entry point to framework)
- **Meta-level:** This skill helps navigate all other skills

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28

**Agent:** Any (context-dependent routing)

**Notes:**
- This skill is meta-level: it helps users navigate the framework itself
- Keep the interaction brief and goal-oriented
- Default to the most common patterns (milestone work)
- If the user knows exactly what they want, don't force the menu
- Update this skill when new agents or skills are added to the framework

**Maturity:** Production-ready
