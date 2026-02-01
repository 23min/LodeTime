# Competitive Landscape Analysis

> Understanding what exists, what doesn't, and where LodeTime fits

---

## The Gap Analysis

### What Exists

| Capability | Tools That Have It |
|------------|-------------------|
| Code search | Sourcegraph, GitHub |
| Dependency analysis | Structure101, NDepend |
| AI coding assistance | Aider, Cursor, Claude Code |
| Visualization | CodeCharta, Emerge |
| Code quality | SonarQube |

### What Doesn't Exist (LodeTime's Opportunity)

| Capability | Who Has It? |
|------------|-------------|
| Planned/future components | **NOBODY** |
| Human-curated intent layer | **NOBODY** |
| Continuous architecture validation | **NOBODY** |
| AI-writeable architecture | **NOBODY** |
| Development process state | **NOBODY** |
| Zone-based code treatment | **NOBODY** |
| Always-running companion | **NOBODY** |

---

## Category Analysis

### Enterprise Architecture Tools
**Tools**: Structure101, Lattix, NDepend, Sonargraph
- Expensive ($1000+/year)
- Visualization-focused
- Not continuous/real-time
- No AI integration

### Code Intelligence (Sourcegraph)
- Great for code search/navigation
- Went closed-source August 2024
- No planned components, no contracts
- No development process state

### AI Coding Tools (Aider, Cursor, Claude Code)
- Aider: Great repo maps using tree-sitter + PageRank
- All derive context from code only
- No human curation layer
- **Lesson**: Don't reinvent repo maps. Build the INTENT LAYER on top.

### IDEs & Static Analysis (LSP, linters, type checkers)
- Excellent at **syntax/semantic** feedback as you type
- Typically file‑ or project‑local, not architecture‑aware
- Overlap exists (tests/linters), but LodeTime should **complement**:
  - IDEs = fast, local feedback
  - LodeTime = system‑level intent, contracts, and drift

---

## LodeTime's Position

We're building the **missing layer** between code and AI:

```
┌─────────────────────────────────────────────┐
│           AI Coding Tools                    │
│      (Aider, Cursor, Claude Code)           │
└─────────────────────────────────────────────┘
                    ↑
         LodeTime provides context
                    ↑
┌─────────────────────────────────────────────┐
│           LodeTime (THE GAP)                │
│  • Planned components  • Development state  │
│  • Contracts/rules     • Architecture graph │
│  • Human-curated intent                     │
└─────────────────────────────────────────────┘
                    ↑
┌─────────────────────────────────────────────┐
│        Existing Code Intelligence           │
│    (tree-sitter, LSP, static analysis)      │
└─────────────────────────────────────────────┘
```
