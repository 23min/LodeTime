# PROVENANCE.md Format Guide

How to log ad-hoc work in `PROVENANCE.md`.

---

## When to Update

Update `PROVENANCE.md` for **ad-hoc work only**:
- Quick bug fixes from manual prompts
- Exploratory changes and experiments
- Documentation improvements
- Unplanned refactoring
- Any work NOT part of a formal agent task/milestone

**Do NOT update** for formal agent tasks that have their own tracker files under `work/`.

## Entry Format

Add entries at the TOP (newest first):

```markdown
### YYYY-MM-DD [HH:MM] - Brief Description
**By:** Author + AI Tool | **Commit:** `hash` (if available)

Description of changes made.

**Files:** file1.ts, file2.md
```

## Fields

- **Date:** YYYY-MM-DD, optionally with time
- **Description:** Brief summary of what changed
- **Author:** Human name + AI tool used (e.g., "yourname + Claude Code")
- **Commit:** Git hash if available (optional)
- **Files:** Key files modified
