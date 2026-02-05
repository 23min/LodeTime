# Milestone Naming Convention

## Format

```
M-<epic-slug>-<milestone-number>[-optional-suffix]
```

### Components

**M-** 
- Prefix indicating this is a Milestone ID

**<epic-slug>**
- Full epic slug (e.g., `critical-flow-reporting`, `azure-deployment`, `graph-api`)
- Must match the epic slug in `work/architecture/<epic-slug>/` and `work/epics/active/<epic-slug>.md`
- Provides clear grouping and traceability

**<milestone-number>**
- Sequential number within the epic (01, 02, 03, etc.)
- Two digits with zero-padding
- Assigned during milestone-draft

**[-optional-suffix]** (optional)
- Descriptive feature name for clarity
- Lowercase with hyphens
- Examples: `-api-endpoint`, `-graph-queries`, `-authentication`

---

## Examples

### Valid IDs

```
M-critical-flow-reporting-01
M-critical-flow-reporting-02-data-extraction
M-azure-deployment-01
M-azure-deployment-02-bicep-templates
M-graph-api-01-core-traversal
M-graph-api-02-query-endpoint
M-graph-api-03
```

### Invalid IDs

```
❌ M-01.01 (no epic slug)
❌ M-CFR-01 (abbreviated slug - use full)
❌ SIM-M-01 (no prefix before M-)
❌ M-graph-api-1 (missing zero-padding)
❌ m-graph-api-01 (lowercase M)
```

---

## Rationale

**Why full epic slug?**
- Multiple epics can be in progress simultaneously
- No coordination needed between developers
- Self-documenting (clear which epic it belongs to)
- Unique without central numbering authority

**Why not sequential numbers across all epics?**
- Requires coordination (race conditions)
- Breaks with parallel development
- Loses epic context

**Why not area prefixes (API-, UI-)?**
- Still requires coordination within area
- Epic slug is more specific and clearer

---

## Assignment Process

1. During **epic-refine**: Epic slug is defined
2. During **milestone-draft**: Architect assigns next sequential number within epic
3. Milestone ID is used in:
   - Milestone spec filename: `work/milestones/M-<epic-slug>-XX.md`
   - Tracking doc: `work/milestones/tracking/M-<epic-slug>-XX-tracking.md`
   - Git branch names (optional): `feature/M-<epic-slug>-XX-description`
   - References in epic and roadmap documents

---

**Last Updated:** 2026-01-28
