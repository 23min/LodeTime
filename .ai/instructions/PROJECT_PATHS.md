# Project Paths & Overrides

Use this file to configure where roadmap and architecture artifacts live.
Skills should reference these paths instead of hardcoding locations.

## Purpose

This file enables framework portability by abstracting project-specific paths. When adapting the framework to a new project, update these paths rather than editing every skill file.

## Required Paths

- **EPIC_ROADMAP_PATH:** `ROADMAP.md` (high-level epic list + status)
- **EPIC_TECH_ROADMAP_PATH:** `work/epics/epic-roadmap.md` (detailed technical view)

## Optional Paths

- **MILESTONE_PATH:** `work/milestones/` (milestone specifications)
- **MILESTONE_TRACKING_PATH:** `work/milestones/tracking/` (milestone tracking documents)
- **MILESTONE_RELEASES_PATH:** `work/milestones/releases/` (completed milestone archives)
- **EPICS_PATH:** `work/epics/` (epic specifications and planning documentation)
- **GAPS_PATH:** `work/GAPS.md` (project-specific gaps and discovered work)
- **PROVENANCE_PATH:** `PROVENANCE.md` (ad-hoc change log)
- **CHANGELOG_PATH:** `CHANGELOG.md` (release changelog)
- **DEVELOPMENT_GUIDES_PATH:** `docs/guides/` (development guides and conventions)
- **SPECS_PATH:** `work/specs/` (reusable templates and specifications)

## Framework Paths (Do Not Override)

These paths are part of the framework structure and should not be changed:

- `.ai/agents/` - Agent definitions
- `.ai/skills/` - Skill definitions
- `.ai/instructions/` - Framework instructions
- `.ai/docs/` - Framework documentation

## Usage in Skills

Skills should reference these variables in documentation and examples:

```markdown
**Location:** MILESTONE_TRACKING_PATH/<milestone-id>-tracking.md
```

When implementing, agents should read this file to resolve the actual path, or use the documented standard paths if this file is not found.

## Notes

- All paths are relative to workspace root
- Trailing slashes included for directories
- Epic-level docs typically live under EPICS_PATH/<epic-slug>/
- Milestone specs are individual files under MILESTONE_PATH
- Tracking docs are separate from specs (tracking progress, not defining scope)
- The `work/` directory is framework-managed territory (epics, milestones, specs, releases)
- The `docs/` directory is project territory (guides, references, design explorations, architecture research)

## Future: Full Abstraction

Currently, many skills still have hardcoded `docs/` paths. Future work should:

1. Update all skills to reference PROJECT_PATHS variables
2. Create a runtime mechanism for path resolution
3. Enable skills to work in any project by just updating this file

See framework gap: "Incomplete Path Abstraction in Framework"
