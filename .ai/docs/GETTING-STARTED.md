# Getting Started with AI-First Development

This guide helps you use the AI framework effectively through natural conversation with your AI assistant.

## Common Questions

### "What should I work on?" or "Help me get started"

The AI understands many variations of this question. All of these work:
- "What should I work on?"
- "Help me get started"
- "What can I do here?"
- "Where do I start?"
- "What's next?"
- "I want to implement something"
- "Help, I'm lost"
- "Show me what to do"

→ Uses `session-start` skill to present menu and route you to the right workflow

### "I'm new to this project, where do I start?"

1. Read `.ai/instructions/ALWAYS_DO.md` for critical rules
2. Check `ROADMAP.md` for active/planned work
3. Review `work/epics/active/` to see what's in progress
4. Ask: "What agents are available?" or "Show me the workflow for starting a feature"

### "I have a new feature idea, what do I do?"

**If it's part of an existing epic:**
- Ask: "Help me draft milestone X for epic Y" → Uses `milestone-draft` skill
- Or: "Let's start implementing milestone X" → Uses `milestone-start` skill

**If it's a completely new epic:**
- Ask: "Help me refine this epic idea" → Uses `epic-refine` skill
- Then: "Let's start epic X" → Uses `epic-start` skill

### "I want to implement something, which agent should I use?"

Ask: "Which agent should work on this?" and describe the task:

- **Planning architecture** → `architect` agent (strategic decisions, epic planning)
- **Implementing features** → `implementer` agent (TDD, coding, milestone execution)
- **Writing tests** → `tester` agent (test strategy, coverage, quality)
- **Writing documentation** → `documenter` agent (specs, guides, ADRs)
- **Deploying infrastructure** → `deployer` agent (CI/CD, environments)
- **Framework improvements** → `maintainer` agent (this repo/framework only, not solution code)

### "How do I fix a bug?"

For bugs discovered during development:
- Use `implementer` agent with TDD workflow
- Ask: "Let's debug this using red-green-refactor"

For production bugs:
- Ask: "Help me triage this bug" → May create a gap or milestone depending on scope

### "I found something out of scope, what do I do?"

Ask: "This is out of scope for current milestone, where do I track it?"
→ Uses `gap-triage` skill to log in `work/GAPS.md`

### "How do I review code before committing?"

Ask: "Review this code" or "Run code review on these changes"
→ Uses `code-review` skill

## Common Workflows

### Starting a New Milestone
```
You: "Let's start milestone M-epic-name-01"
AI: [Uses milestone-start skill]
- Creates tracking doc
- Sets up branch
- Plans TDD phases
- Prepares first RED test
```

### Implementing with TDD
```
You: "Continue with red-green-refactor"
AI: [Uses red-green-refactor skill]
- RED: Write failing test
- GREEN: Minimal code to pass
- REFACTOR: Improve structure
- Updates tracking doc
```

### Completing Work
```
You: "Let's wrap this milestone"
AI: [Uses milestone-wrap skill]
- Adds Release Notes section
- Updates roadmaps
- Syncs documentation
```

### Deploying Changes
```
You: "Deploy this to staging"
AI: [Uses deployment skill]
- Validates environment
- Runs deployment
- Verifies health checks
```

## Asking for Help

**Good questions:**
- "What should I do next?"
- "Which skill handles X?"
- "Show me the process for Y"
- "Review my code before committing"
- "Help me plan this implementation"

**Natural conversation works:**
- "I need to start working on the authentication feature"
- "This bug is blocking me"
- "Can you explain how epics work?"
- "What's the difference between epic-refine and milestone-draft?"

## Key Principles

1. **Just ask** - Your AI assistant knows the framework, agents, and skills
2. **Conversational** - No need to memorize commands or syntax
3. **Guardrails** - Framework prevents mistakes (never commits without approval)
4. **Iterative** - Framework improves through use (tracked in PROVENANCE.md)

## Decision Guidance

### Milestone Granularity

**Too coarse:** "Validate data pipeline" (single milestone)
- Loses tracking visibility
- Hard to measure progress
- Can't parallelize work

**Too fine:** One milestone per query/function
- Too much overhead
- Loses big picture
- Creates many small PRs

**Just right:** Logical checkpoints with measurable outcomes
- Example: "Query Refinement", "Schema Validation", "Fixture Export"
- Reasonable PR sizes
- Clear progress markers

## Key Learnings

1. **Start with planning, move to active** — `work/epics/` is for planning, `work/epics/active/` is for execution
2. **Epic integration branches protect main** — Prevents half-implemented features on main
3. **Milestones are logical checkpoints** — Not arbitrary time windows
4. **TDD from the start** — Don't skip the RED phase
5. **Documentation is part of done** — Not optional cleanup
6. **Framework enables AI handoffs** — Clear context for agent transitions

## Before vs. After Framework

### Without Framework (Ad-hoc)
```
You: "Let's build feature X"
AI:  [Creates code]
You: "Fix this error"
AI:  [Edits code]
You: "Try this approach"
AI:  [Updates code]
...
Result: Working code, but no clear handoff point
```

### With Framework (Structured)
```
You: "Start epic feature-x"
AI:  [Creates epic spec, branches, tracking]
You: "Start milestone M1"
AI:  [Creates tracking doc, defines tests]
AI:  RED - Define expected outputs
AI:  GREEN - Iterate until passing
AI:  REFACTOR - Clean up, document patterns
You: "Wrap milestone M1"
AI:  [Validates, documents, ready for PR]
...
Result: Clear progress, documented decisions, ready for next phase
```

## Need More Detail?

- **Agents:** See `.ai/agents/` for role definitions
- **Skills:** See `.ai/skills/` for workflow procedures
- **Project context:** See `docs/` for architecture, specs, and epics
- **Process documentation:** See `docs/` for human-readable guides

**Still confused?** Just ask: "How do I [what you want to do]?"
