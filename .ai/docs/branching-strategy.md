# Framework Branching Strategy

**Purpose:** Define git workflow for framework evolution alongside project development

---

## Overview

The framework uses a long-lived `framework/ai-evolution` branch to isolate framework improvements from project work. This allows parallel development without blocking epic or milestone progress.

---

## Branch Structure

```
main (stable)
  ├── epic/user-authentication
  │     └── milestone/m-uauth-01
  │     └── milestone/m-uauth-02
  │
  ├── epic/infrastructure-foundation
  │     └── milestone/m-if-01
  │     └── milestone/m-if-02
  │
  └── framework/ai-evolution (long-lived)
        ├── framework/deployer-rename (feature)
        ├── framework/context-refresh (feature)
        └── framework/spec-templates (feature)
```

---

## Branch Purposes

### `main`
- Always stable and releasable
- Integration point for all tested work
- Framework changes merge here when stable

### `framework/ai-evolution`
- Long-lived branch for framework improvements
- Primary owner of `.ai/` directory
- Accepts merges from framework feature branches
- Merges to `main` when changes are stable

### `framework/<feature>` (short-lived)
- Specific framework improvements
- Branch from `framework/ai-evolution`
- Merge back to `framework/ai-evolution` when complete

### `epic/<slug>`
- Epic integration branches for project work
- Branch from `main`
- Can pull framework updates when needed

### `milestone/<id>`
- Milestone work branches
- Branch from epic or `main`
- Can pull framework updates when needed

---

## Workflows

### 1. Framework Development

**Start framework work:**
```bash
# Work on framework/ai-evolution or create feature branch
git checkout framework/ai-evolution
git checkout -b framework/deployer-rename

# Make changes to ai/ directory
# Edit agents, skills, documentation

# Commit changes
git add ai/
git commit -m "framework: rename deployer agent to releaser"

# Merge back to framework/ai-evolution
git checkout framework/ai-evolution
git merge framework/deployer-rename --no-ff
git branch -d framework/deployer-rename
```

**Push framework changes:**
```bash
git push origin framework/ai-evolution
```

### 2. Sync Framework to Main

**When framework changes are stable and tested:**
```bash
git checkout main
git merge framework/ai-evolution --no-ff -m "framework: sync AI improvements"
git push origin main
```

**When to sync:**
- ✅ Framework changes tested in real milestone work
- ✅ Documentation updated
- ✅ No breaking changes or migration path documented
- ✅ Framework gaps resolved or documented

### 3. Pull Framework into Project Branches

**Option A: Pull from framework branch (get latest)**
```bash
git checkout milestone/m-if-02
git merge framework/ai-evolution -m "merge: pull latest framework updates"
```

**Use when:**
- Need cutting-edge framework features
- Testing framework changes in milestone work
- Framework branch is stable enough

**Option B: Pull from main (get stable)**
```bash
git checkout milestone/m-if-02
git merge main -m "merge: pull stable framework from main"
```

**Use when:**
- Want only battle-tested framework changes
- Conservative approach preferred
- Main is more stable than framework branch

**Option C: Cherry-pick specific commits**
```bash
git checkout milestone/m-if-02
git cherry-pick <framework-commit-sha>
```

**Use when:**
- Need specific framework fix
- Don't want all framework changes
- Surgical update required

---

## Decision Matrix

| Scenario | Approach | Command |
|----------|----------|---------|
| Testing new framework feature in milestone | Merge from framework branch | `git merge framework/ai-evolution` |
| Want only stable framework changes | Merge from main | `git merge main` |
| Need specific framework fix | Cherry-pick | `git cherry-pick <sha>` |
| Framework has breaking changes | Wait for main sync | Continue on milestone |
| Framework ready for production | Merge to main | `git checkout main && git merge framework/ai-evolution` |

---

## Conflict Resolution

### Framework vs Project Conflicts

If framework changes conflict with project work:

1. **Framework wins for `.ai/` directory**
   - Framework branch is authoritative for these paths
   - Accept incoming changes from framework branch

2. **Project wins for project code**
   - Keep milestone implementation in `src/`, `tests/`, etc.

3. **Discuss if both changed same skill**
   - May need to reconcile behavior
   - Consider if project needs warrant skill change
   - Document in framework gap if needed

### Merge Conflict Example

```bash
git checkout milestone/m-if-02
git merge framework/ai-evolution

# Conflict in .ai/skills/milestone-start.md
# Resolution: Accept framework version (framework is authority)
git checkout --theirs .ai/skills/milestone-start.md

# Conflict in src/Api/Program.cs  
# Resolution: Keep milestone version (project code)
git checkout --ours src/Api/Program.cs

git add .
git commit -m "merge: resolved framework vs project conflicts"
```

---

## Directory Ownership

Clear ownership prevents confusion during merges:

| Directory | Primary Owner | Notes |
|-----------|---------------|-------|
| `.ai/` | framework/ai-evolution | Complete framework (code + docs) |
| `src/` | epic/milestone branches | Project implementation |
| `tests/` | epic/milestone branches | Project tests |
| `docs/` | epic/milestone branches | Project documentation |
| `.github/` | Shared | Update from either side |

---

## Example: Full Framework Update Cycle

```bash
# 1. Identify framework improvement needed
# (Discovered during milestone work on milestone/m-if-02)

# 2. Switch to framework branch
git checkout framework/ai-evolution
git pull origin framework/ai-evolution

# 3. Create feature branch
git checkout -b framework/context-refresh-epic

# 4. Make framework improvements
# - Update .ai/skills/context-refresh.md
# - Update .ai/skills/epic-refine.md
# - Update .ai/skills/epic-start.md
# - Update .ai/docs/flowchart.md
git add ai/
git commit -m "framework: add context-refresh to epic-level workflows"

# 5. Merge to framework/ai-evolution
git checkout framework/ai-evolution
git merge framework/context-refresh-epic --no-ff
git branch -d framework/context-refresh-epic
git push origin framework/ai-evolution

# 6. Test in milestone branch
git checkout milestone/m-if-02
git merge framework/ai-evolution -m "merge: test context-refresh improvements"
# ... verify it works in real milestone work ...

# 7. Sync to main (when stable)
git checkout main
git merge framework/ai-evolution --no-ff -m "framework: context-refresh for epic workflows"
git push origin main

# 8. Milestone can now pull from main
git checkout milestone/m-if-02
git merge main -m "merge: stable framework updates"
```

---

## Benefits

✅ **Isolated framework work** - Doesn't disrupt milestone progress  
✅ **Flexible integration** - Pull framework updates when needed  
✅ **Stable main branch** - Only tested framework changes in main  
✅ **Parallel development** - Epic and framework work don't block each other  
✅ **Clear ownership** - `framework/ai-evolution` owns framework directories  
✅ **Safe experimentation** - Test framework changes before wide release

---

## Push Strategy

### Framework Branch
```bash
# Push framework changes regularly
git push origin framework/ai-evolution
```

**Benefits:**
- Other developers see framework changes
- Easy merging into milestone branches
- Backup of framework work
- Collaboration on framework improvements

### Feature Branches (Optional)
```bash
# Push feature branches for collaboration
git push origin framework/deployer-rename
```

**Use when:**
- Multiple people working on framework
- Want feedback before merging
- Long-running framework work

---

## Related Documentation

- [Framework README](README.md) - Framework overview
- [Flowchart](flowchart.md) - Visual framework structure
- [Framework Gaps](../ai/GAPS.md) - Known issues and improvements
- [Branching Skill](../.ai/skills/branching.md) - General branching guidance

---

**Version:** 1.0.0  
**Last Updated:** 2026-02-03
