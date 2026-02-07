# Milestone Naming Convention

## Format

```
M-<epic-slug>-<milestone-number>[-optional-suffix]
```

### Components

**M-** 
- Prefix indicating this is a Milestone ID

**<epic-slug>**
- Full epic slug (e.g., `user-authentication`, `data-pipeline`, `api-redesign`)
- Must match the epic slug in `work/epics/<epic-slug>/`
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
M-user-authentication-01
M-user-authentication-02-oauth-integration
M-data-pipeline-01
M-data-pipeline-02-schema-validation
M-api-redesign-01-core-endpoints
M-api-redesign-02-auth-middleware
M-api-redesign-03
```

### Invalid IDs

```
❌ M-01.01 (no epic slug)
❌ M-CFR-01 (abbreviated slug - use full)
❌ SIM-M-01 (no prefix before M-)
❌ M-api-redesign-1 (missing zero-padding)
❌ m-api-redesign-01 (lowercase M)
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
