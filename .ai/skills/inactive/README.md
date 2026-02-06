# Inactive Skills

This folder contains deprecated or inactive skills that are no longer part of the active framework but are preserved for historical reference.

## Why Keep Inactive Skills?

1. **Historical context** - Understand past approaches and decisions
2. **Resurrection possibility** - May become relevant again in future contexts
3. **Learning resource** - Examples of what didn't work or became obsolete

## Current Inactive Skills

### deployment.md
**Deprecated:** 2026-02-03  
**Reason:** Deployment procedures are now covered by the deployer agent and release skill. Project-specific deployment details should be documented in project documentation (e.g., `docs/infrastructure/`), not in the framework.  
**Replacement:** Use `release` skill for release ceremonies. Create project-specific deployment guides in `docs/infrastructure/` or similar.

### ui-debug.md
**Deprecated:** 2026-02-03  
**Reason:** UI debugging is highly project-specific and varies by framework/technology. Generic debugging guidance belongs in project-specific documentation.  
**Replacement:** Create project-specific debugging guides in `docs/development/`. Use `code-review` skill for systematic issue investigation.

## Adding Skills to Inactive

When deprecating a skill:

1. Move it to this folder: `git mv .ai/skills/skill-name.md .ai/skills/inactive/`
2. Update this README with deprecation info:
   - Date deprecated
   - Reason for deprecation
   - Recommended replacement or alternative approach
3. Remove references from agent definitions
4. Update framework flowchart if needed

## Resurrecting Skills

If an inactive skill becomes relevant again:

1. Review and update the skill content for current framework standards
2. Move back to active: `git mv .ai/skills/inactive/skill-name.md .ai/skills/`
3. Update this README to remove the entry
4. Add references to appropriate agent definitions
5. Update framework flowchart
