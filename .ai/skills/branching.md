# Skill: branching

**Maturity:** STUB - Project-specific implementation required

**Purpose:** Apply the milestone-driven branching strategy.

**Required Documentation:** 
Create `docs/development/branching-strategy.md` in your project covering:
- Main branch policy (always green, when to merge)
- Epic integration branch usage (when main only advances at epic completion)
- Milestone branch strategy (single vs multi-surface work)
- Feature branch naming conventions
- PR/merge requirements

**Generic Guidelines (adapt to your project):**
- **Epic integration branches** (`epic/<epic-slug>`): Use when main only advances at epic completion
- **Milestone branches** (`milestone/mX`): Use for multi-surface coordinated work
- **Feature branches** (`feature/<surface>-mX/<short-desc>`): Standard working branches
- **Naming examples:**
  - `feature/api-m3/auth-endpoints`
  - `feature/ui-m2/dashboard-layout`
  - `milestone/m4`
  - `epic/api-redesign`

**Use when:**
- Starting epic or milestone work
- Need to determine correct base branch

**Outputs:**
- New branch created from appropriate base
- Branch name recorded in tracking doc

**Note:** Branch strategy should align with your team's integration and release patterns.

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28
