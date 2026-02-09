# SDD-Informed Gaps: What the Design Docs Don't Capture Yet

> Concrete gaps between what the SDD/drift analysis reveals and what's currently in LodeTime's vision, design, and YAML schema. Written to inform Phase 2 and Phase 3 epic scoping.

**Source:** `docs/discussion/2026-02-09-sdd-drift-analysis.md`
**Tracked in:** `work/GAPS.md`

---

## 1. Rules Don't Exist Yet — and Anti-Debt Rules Aren't in the Concept at All

The design doc (`docs/design/04-CORE-CONCEPTS.md`) describes rules as a core concept: `no-circular-deps`, `no-legacy-imports`, zone-level rules like `tests-required`. But `.lodetime/rules/` is empty — no YAML files, no schema. The zone definitions in `config.yaml` omit the `rules` field entirely (compare with the design doc example which shows `rules: [tests-required, contracts-required]`).

More importantly, Rajesh's "Anti-Debt" concept — per-component constraints on *what patterns to forbid* — has no equivalent in the current component schema. Component YAML (e.g., `graph-server.yaml`) captures `depends_on` and `implements_contracts` but nothing about forbidden patterns or required patterns.

**Why this matters for Phase 2:** The file-watcher + validation checkpoint epic needs rules to validate *against*. Without a rules schema, `lode check` has nothing to enforce beyond structural graph consistency. A checkpoint that only confirms "yes, this component exists and its YAML is valid" is not drift detection — it's a schema linter.

**What needs to happen:** The rules schema and at least a few bootstrap rules (no-circular-deps, zone-boundary enforcement) should be a prerequisite or part of the Phase 2 epic scope. The anti-debt concept (per-component `constraints: require/forbid`) can follow, but the rules foundation must come first.

**Design doc updated:** `04-CORE-CONCEPTS.md` now includes the component-level constraints concept.

---

## 2. Contracts Are Too Shallow for Meaningful Validation

Current contract YAML (`graph-api.yaml`) lists operation names and types:

```yaml
operations:
  - {name: get_component, type: query}
  - {name: component_for_path, type: query}
```

No input/output schemas, no error types, no behavioral constraints. Compare with Rajesh's spec example which defines specific inputs (`OrderId, UserId`), specific state transitions (`PENDING → PAID`), and specific error handling requirements.

Right now, the validation engine could confirm that a component *declares* a contract, but not whether the code *satisfies* it. That's the "false confidence" risk the analysis flags — `lode check` returns green, but the contract is so vague that green is meaningless.

**Why this matters for Phase 2/3:** You don't need full Pact-style contract testing on day one, but the contract schema should at least support input/output shapes and error enumerations so the validation runner (Phase 2) has something substantive to check. If the schema doesn't support richer contracts, the validation engine will be designed around shallow checks and retrofitting depth later becomes a schema migration.

**What needs to happen:** Extend the contract YAML schema to support optional `input`, `output`, and `errors` fields per operation. Start structural (schema shapes), evolve toward behavioral (state transitions, idempotency). Make the richer fields optional — don't require full schemas on day one, and let zones/ratcheting apply.

---

## 3. YAML-Drift Detection Is the Killer Feature — But It's Not Designed

The analysis identifies LodeTime's strongest advantage over SDD tools: a running BEAM process can detect when code changes *without* corresponding `.lodetime/` updates. A static spec can't detect its own obsolescence. This is the concrete mechanism behind the claim "LodeTime catches drift while you type."

But it wasn't in the trigger/validation design. `05-TRIGGERS-NOTIFICATIONS.md` described file-change → component mapping → test selection. What was missing is the reverse: file-change → no `.lodetime/` update → staleness warning. Specific examples:

- Code in `lib/lodetime/graph/` changed significantly, but `graph-server.yaml` hasn't been touched in 30 commits → warn
- A new module appeared under a component's `location` path that doesn't match any declared dependency → warn
- A component's `depends_on` list doesn't match actual imports → error

This is the "closed-loop" that makes YAML rot detectable rather than silent. Without it, `.lodetime/` definitions are just better-organized documentation — they don't *enforce* anything about their own freshness.

**Why this matters for Phase 2:** This should be an explicit design consideration for the file-watcher epic. The watcher needs to compare code changes against `.lodetime/` state, not just map files to components for test selection. If the file-watcher is built without this reverse flow, adding it later means rearchitecting the event pipeline.

**What needs to happen:** Add YAML-drift detection as an explicit validation trigger type. Three progressive strategies: staleness heuristic (code churn without YAML update), dependency divergence (actual imports vs `depends_on`), and orphan detection (new modules with no declared relationship).

**Design doc updated:** `05-TRIGGERS-NOTIFICATIONS.md` now includes the YAML-Drift Detection section.

---

## 4. No CI Mode

The design is entirely oriented around the development-time companion. The analysis recommends `lode check --strict` as a CI pipeline step — a second enforcement layer. This is Rajesh's point about CI/CD as the guardrail, and it's complementary rather than competing.

The development-time companion catches drift while you code. A CI gate catches what you missed — or what your teammate didn't run `lode check` on before pushing.

**Why this matters for Phase 3:** This isn't urgent, but it's worth noting during epic scoping. The key architectural concern is ensuring the validation runner is callable as a one-shot process (boot, validate, report, exit) and not only as part of the long-running companion. If the validation logic is tightly coupled to the supervision tree and persistent state, extracting a CI mode later becomes a significant refactor.

**What needs to happen:** Small design consideration — ensure the validation runner can operate in both modes. The long-running companion is primary. One-shot CI mode is a bonus that falls out naturally if the validation logic is cleanly separated from the runtime lifecycle.

---

## 5. MCP Tools Don't Address the "Redundant Code Loop"

Rajesh's second failure mode — AI recreating utilities that already exist — is addressed in LodeTime's design by `lodetime_context`. But looking at the MCP tool definitions, `lodetime_context` returns component-level metadata: dependencies, contracts, warnings, status. It doesn't answer "what utility modules exist in this zone" or "what helper functions are already available for this pattern."

The graph server tracks components, not functions. An AI asking "should I write a date formatter?" gets back:

```json
{"component": "core-utils", "status": "implemented", "depends_on": [...]}
```

But not:

```json
{"existing_modules": ["MyApp.Utils.DateFormat", "MyApp.Utils.StringHelpers", ...]}
```

This is the layer between LodeTime's architecture awareness and code intelligence (Sourcegraph territory). LodeTime doesn't need to be a full code search engine, but even a lightweight `related_modules` field in the context response would close the redundant-code gap.

**Why this matters for Phase 3 MCP epic:** Without this, AI tools using LodeTime know *about* components but can't discover *what's inside* them. The redundant code loop — AI reinventing existing helpers — persists even with LodeTime running.

**What needs to happen:** Consider whether `lodetime_context` should include a `related_modules` or `available_utilities` field, or whether a separate lightweight MCP tool for codebase-level search (backed by tree-sitter or file-system indexing) is warranted. This doesn't need to be Sourcegraph — even a module-name index per component would help.

---

## Priority Summary

| # | Gap | Phase | Priority | Rationale |
|---|-----|-------|----------|-----------|
| 1 | Rules schema + bootstrap rules | 2 | **High** | Prerequisite for meaningful `lode check` |
| 3 | YAML-drift detection | 2 | **High** | The differentiator; must be in file-watcher design |
| 2 | Richer contract schema | 2-3 | **Medium** | Can start shallow, but schema must support depth |
| 5 | MCP deduplication context | 3 | **Medium** | Bridges architecture and code intelligence |
| 4 | CI one-shot mode | 3 | **Low** | Keep design composable; don't lock into long-running only |

The first two are the hard gates. Without rules, `lode check` is a structural linter. Without YAML-drift detection, the "always-running companion" claim is aspirational rather than enforced. Both belong in the Phase 2 epic definition.
