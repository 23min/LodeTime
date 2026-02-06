# Work Specs Directory

This folder contains **project specifications** for this repository. It is the canonical home for reusable, project‑specific specs such as:

- API contracts and schemas
- Data models and protocol definitions
- Cross‑cutting rules or conventions needed by multiple milestones

This directory is managed by the AI framework, but humans may edit it when needed. If you change structure or conventions, update the relevant framework instructions or skills in `.ai/` so the AI stays aligned.

**Relation to `.ai/templates/`:**
- `.ai/templates/` is **framework workflow templates** (epics, milestones, tracking, checklists).
- `work/specs/` is **project specifications** (API contracts, schemas, rules). It does not override or extend templates.

**Relation to `.lodetime/`:**
`.lodetime/` is a runtime/architecture folder and is separate from specs. When a spec becomes part of the system’s declared architecture or contracts, it should be referenced from `.lodetime/` (or linked in docs) rather than duplicated here.
