# Project Gaps

Discovered product/tooling gaps that should be tracked but are not fixed immediately.

---

## Active Project Gaps

### Devcontainer Post-Start CLI Binary Name Drift
**Discovered:** 2026-02-07 during Phase 1 wrap verification  
**Category:** Tooling  
**Impact:** Medium - Devcontainer post-start checks/builds old CLI binary path (`lodetime`) instead of current `lode`  
**Status:** Identified  

**Issue:**
`.devcontainer/scripts/post-start.sh` still checks/builds `/workspace/bin/lodetime`, but Phase 1 standardized the CLI binary name as `lode`.

**Recommendation:**
- Update `.devcontainer/scripts/post-start.sh` to build/check `/workspace/bin/lode`
- Align post-start status output with the `lode` binary name

**References:**
- `work/epics/completed/phase-1-lodetime-larva.md`

---

### GAP: Rules Schema Missing
**Discovered:** 2026-02-09 during SDD/drift analysis
**Category:** Architecture / Schema
**Impact:** High - `lode check` has nothing to enforce beyond structural graph consistency
**Status:** Identified
**Affects:** Phase 2 epic (validation needs rules to validate against)

**Issue:**
Design doc `04-CORE-CONCEPTS.md` defines rules as a core concept (`no-circular-deps`, `no-legacy-imports`, zone-level rules like `tests-required`), but `.lodetime/rules/` has no YAML files and no schema. Zone definitions in `config.yaml` omit the `rules` field entirely. Without a rules schema and bootstrap rules, the Phase 2 validation checkpoint has nothing substantive to check.

**Recommendation:**
- Define rules YAML schema (severity, scope, condition)
- Create bootstrap rules: `no-circular-deps`, zone-boundary enforcement
- Add `rules` field to zone definitions in `config.yaml`
- Consider per-component constraints (anti-debt rules — see below)

**References:**
- `docs/design/04-CORE-CONCEPTS.md` (lines 78-89)
- `.lodetime/config.yaml` (zones section, lines 12-24)
- `docs/discussion/2026-02-09-sdd-drift-analysis.md` (anti-debt rules section)

---

### GAP: Anti-Debt Rules / Per-Component Constraints Not in Schema
**Discovered:** 2026-02-09 during SDD/drift analysis
**Category:** Architecture / Schema
**Impact:** Medium - Component YAML captures dependencies but not forbidden patterns
**Status:** Identified
**Affects:** Phase 2+ (rules engine design)

**Issue:**
SDD literature defines "anti-debt rules" — per-component constraints on what patterns to *forbid* (e.g., "no direct try/catch in domain logic; use Result wrapper"). Current component YAML schema has `depends_on` and `implements_contracts` but no field for constraints or forbidden patterns. This gap means the validation engine can check *what a component uses* but not *how it uses it*.

**Recommendation:**
- Add optional `constraints` field to component YAML schema
- Keep it lightweight: pattern-level, not code-level (e.g., "no-direct-db-access", "must-use-result-wrapper")
- Design doc updated: `04-CORE-CONCEPTS.md` now covers this concept

**References:**
- `docs/discussion/2026-02-09-sdd-drift-analysis.md` (anti-debt rules, concrete spec shape sections)

---

### GAP: Contract Schema Too Shallow for Validation
**Discovered:** 2026-02-09 during SDD/drift analysis
**Category:** Architecture / Schema
**Impact:** Medium - Contracts list operations but not input/output shapes or error types
**Status:** Identified
**Affects:** Phase 2-3 (validation depth, MCP context richness)

**Issue:**
Current contract YAML (e.g., `graph-api.yaml`) lists operation names and types but no input/output schemas, error enumerations, or behavioral constraints. The validation engine can confirm a component *declares* a contract but not whether code *satisfies* it. This creates the "false confidence" risk identified in SDD literature.

**Recommendation:**
- Extend contract YAML schema to support optional `input`, `output`, and `errors` fields per operation
- Start structural (schema shapes), evolve toward behavioral (state transitions, idempotency)
- Don't require full schemas on day one — make them optional and let zones/ratcheting apply

**References:**
- `.lodetime/contracts/graph-api.yaml`
- `docs/discussion/2026-02-09-sdd-drift-analysis.md` (concrete spec shape, false confidence sections)

---

### GAP: YAML-Drift Detection Not Designed
**Discovered:** 2026-02-09 during SDD/drift analysis
**Category:** Architecture / Design
**Impact:** High - LodeTime's key differentiator over SDD tools is undesigned
**Status:** Identified
**Affects:** Phase 2 epic (file-watcher design)

**Issue:**
The analysis identifies LodeTime's strongest advantage: a running BEAM process can detect when code changes without corresponding `.lodetime/` updates. But this isn't in the current trigger/validation design. `05-TRIGGERS-NOTIFICATIONS.md` describes file-change → component mapping → test selection. The reverse flow (file-change → no YAML update → staleness warning) is missing. Examples: code in a component's path changed significantly but its YAML hasn't been touched in N commits; new modules appear that don't match declared dependencies; actual imports diverge from `depends_on`.

**Recommendation:**
- Add YAML-drift detection as an explicit validation trigger type in the file-watcher design
- Design doc updated: `05-TRIGGERS-NOTIFICATIONS.md` now covers this concept
- Make it a Phase 2 epic consideration, not a Phase 3 afterthought

**References:**
- `docs/design/05-TRIGGERS-NOTIFICATIONS.md`
- `docs/discussion/2026-02-09-sdd-drift-analysis.md` (two layers of drift, spec drift sections)

---

### GAP: No CI-Friendly One-Shot Mode
**Discovered:** 2026-02-09 during SDD/drift analysis
**Category:** Architecture / Interface
**Impact:** Low - Not urgent, but should inform validation runner design
**Status:** Identified
**Affects:** Phase 3 (validation runner should be callable as one-shot)

**Issue:**
Design is entirely oriented around the development-time companion. SDD literature positions CI/CD as a second enforcement layer. A `lode check --strict` as a CI pipeline step would complement the runtime model. Currently no design consideration for running the validation engine as a one-shot process.

**Recommendation:**
- Ensure validation runner is callable as one-shot (not only as part of long-running companion)
- Low priority but worth noting during Phase 2-3 design to avoid architectural lock-in to long-running mode only

**References:**
- `docs/discussion/2026-02-09-sdd-drift-analysis.md` (CI/CD as second enforcement layer)

---

### GAP: MCP Context Doesn't Address Redundant Code Loop
**Discovered:** 2026-02-09 during SDD/drift analysis
**Category:** Architecture / AI Integration
**Impact:** Medium - AI can learn about components but not about existing utilities
**Status:** Identified
**Affects:** Phase 3 (MCP tools design)

**Issue:**
SDD identifies the "redundant code loop" — AI recreating utilities that already exist. `lodetime_context` returns component-level metadata (dependencies, contracts, warnings) but not "what utility modules exist in this zone" or "what helper functions are available." The graph server tracks components, not functions. An AI asking "should I write a date formatter?" gets component context, not "there's already `MyApp.Utils.DateFormat`."

**Recommendation:**
- Consider `related_modules` or `available_utilities` field in `lodetime_context` response
- Or a lightweight codebase search MCP tool backed by tree-sitter
- This bridges architecture awareness and code intelligence without competing with Sourcegraph

**References:**
- `docs/design/06-AI-INTEGRATION.md` (MCP tools section)
- `docs/discussion/2026-02-09-sdd-drift-analysis.md` (redundant code loop, failure modes table)

---

**Last Updated:** 2026-02-09
