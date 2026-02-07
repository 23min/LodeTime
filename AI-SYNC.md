# AI Framework Sync Issues

Tracking issues discovered during multi-target sync setup (.ai/ -> .github/, .claude/).
Work through these one at a time on branch `fix/ai-framework-sync`.

---

## 1. GETTING_STARTED.md has hardcoded Copilot references

**File:** `.ai/instructions/GETTING_STARTED.md`
**Impact:** Synced to `.claude/rules/` where it's auto-loaded but contains Copilot-specific language.

Examples:
- "Copilot: [Uses milestone-start skill]"
- "Just ask - Copilot knows the framework"
- "GitHub Copilot" throughout

**Options:**
- A) Rewrite generically ("The AI assistant will use...")
- B) Exclude from Claude sync (add a skip marker)
- C) Both: rewrite generically in `.ai/`, let sync handle the rest

## 2. ALWAYS_DO.md has Copilot-specific features

**File:** `.ai/instructions/ALWAYS_DO.md`
**Impact:** 218 lines auto-loaded as a Claude rule. Contains features that don't apply.

Specific lines:
- Line 58-61: References `runSubagent` tool and "VSCode Copilot" by name
- Line 162: `Co-authored-by: GitHub Copilot` (should be generic or per-target)

**Options:**
- A) Make the canonical `.ai/` version AI-agnostic
- B) Have the sync scripts strip/replace target-specific sections

## 3. Rules are too heavy for Claude Code (419 lines auto-loaded)

**Files:** All 3 instruction files synced to `.claude/rules/`
- `ALWAYS_DO.md` - 218 lines
- `GETTING_STARTED.md` - 137 lines
- `PROJECT_PATHS.md` - 64 lines

**Impact:** All 419 lines loaded into Claude's system prompt every turn, consuming context budget.

**Options:**
- A) Only sync essential files (PROJECT_PATHS.md + slim ALWAYS_DO.md)
- B) Create condensed Claude-specific rules during sync
- C) Add a marker system to control which files sync to which target

## 4. Agents not auto-discovered by Claude Code

**Directory:** `.claude/agents/`
**Impact:** Claude Code has no native `.claude/agents/` convention. Files sit there unused unless explicitly referenced.

**Options:**
- A) Don't sync agents to `.claude/` (remove from sync script)
- B) Reference agents from CLAUDE.md so they're discoverable
- C) Convert agents to Claude skills (each agent becomes a skill that sets role context)

## 5. Skills not used proactively by Claude Code

**Directory:** `.claude/skills/*/SKILL.md`
**Impact:** Skills are discoverable but Claude Code typically waits for user invocation (`/skillname`). The framework expects proactive use.

**Options:**
- A) Add a rule in `.claude/rules/` that says "use these skills proactively when..."
- B) Reference key skills from CLAUDE.md
- C) Accept that proactive use requires explicit instruction per-session

## 6. Sync script doesn't support selective targeting

**Files:** `.ai/scripts/sync-to-claude.sh`, `sync-to-copilot.sh`
**Impact:** All skills/agents/instructions sync to all targets. No way to mark a file as "copilot-only" or "skip for claude".

**Options:**
- A) Add a frontmatter marker: `# sync: copilot-only` or `# sync: all`
- B) Use a manifest file (`.ai/sync-manifest.yaml`) listing what goes where
- C) Convention-based: files in `.ai/instructions/copilot/` only sync to Copilot

---

## Resolved

- [x] copilot-instructions.md pointed to `.ai/` instead of `.github/` - Fixed
- [x] copilot-instructions.md had stale project context from another project - Fixed
- [x] ALWAYS_DO.md referenced `.github/copilot-instructions.md` - Made generic
- [x] No Claude Code sync target existed - Created sync-to-claude.sh
- [x] Single sync script couldn't support multiple targets - Split into per-target scripts
- [x] CLAUDE.md had hardcoded phase number - Points to ROADMAP.md
- [x] ROADMAP.md had no project context section - Added

---

**Branch:** `fix/ai-framework-sync`
**Created:** 2026-02-07
