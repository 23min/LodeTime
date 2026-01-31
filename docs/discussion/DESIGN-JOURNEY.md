# Discussion & Design Journey

> Capturing the thinking process that led to LodeTime's design

---

## The Initial Question

> "I want to build something that helps with development - knowing the architecture, running tests, working with AI tools."

This led to exploring: What exists? What's missing? What would help?

---

## Key Insights

### 1. The Gap is Real
Nobody tracks planned components, human intent, or development state.

### 2. Don't Compete on Code Intelligence
Sourcegraph wins that. Build the layer above.

### 3. BEAM is Perfect for This
Always-running, resilient, concurrent, updateable.

### 4. Planned Components are the Killer Feature
AI knowing what you INTEND to build.

### 5. Simple YAML Beats Complex DSL
Accessible, git-friendly, AI-readable.

### 6. Bootstrap Proves the Concept
Using LodeTime to build LodeTime validates everything.

---

## Why "Living" Companion?

Traditional tools are dead - run, report, done.

LodeTime vision:
- Always running (not invoked)
- Watching (not just analyzing)
- Proactive (tells you when something's wrong)
- Participatory (AI can query AND update)

**Metaphor**: "Like a team member who never sleeps, knows the codebase, and is always watching."

---

## The "Planned Component" Insight

> "AI can see what code exists, but not what I'm PLANNING to build."

This is possibly the biggest differentiator.

---

## What We Explicitly Decided NOT to Build

1. Visualization tools (others do this well)
2. Code search (Sourcegraph does this)
3. Type system (too complex for v1)
4. CI/CD replacement
5. IDE plugin (MCP + CLI are enough)
6. Deep semantic analysis (use existing LSP)

---

## Personal Motivations

- Interest in workflows, graphs, process, automation, AI
- BEAM - nobody using it to augment AI workflows
- Avoiding dependency on tools that might change license
- Elixir experience refresh
- Competitive edge through BEAM's unique capabilities
