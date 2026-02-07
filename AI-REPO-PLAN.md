# AI Framework Extraction Plan

Extract `.ai/` from LodeTime into standalone repo `git@github.com:23min/ai-first-framework.git`.

**Integration method:** Git subtree
**Branch:** `chore/ai-repo`

---

## Phase 1: Prepare framework for portability

Make `.ai/` content generic — no LodeTime-specific assumptions baked in.

### 1.1 Template PROJECT_PATHS.md

`PROJECT_PATHS.md` is the only instruction file that's fully project-specific.

- Rename current file to `PROJECT_PATHS.md.example` (ships with framework as reference)
- Create `PROJECT_PATHS.md.template` with placeholder values and setup instructions
- Document in README: "Copy template and fill in your project paths on first install"
- Update skills that reference PROJECT_PATHS to handle missing file gracefully

### 1.2 Make README.md generic

`.ai/README.md` "Project Conventions" section (lines 53-77) has hardcoded paths.

- Move the current project-specific "Standard Paths" content into `PROJECT_PATHS.md.example`
- Replace with generic guidance: "See `instructions/PROJECT_PATHS.md` for your project's path configuration"
- Keep the "Overrides for This Project" placeholder — it's useful as-is
- Update "Development Lifecycle" section — it's already generic, keep it

### 1.3 Clean up project-specific references

Scan all framework files for LodeTime-specific content:

- `.ai/docs/README.md` line 70: references `.github/copilot-instructions.md` — keep (generic Copilot convention)
- `.ai/docs/README.md` line 117: "Check project's `.github/copilot-instructions.md`" — keep (generic)
- `.ai/GAPS.md` — ships as-is (framework gaps are framework-specific, not project-specific)
- `.ai/FRAMEWORK-CHANGELOG.md` — ships as-is (framework version history)

### 1.4 Validate sync scripts

`sync-to-claude.sh` and `sync-to-copilot.sh` use `${SCRIPT_DIR}/../../` to find project root.
When installed via subtree at `.ai/`, this resolves correctly. Verify:

- `${SCRIPT_DIR}` = `<project>/.ai/scripts`
- `${SCRIPT_DIR}/../../` = `<project>/`
- Output dirs: `<project>/.claude/`, `<project>/.github/`

No changes needed — paths work correctly with subtree installation.

---

## Phase 2: Create the standalone repo

### 2.1 Extract .ai/ with history

Use `git subtree split` to extract `.ai/` directory with its full git history:

```bash
# From LodeTime repo
git subtree split --prefix=.ai -b ai-framework-extract

# Clone the new repo
git clone git@github.com:23min/ai-first-framework.git
cd ai-first-framework

# Pull the extracted history
git remote add lodetime <path-to-lodetime>
git pull lodetime ai-framework-extract --allow-unrelated-histories

# Clean up
git remote remove lodetime
```

This preserves the full commit history of everything under `.ai/`.

### 2.2 Add repo-level files

These files live at the repo root (which = `.ai/` in consumer projects, but only in the standalone repo):

**LICENSE** — MIT or similar (decide before creating)

**CHANGELOG.md** — Rename/promote `FRAMEWORK-CHANGELOG.md`:
- Rename to `CHANGELOG.md` (standard location)
- Keep existing content, it's already well-structured
- Remove the old `FRAMEWORK-CHANGELOG.md` (or keep as symlink during transition)

**.gitignore** — Framework-specific ignores:
```
sessions/
```

### 2.3 Write installation README

The existing `README.md` (framework reference) stays as-is for AI agents.
Add a top section or separate `INSTALL.md` covering:

**Installation via subtree:**
```bash
# Add framework to your project
git remote add ai-framework git@github.com:23min/ai-first-framework.git
git subtree add --prefix=.ai ai-framework main --squash

# First-time setup
cp .ai/instructions/PROJECT_PATHS.md.template .ai/instructions/PROJECT_PATHS.md
# Edit PROJECT_PATHS.md with your project's paths

# Sync to your AI tools
bash .ai/scripts/sync-all.sh
```

**Pulling updates:**
```bash
git subtree pull --prefix=.ai ai-framework main --squash
bash .ai/scripts/sync-all.sh
```

**Pushing improvements back:**
```bash
git subtree push --prefix=.ai ai-framework feature/my-improvement
# Then open a PR on the framework repo
```

**Devcontainer integration (optional):**
```json
{
  "postCreateCommand": "bash .ai/scripts/sync-all.sh"
}
```

### 2.4 Tag v1.0.0

The framework is already at v1.0.0 per FRAMEWORK-CHANGELOG.md. The sync fixes we just merged would be v1.2.0:

- v1.0.0 — Initial framework (2026-01-28)
- v1.1.0 — VS Code custom agents integration (2026-02-03)
- v1.2.0 — Multi-target sync, Claude Code agents, handoff guide (2026-02-07)

Tag the current state as `v1.2.0` on the framework repo.

---

## Phase 3: Integrate back into LodeTime via subtree

### 3.1 Remove .ai/ from LodeTime

```bash
git rm -r .ai/
git commit -m "chore: remove .ai/ before subtree integration"
```

### 3.2 Add framework as subtree

```bash
git remote add ai-framework git@github.com:23min/ai-first-framework.git
git subtree add --prefix=.ai ai-framework v1.2.0 --squash
```

### 3.3 Customize for LodeTime

- Copy `PROJECT_PATHS.md.template` to `PROJECT_PATHS.md` and fill in LodeTime paths
- Run `bash .ai/scripts/sync-all.sh` to regenerate `.claude/` and `.github/` outputs
- Verify everything works: agents, skills, rules

### 3.4 Update LodeTime's devcontainer

Ensure `.devcontainer/scripts/post-create.sh` calls `bash .ai/scripts/sync-all.sh`.
This should already be the case — verify it still works after subtree integration.

---

## Phase 4: Documentation and workflow

### 4.1 Migrate GAPS.md to GitHub Issues

Create issues on `23min/ai-first-framework` for each active gap in `.ai/GAPS.md`:

1. Lack of Prescriptive Spec Templates (High)
2. Context Loading Strategy and Session State (High)
3. Missing Phase Gates (High)
4. No Formalized Development Principles (Medium)
5. No Uncertainty Markers Convention (Medium)
6. Context-Refresh Not Linked to Epic Workflows (Medium)
7. Infrequent Progress Recording (Medium)
8. Built-in @plan Subagent Not Documented (Low)
9. Milestone Spec Links in Epic README (Low)
10. Deployer Agent Conflates Release/Infrastructure (Low)
11. Informal Governance vs Constitutional Principles (Low)
12. Epic Draft vs Planned Gate (Medium)
13. Missing Framework Gap Triage Skill (Medium)
14. Gap Logging Path Ambiguity (Medium)

After migration, slim down `GAPS.md` to just the format section + pointer to GitHub Issues.

### 4.2 Document contribution workflow

Add `CONTRIBUTING.md` to the framework repo:

- How to report issues (GitHub Issues)
- How to contribute improvements (fork or subtree push + PR)
- Branch naming conventions
- Commit message format (conventional commits)
- What constitutes breaking vs non-breaking changes

### 4.3 Set up labels on GitHub

Create issue labels matching the gap categories:
- `agent-roles`, `skill`, `process`, `documentation`, `tooling`
- `priority:high`, `priority:medium`, `priority:low`

---

## Execution Order

| Step | What | Depends on |
|------|------|------------|
| 1.1 | Template PROJECT_PATHS.md | — |
| 1.2 | Make README.md generic | — |
| 1.3 | Clean up references | 1.1, 1.2 |
| 1.4 | Validate sync scripts | — |
| 2.1 | Extract with history | 1.* |
| 2.2 | Add repo-level files | 2.1 |
| 2.3 | Write install docs | 2.1 |
| 2.4 | Tag v1.2.0 | 2.2, 2.3 |
| 3.1 | Remove .ai/ from LodeTime | 2.4 |
| 3.2 | Add as subtree | 3.1 |
| 3.3 | Customize for LodeTime | 3.2 |
| 3.4 | Update devcontainer | 3.3 |
| 4.1 | Migrate GAPS to Issues | 2.4 |
| 4.2 | CONTRIBUTING.md | 2.4 |
| 4.3 | GitHub labels | 2.4 |

Phase 4 can run in parallel with Phase 3.

---

## Decisions Needed

1. **License** — MIT? Apache 2.0? Unlicensed for now?
2. **Squash on subtree add?** — `--squash` keeps LodeTime history clean but loses individual framework commits in LodeTime's log. Recommended: yes, squash.
3. **GAPS.md after migration** — Keep as local scratchpad pattern, or remove entirely?
4. **README structure** — Single README with install section at top, or separate INSTALL.md?

---

**Branch:** `chore/ai-repo`
**Created:** 2026-02-07
