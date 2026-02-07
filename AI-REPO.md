# AI Framework Extraction — Tracking

Tracking gaps and tasks for extracting `.ai/` into its own repo (`ai-first-framework`).

---

## Strategy

- **Integration method:** Git subtree (edit in-place in consumer projects, push back upstream)
- **Issue tracking:** GitHub Issues on the framework repo (replaces GAPS.md)
- **Versioning:** Semver (major = breaking contract changes, minor = new agents/skills, patch = fixes)

## Gaps

### 1. Project-specific content in `.ai/README.md`

The "Project Conventions" and "Overrides" sections contain LodeTime-specific paths.
These need to become template sections with placeholders or examples that each consumer project fills in.

### 2. `PROJECT_PATHS.md` is fully project-specific

`.ai/instructions/PROJECT_PATHS.md` maps LodeTime paths. The framework should ship a template
(e.g., `PROJECT_PATHS.md.template`) and the install process creates a project-specific copy.

### 3. Installation script needed

Need a script or documented process for:
- Adding the framework to an existing project (via subtree)
- Initial setup (copy templates, run sync scripts)
- Devcontainer integration (optional `postCreateCommand`)
- Projects without devcontainer

### 4. Sync scripts assume relative paths

`sync-to-claude.sh` and `sync-to-copilot.sh` use `${SCRIPT_DIR}/../../` to find project root.
Works with subtree (files live in `.ai/`), but should be validated.

### 5. Framework README needs repo-level content

When `.ai/` becomes the repo root, the current `.ai/README.md` becomes the repo README.
Needs: installation instructions, subtree workflow, versioning policy, contributing guide.

### 6. GAPS.md transition

Current `.ai/GAPS.md` tracks framework issues. Once the framework has its own repo,
these move to GitHub Issues. GAPS.md can remain as a local scratchpad in consumer projects
for "noticed during work, will file upstream later."

### 7. Versioning infrastructure

Need:
- `VERSION` file or equivalent
- CHANGELOG.md (promote existing FRAMEWORK-CHANGELOG.md)
- Git tags for releases
- Policy for what constitutes breaking vs. non-breaking

---

**Repo:** `ai-first-framework`
**Created:** 2026-02-07
