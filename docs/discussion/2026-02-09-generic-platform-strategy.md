# Generic Platform Strategy: LodeTime Core + Domain Packs

> What if the platform was generic and the first domain pack was software engineering?

**Context:** After analyzing how LodeTime's architecture maps to the SDD movement's drift problem, we realized the system's "shape" is not specific to software development. It's a generic pattern for intent-reality alignment in any domain where things drift.

---

## The Abstract Shape

Strip away the software-development language and LodeTime is:

> A resilient, always-running observer that maintains a graph of entities with lifecycle states (including things that don't exist yet), validates reality against declared intent continuously, detects when reality drifts from intent, computes blast radius of changes, and exposes all of this to AI and humans through structured protocols.

That pattern applies anywhere intent is declared and reality drifts from it.

---

## What's Already Domain-Agnostic (The Engine)

These components don't know or care that they're serving software development:

- **Graph.Server** — holds entities and relationships in ETS
- **Config.Server** — loads YAML definitions
- **State.Server** — runtime health tracking (green/yellow/red)
- **Watcher.Supervisor** — observes event sources (file changes are just one type)
- **Runner.Supervisor** — executes validation
- **Interface.Supervisor** — CLI socket, MCP, WebSocket, A2UI
- **Checkpoint protocol** — begin-work → observe → validate → report
- **Severity model** — info → warn → error → block
- **Lifecycle state machine** — planned → implementing → implemented → deprecated
- **Drift detection** — two-layer (definition staleness + implementation divergence)
- **Zone system** — heterogeneous governance across regions
- **Impact analysis** — transitive dependency traversal

## What's Domain-Specific (The Software Engineering Pack)

Only these pieces are tied to the software development use case:

- The word "component" (generic: entity)
- `location: lib/lodetime/graph/` — filesystem path mapping to entities
- `depends_on` semantics tied to code imports
- `languages: [elixir, go]` in config
- `build_order` in config
- `tests` field in entity YAML
- File watcher watching source code specifically
- Smart test selection logic
- MCP tool names (`lodetime_context`, `lodetime_validate`)

**The split is clean.** The engine is ~80% of the system. The domain-specific part is the YAML schema and the interpretation logic in the watchers/validators.

---

## What "Domain Pack" Means Concretely

A domain pack is NOT a plugin system or abstraction framework. It's:

1. **Config schema** — what entity types exist, what event sources to watch, what zones apply
2. **Entity YAML** — definitions of domain-specific entities (components in software, controls in compliance, protocols in clinical, etc.)
3. **Contract YAML** — interface definitions between entities
4. **Rules YAML** — domain-specific constraints
5. **Watcher behavior** — what events to observe and how to map them to entities
6. **Validator behavior** — what rules mean in this domain

The `.lodetime/` directory IS the domain pack. Different domain, different YAML, same engine.

---

## Phase 2 Design Implications

The Phase 2 work (file watcher, validation engine, rules system) is where this choice matters. Each component has a small design decision that either locks into software-dev-only or keeps the door open:

| Phase 2 Component | Software-dev-only | Platform-ready |
|---|---|---|
| **File watcher** | Watches source files, maps to components by path | Watches *event sources* (files are one type), maps to *entities* by configurable matcher |
| **Validation engine** | Hardcodes "component has tests? contracts? circular deps?" | Evaluates *rules* defined in YAML against *entity properties* (what rules check is configurable) |
| **Rules schema** | `no-circular-deps`, `tests-required` as built-in rule types | Rules are expressions over entity properties — the software rules are just the first set |

The implementation effort difference is small. It's naming and abstraction level, not architecture:

- Use `entity` internally where you'd otherwise write `component`
- Keep the validation engine rule-driven rather than hardcoded
- Make event sources configurable rather than assuming filesystem

---

## Strategy

1. **Keep calling it LodeTime.** Keep the software-dev framing for user-facing docs, marketing, dogfooding.
2. **Use generic terms internally.** In Elixir code: `entity` not `component`, `definition` not `component.yaml`, `event_source` not `file_watcher`.
3. **Domain pack = config + schema + rules.** The `.lodetime/` directory structure defines the domain. Different directory, different domain.
4. **Software engineering is domain pack zero.** Build it, prove it, ship it. The generic platform emerges from refactoring, not from upfront abstraction.

---

## Relationship to Flowtime

If flowtime (github.com/23min/flowtime) is generic flow analysis, and LodeTime Core is generic intent-reality alignment, they're complementary engines:

- **Flowtime** analyzes how things move (flow, bottlenecks, throughput)
- **LodeTime Core** validates that what moves matches what was intended (intent, drift, compliance)

Together: "Is the system flowing well?" (flowtime) + "Is the system doing what we said it should?" (LodeTime Core).

---

## Open Questions

- Internal naming: when to make the `entity` vs `component` switch? Phase 2 start? Or keep `component` and rename later?
- Should the domain pack concept be visible in the `.lodetime/` schema (e.g., `domain: software-engineering` in config.yaml)? Or is that premature?
- Where does Flowtime integration fit in the roadmap, if at all?
- How generic should the watcher abstraction be in Phase 2? File-only is simpler; event-source-generic is more work but future-proofs.

---

**Status:** Discussion / strategic framing — not an epic or milestone yet.

**Last Updated:** 2026-02-09
