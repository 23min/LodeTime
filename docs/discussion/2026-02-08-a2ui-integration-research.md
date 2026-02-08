# 2026-02-08 — A2UI Integration Research for LodeTime

## Context

This document captures pre-architecture research into Google's A2UI (Agent-to-UI) protocol and its potential integration with LodeTime. The goal is to determine whether A2UI should be part of LodeTime's roadmap, what it would take technically, and whether the value justifies the cost.

LodeTime's current design explicitly states it is **not a visualization tool** ([01-VISION.md](../design/01-VISION.md)). This document challenges that boundary by asking: does A2UI change the calculus? If LodeTime doesn't have to *build* a UI but instead *emits structured data* that renderers visualize, is that still "being a visualization tool"?

## What is A2UI?

A2UI (Agent-to-User Interface) is a declarative UI protocol created by Google (v0.8 public preview, January 2026). Instead of agents returning text or HTML, they return structured JSON describing UI components. A client-side renderer maps those components to native widgets.

**Core message types:**
- `surfaceUpdate` — declares UI components (flat list, not nested tree)
- `dataModelUpdate` — updates application state (components bind to state via JSON Pointer paths)
- `beginRendering` — signals the renderer to construct the UI from a root component
- `deleteSurface` — removes a UI surface
- `userAction` — user interactions flow back to the agent

**Key properties:**
- Declarative JSON, not executable code (security by design)
- Flat adjacency-list component model (LLM-friendly for incremental generation)
- Transport-agnostic (works over A2A, AG-UI, SSE, WebSockets)
- Separation of UI structure from data (reactive binding via JSON Pointer)
- Streaming/incremental updates (add, modify, remove components without rebuilding)

**Standard component catalog:**
- Layout: Row, Column, List
- Display: Text, Image, Icon, Video, Divider
- Interactive: Button, TextField, CheckBox, DateTimeInput, Slider, MultipleChoice
- Container: Card, Tabs, Modal

**Extension mechanism:** Clients advertise custom component types (charts, graphs, domain-specific widgets) via `a2uiClientCapabilities`. The agent can use custom components alongside standard ones. Custom components remain part of the client's trusted catalog — no arbitrary code execution.

**Existing renderers (as of February 2026):**
- Lit (Web Components) — stable
- Angular — stable
- Flutter (GenUI SDK) — stable (mobile, desktop, web)
- React — in progress (Q1 2026 target)
- **No Elixir/Phoenix renderer exists**

### Where A2UI fits in the protocol stack

```
A2A (Agent-to-Agent)     — agent coordination
MCP (Model Context)      — agent ↔ tools
AG-UI (Agent-to-UI)      — transport/runtime channel (bidirectional)
A2UI (Agent-to-UI spec)  — declarative UI payloads
```

A2UI defines *what* UI to render. AG-UI defines *how* to transport it. MCP defines *what tools* the agent has. They are layers, not competitors. An agent could use MCP to call `lodetime_context`, receive architecture data, and respond with A2UI components that visualize that data — all flowing through AG-UI to the browser.

### A2UI vs MCP Apps

There are two competing philosophies for agent-driven UI:

| Aspect | A2UI (Google) | MCP Apps (Anthropic/OpenAI) |
|--------|---------------|-----------------------------|
| Approach | Declarative JSON → native rendering | HTML/JS served in sandboxed iframes |
| Security | No code execution, trusted catalog | Sandboxed iframe isolation |
| Native feel | Yes (maps to platform widgets) | No (embedded web content) |
| Complexity | Renderer must exist per platform | Standard browser rendering |
| Flexibility | Limited to component catalog | Full HTML/JS/CSS |
| LLM-friendliness | High (flat JSON, incremental) | Lower (must generate valid HTML) |

**For LodeTime's use case**, A2UI is the more natural fit because LodeTime's outputs are structured data (components, dependencies, contracts, health status) that map well to declared UI components. MCP Apps would be overkill — we don't need full HTML rendering for architecture status.

---

## Why LodeTime should care about A2UI

### The current gap

LodeTime's [01-VISION.md](../design/01-VISION.md) says:

> LodeTime is NOT a visualization tool. But it IS a structured data provider.

This is the right instinct, but it creates a tension: the architecture graph, component health, contract violations, and impact analysis are *inherently visual* concepts. Developers understand dependency graphs by *seeing* them. A list of text warnings is less actionable than a color-coded component map where you can click to drill down.

Today, LodeTime's planned interfaces are:
- CLI text output (`lode status`, `lode check`)
- JSON output (`--json` flag, `lode-report.json`)
- MCP tools (structured responses to AI queries)

None of these are *interactive*. None of them let a human *explore*.

### What A2UI would change

A2UI lets LodeTime remain a "structured data provider" while *also* offering rich interactive exploration — without building a custom UI. The agent (or LodeTime itself) generates A2UI JSON; any compatible renderer displays it. LodeTime doesn't build or maintain a dashboard. It emits data; the ecosystem renders it.

This reframes the vision statement:

> LodeTime is NOT a visualization tool. It IS a structured data provider — **and A2UI lets structured data providers generate interactive visualizations without becoming visualization tools.**

---

## Concrete use cases: what benefits from a UI

### 1. Architecture graph exploration (high value)

**The problem:** `lodetime_affected database-client` returns a text list of affected components. Useful, but a developer can't *see* the cascade, can't *explore* alternatives, can't *intuit* the topology.

**With A2UI:**
```
Agent generates A2UI surface:

  ┌────────────────────────────────────────────────────┐
  │  Architecture: user-service impact                 │
  │                                                    │
  │  [Graph component: Cytoscape.js custom renderer]   │
  │                                                    │
  │    ┌──────────┐      ┌───────────────┐             │
  │    │ database  │─────→│ user-service  │──→ ...      │
  │    │ -client   │      │  ● healthy    │             │
  │    │ ○ changed │      └───────────────┘             │
  │    └──────────┘              │                      │
  │         │               ┌────┴─────┐                │
  │         └──────────────→│ auth     │                │
  │                         │ -provider│                │
  │                         │ ▲ 2 warns│                │
  │                         └──────────┘                │
  │                                                    │
  │  Click any node for details                        │
  └────────────────────────────────────────────────────┘
```

User clicks `auth-provider` → agent queries `lodetime_context auth-provider` → responds with expanded detail: contracts, warnings, test status, suggested actions. Each interaction drives deeper exploration.

**Why this needs a UI:** Dependency graphs are 2D structures. Text flattens them to 1D. The topology, the clusters, the isolated nodes, the fan-out — these are spatial properties that text cannot convey.

### 2. Checkpoint reports as interactive surfaces (high value)

**The problem:** `lode check` outputs a text report with warnings and errors. The developer reads it, then manually runs commands to investigate each finding.

**With A2UI:**
```
Agent generates checkpoint surface:

  Checkpoint Report — 2026-02-08 14:32
  ┌─────────────────────────────────────────────────┐
  │ ● ERROR  Contract user-api violated             │
  │   Expected: {id, email}  Actual: {id, name}     │
  │   [View contract] [Show diff] [Suggest fix]     │
  │                                                  │
  │ ○ WARN   Orphan file: lib/notifications/sms.ex  │
  │   Not assigned to any component                  │
  │   [Assign to notification-service]               │
  │   [Create new component]                         │
  │   [Ignore]                                       │
  │                                                  │
  │ ○ WARN   Unused dependency: database-client      │
  │   Declared by user-service, no imports found     │
  │   [Remove from YAML] [Keep (mark intentional)]   │
  │                                                  │
  │ ● INFO   3 tests affected by recent changes      │
  │   [Run targeted tests] [View test list]          │
  └─────────────────────────────────────────────────┘
```

Each finding has *actionable buttons*. Clicking "Assign to notification-service" triggers `lodetime_update` with approval flow. Clicking "Show diff" triggers `lodetime_context` and renders the contract delta. The checkpoint report becomes a *workflow surface*, not just a passive report.

**Why this needs a UI:** Text reports are read-once-then-forgotten. Interactive surfaces are *worked through*. The difference between "here are 5 warnings" and "here are 5 warnings, click to fix each one" is the difference between information and workflow.

### 3. Component status dashboard (medium value)

**With A2UI:**
```
  LodeTime Status — Project: lodetime
  ┌────────────────────────────────────────────┐
  │ Runtime: running    Mode: idle             │
  │ Last checkpoint: 14:32 (2 min ago)         │
  │ Graph: 12 components, 8 contracts          │
  ├────────────────────────────────────────────┤
  │ Component          Status      Health      │
  │ config-loader      implemented ●           │
  │ graph-server       implemented ●           │
  │ cli-socket         implemented ●           │
  │ cli                implemented ●           │
  │ file-watcher       implementing ◐          │
  │ validation-runner  planned     ○           │
  │ mcp-server         planned     ○           │
  │ notification-svc   planned     ○           │
  ├────────────────────────────────────────────┤
  │ [Run checkpoint] [View graph] [Full report]│
  └────────────────────────────────────────────┘
```

Click any component → expand inline with dependencies, contracts, recent test results, warnings. Click "View graph" → switch to the graph visualization from use case 1.

### 4. Contract explorer (medium value)

Contracts are complex structured data (operations, inputs, outputs, errors, behavioral guarantees). A text dump of contract YAML is hard to parse. An interactive contract explorer that shows:
- Which components provide vs consume each contract
- Which operations are covered by tests
- Version history and deprecation notes
- Diff between declared contract and actual implementation

This is read-heavy exploration that benefits from hyperlinks, expand/collapse, and cross-referencing — all natural A2UI patterns.

### 5. Impact analysis before changes (high value)

**The scenario:** AI assistant is about to modify `user-service`. Before making changes:

```
  Impact Analysis: user-service
  ┌─────────────────────────────────────────────────┐
  │ Changing user-service will affect:              │
  │                                                  │
  │ Direct dependents (3):                           │
  │   ● auth-provider    — uses user-api contract    │
  │   ● api-gateway      — routes to user endpoints  │
  │   ● notification-svc — sends user notifications  │
  │                                                  │
  │ Contracts at risk (2):                           │
  │   user-api          — 4 operations               │
  │   user-events       — 2 event types              │
  │                                                  │
  │ Tests to run (12):                               │
  │   ● 8 unit tests (user-service)                  │
  │   ● 3 integration tests (auth-provider)          │
  │   ● 1 integration test (api-gateway)             │
  │                                                  │
  │ [Proceed with change] [Run tests first]          │
  │ [Show full dependency tree]                      │
  └─────────────────────────────────────────────────┘
```

This is the "measure twice, cut once" surface. AI and human both benefit from seeing the blast radius before acting.

### 6. Work session timeline (future value)

```
  Work Session: 2026-02-08 13:00–14:45
  ┌──────────────────────────────────────────────────┐
  │ 13:00  begin-work                                │
  │ 13:05  ✏ lib/users/registration.ex (user-service)│
  │ 13:12  ✏ lib/users/validation.ex   (user-service)│
  │ 13:20  checkpoint                                │
  │        ● 2 tests passed                          │
  │        ○ 1 warning: contract drift (user-api)    │
  │ 13:25  ✏ .lodetime/contracts/user-api.yaml       │
  │ 13:30  checkpoint                                │
  │        ● all clear                               │
  │ 14:00  ✏ lib/auth/token.ex (auth-provider)       │
  │ 14:15  checkpoint                                │
  │        ● ERROR: auth-token contract violated     │
  │ 14:30  ✏ lib/auth/token.ex (fix)                 │
  │ 14:40  end-work                                  │
  │        ● all clear, 5 tests passed               │
  └──────────────────────────────────────────────────┘
```

A scrollable timeline of the work session with expandable entries. This is provenance + observability made navigable.

### 7. AI-generated architecture proposals (future value)

When AI suggests architectural changes (new component, restructured dependencies), instead of describing changes in text, it generates an A2UI diff view:

```
  Proposed: Extract notification-service
  ┌───────────────────────────────────────────────┐
  │ BEFORE                 AFTER                  │
  │                                               │
  │ [user-service]         [user-service]          │
  │   ├→ sends email         ├→ (no email)         │
  │   ├→ sends sms           │                     │
  │   └→ logs activity       └→ emits events ──┐   │
  │                                            │   │
  │                        [notification-svc] ←┘   │
  │                          ├→ sends email        │
  │                          ├→ sends sms          │
  │                          └→ notification-api   │
  │                                               │
  │ New contract: notification-api                │
  │ New dependency: user-service → notification   │
  │                                               │
  │ [Accept proposal] [Modify] [Reject]           │
  └───────────────────────────────────────────────┘
```

This is the Tell workflow made visual. Instead of reading a YAML patch, the developer sees the architectural change graphically and can accept/reject it.

---

## The Elixir/Phoenix angle

### Why Phoenix LiveView is a natural A2UI renderer

Phoenix LiveView is Elixir's server-rendered real-time UI framework. It maintains state on the server and pushes minimal DOM diffs to the browser over WebSockets. This is architecturally aligned with A2UI in several ways:

**Shared philosophy:**
| A2UI concept | Phoenix LiveView equivalent |
|---|---|
| Declarative component model | HEEx templates with function components |
| Server manages state, client renders | LiveView's entire model |
| Incremental updates over WebSocket | LiveView's diff engine (5-10x faster than full replacement) |
| Data binding via paths | Assigns + reactive template rendering |
| User actions flow to server | `phx-click`, `phx-change`, `phx-submit` events |
| Flat component list | LiveView's component tree with `live_component` |

**Where they diverge:** A2UI is JSON-driven (the agent sends JSON, the renderer interprets it). LiveView is template-driven (Elixir code renders HTML server-side). But LiveView already has the concept of **hooks** — JavaScript lifecycle callbacks that bridge server-side events to client-side JS libraries. This is exactly the mechanism needed for custom A2UI components like graph visualizations.

### How a Phoenix-based A2UI renderer would work

```
LodeTime Runtime (BEAM)
    │
    ├─ Graph.Server (architecture state)
    ├─ State.Server (health, test results)
    │
    └─ Web.Supervisor (new)
        └─ Phoenix endpoint
            ├─ LiveView: StatusLive    → renders A2UI status surface
            ├─ LiveView: GraphLive     → renders A2UI graph surface
            ├─ LiveView: CheckpointLive → renders A2UI checkpoint surface
            └─ JS hooks:
                ├─ CytoscapeHook   → graph visualization (Cytoscape.js)
                └─ A2UIRenderer    → generic A2UI component mapping
```

**The rendering pipeline:**
1. LodeTime generates A2UI JSON (from Graph.Server state, validation results, etc.)
2. Phoenix LiveView receives the JSON and maps standard components (Text, Button, Card) to HEEx templates
3. Custom components (graph visualizations) are delegated to JavaScript hooks
4. User interactions (`userAction`) flow back through LiveView's event system to the BEAM runtime
5. The runtime processes the action (e.g., runs `lodetime_update`) and pushes updated A2UI JSON

**Why this is natural for Elixir:**
- **Same runtime:** The A2UI renderer runs in the same BEAM VM as LodeTime's Graph.Server and State.Server. No HTTP calls between services, no serialization overhead. The renderer can directly query ETS tables for component state.
- **PubSub built-in:** Phoenix.PubSub can broadcast state changes (file watched, test completed, checkpoint finished) directly to connected LiveView sessions. The UI updates in real-time without polling.
- **Process isolation:** Each connected browser session is a separate BEAM process with its own state. One user exploring the graph doesn't affect another user's checkpoint view. Crashes in the UI layer don't affect the core runtime (supervision trees).
- **Hot code reloading:** Update the renderer without restarting LodeTime. Push UI fixes while the core runtime keeps watching and validating.

### The Cytoscape.js integration pattern

For graph visualization (the highest-value use case), the established pattern in Phoenix LiveView is:

1. Define a LiveView hook (`CytoscapeHook`) that initializes Cytoscape.js on mount
2. Server pushes graph data via `push_event(socket, "graph-update", %{nodes: [...], edges: [...]})`
3. Hook receives the event and updates the Cytoscape instance
4. User clicks a node → hook sends event back via `pushEvent("node-selected", %{id: "user-service"})`
5. LiveView handles the event, queries Graph.Server, pushes updated detail data

This is a proven pattern. Multiple production Phoenix applications use it for Chart.js, D3.js, and other JS visualization libraries. Cytoscape.js would follow the same pattern.

### What this means for LodeTime's architecture

LodeTime's [03-TECHNICAL-ARCHITECTURE.md](../design/03-TECHNICAL-ARCHITECTURE.md) already includes a `WebSocket` interface under `Interface.Supervisor`. Adding a Phoenix LiveView endpoint is a natural extension of this planned interface, not a new architectural concept.

```
Interface.Supervisor
  ├─ CLI.Socket    → Go CLI (existing)
  ├─ MCP.Server    → Claude Code (Phase 3, planned)
  ├─ WebSocket     → generic (planned)
  └─ Web.Endpoint  → Phoenix LiveView + A2UI renderer (new)
```

The Web.Endpoint would be optional — LodeTime runs without it. It's an additional interface, not a dependency. If Phoenix/LiveView is too heavy, a lighter approach (see alternatives below) is possible.

---

## Technical risks and mitigations

### Risk 1: Phoenix adds significant dependency weight

**Concern:** Phoenix + LiveView + Plug + Cowboy is a substantial dependency tree for what's supposed to be a lightweight runtime.

**Mitigation options:**
- **Option A (recommended): Make it an optional Mix dependency.** `mix lodetime.web` starts the web interface; without it, LodeTime runs headless. Phoenix is only compiled if the web feature is enabled.
- **Option B: Separate OTP application.** The renderer lives in its own app (`lodetime_web`) that depends on `lodetime` core. Deployed separately or together.
- **Option C: Use Bandit + WebSock directly.** Skip Phoenix entirely, use the lighter Bandit web server with raw WebSocket handling. Lose LiveView's diff engine but keep the dependency tree minimal. Custom A2UI rendering logic in plain Elixir.

**Recommendation:** Start with Option C (Bandit + raw WebSocket) for a minimal proof of concept. Upgrade to Option A (Phoenix LiveView) if the UI needs grow beyond what raw WebSocket handling can support. The A2UI protocol is transport-agnostic, so the renderer logic stays the same either way.

### Risk 2: A2UI is v0.8, spec may change

**Concern:** Adopting a pre-1.0 protocol risks breaking changes.

**Mitigation:**
- Isolate A2UI generation behind an internal API (e.g., `LodeTime.A2UI.Renderer` module). If the spec changes, only this module needs updating.
- The core A2UI concepts (declarative components, data binding, user actions) are stable across all versions. Breaking changes are likely in component naming or message framing, not in the fundamental model.
- Worst case: if A2UI fails to gain adoption, the same data can be rendered by any other UI approach. The investment is in structured output, not in A2UI specifically.

### Risk 3: No existing Elixir A2UI renderer

**Concern:** We'd be building the first Elixir/Phoenix A2UI renderer. No reference implementation to follow.

**Mitigation:**
- The A2UI spec is simple (JSON parsing + component mapping). An MVP renderer is ~500–1000 lines of Elixir.
- The Lit renderer (open source) serves as a reference implementation for the protocol mechanics.
- **Opportunity:** Being the first Elixir A2UI renderer could attract community attention. LodeTime becomes interesting to the Elixir ecosystem not just as a dev tool but as a reference implementation for a Google-backed protocol.

### Risk 4: Scope creep — "now we're building a web app"

**Concern:** Once a web UI exists, users will want features: theming, responsive design, accessibility, authentication, multi-user, deployment...

**Mitigation:**
- **Hard boundary:** The web UI is a *renderer*, not an *application*. It renders A2UI JSON and sends user actions back. It does not have its own routes, its own state, or its own features.
- **No authentication in v1:** The web UI is localhost-only, same as the CLI socket. Authentication is a future concern.
- **Single-page:** One LiveView page, multiple surfaces (status, graph, checkpoint). No routing, no navigation beyond A2UI surface switching.
- **Write it in the design:** Declare the boundary in the component spec. "Web.Endpoint renders A2UI surfaces. It does not own state, logic, or user sessions beyond the BEAM process."

### Risk 5: Two rendering targets (CLI + Web) means maintaining two output formats

**Concern:** Every new feature needs both a text representation (CLI) and an A2UI representation (web). Double the work.

**Mitigation:**
- **Single data source:** Graph.Server and State.Server return structured Elixir data. Two thin rendering layers translate to text (CLI) and A2UI JSON (web). The business logic is shared.
- **A2UI-first approach:** Design the data structures to support A2UI (components, actions, bindings). The CLI renderer is a simpler "text projection" of the same data. A2UI is a superset of what CLI needs.
- **Incremental:** Start with CLI-only (current plan). Add A2UI for specific high-value surfaces (checkpoint report, graph view) once the data structures stabilize. Don't try to A2UI-ify everything at once.

---

## Integration approach: how to isolate and deliver

### Phase-aligned delivery

A2UI integration should **not** be its own phase. It should be layered onto existing phases as an optional interface:

| Phase | Core deliverable | A2UI addition |
|-------|-----------------|---------------|
| Phase 2 (Pupa) | File watcher + checkpoint validation | Checkpoint report as A2UI surface (PoC) |
| Phase 3 (Adult) | MCP server + validation runner | Graph exploration surface, impact analysis surface |
| Post-Phase 3 | (Future) | Full interactive dashboard, work session timeline |

### Module isolation

```
lib/lodetime/
  ├─ config/          (existing: config loader)
  ├─ graph/           (existing: graph server)
  ├─ state/           (existing: state server)
  ├─ interface/
  │   ├─ cli_socket/  (existing: CLI interface)
  │   ├─ mcp/         (Phase 3: MCP server)
  │   └─ web/         (new: A2UI web interface)
  │       ├─ endpoint.ex       (Phoenix/Bandit endpoint)
  │       ├─ a2ui_encoder.ex   (Elixir data → A2UI JSON)
  │       ├─ surfaces/
  │       │   ├─ status.ex     (status surface generator)
  │       │   ├─ checkpoint.ex (checkpoint report surface)
  │       │   └─ graph.ex      (architecture graph surface)
  │       └─ live/             (LiveView modules, if using Phoenix)
  │           ├─ status_live.ex
  │           ├─ checkpoint_live.ex
  │           └─ graph_live.ex
  └─ a2ui/            (A2UI protocol types and helpers)
      ├─ component.ex (standard component structs)
      ├─ surface.ex   (surface management)
      ├─ binding.ex   (data binding helpers)
      └─ action.ex    (user action handling)
```

The `a2ui/` directory contains pure protocol logic (no web dependencies). The `interface/web/` directory contains the renderer. Removing `interface/web/` leaves LodeTime fully functional without any web capability.

### Minimum viable A2UI integration

**What:** Checkpoint report rendered as an A2UI surface in a browser, served from LodeTime's BEAM runtime.

**Technical steps:**
1. Add `a2ui/` module with A2UI JSON generation (pure Elixir, no deps)
2. Add Bandit (lightweight web server, ~zero config) as optional dependency
3. Serve a single HTML page with the Lit A2UI renderer (Google's reference Web Components renderer)
4. On `lode check`, generate A2UI JSON for the checkpoint report
5. Push via WebSocket to the Lit renderer in the browser
6. User interactions (click "Assign to component") flow back via WebSocket → trigger `lodetime_update` with approval

**Lines of code estimate:** ~800–1200 for the A2UI encoder + WebSocket bridge. The Lit renderer is an existing Google library (no LodeTime code needed for standard components).

**Custom graph component:** Requires a Cytoscape.js Web Component wrapper (~200 lines of JS) registered as a custom A2UI component. This is the one piece of significant JS that LodeTime would need to maintain.

---

## Benefits summary

### For developers
- **See** the architecture instead of reading YAML
- **Click to fix** instead of manually editing files
- **Explore** impact before making changes
- **Review** checkpoint findings as an interactive checklist

### For AI assistants
- A2UI surfaces could be presented alongside AI conversations (via AG-UI transport)
- Impact analysis becomes visual context that AI and human share
- The "Tell" workflow (propose → approve) gets a visual approval interface

### For the LodeTime project
- Differentiator: no other dev companion tool offers agent-driven interactive architecture visualization
- Community interest: first Elixir A2UI renderer
- The protocol is backed by Google; betting on adoption trajectory
- Natural fit with Elixir's real-time strengths (LiveView, PubSub, WebSocket)

### For the "keeping YAML in sync" problem
- Checkpoint reports with "click to fix" buttons reduce maintenance friction to near-zero
- Orphan files, unused dependencies, contract drift all become one-click fixes
- The UI *is* the maintenance workflow, not a separate concern

---

## Risks summary

| Risk | Severity | Mitigation |
|------|----------|------------|
| Phoenix dependency weight | Medium | Start with Bandit; upgrade if needed |
| A2UI spec instability (v0.8) | Medium | Isolate behind internal API; core concepts are stable |
| No Elixir renderer exists | Low-Medium | Spec is simple; Lit renderer is reference; opportunity for community contribution |
| Scope creep into web app | High | Hard boundary: renderer only, no app logic, localhost only |
| Two output formats (CLI + web) | Low | Single data source, two thin projections |
| Distraction from core runtime | Medium | Phase-align delivery; don't start until Phase 2 checkpoint is working |

---

## Recommendation

**Integrate A2UI, but as a Phase 2+ optional layer, not a core dependency.**

Specific recommendations:

1. **Now (pre-Phase 2):** Design Graph.Server and State.Server data structures with A2UI rendering in mind. This means structured Elixir data with component IDs, action metadata, and severity levels — which is good practice regardless of A2UI.

2. **Phase 2 (checkpoint PoC):** After checkpoint validation works via CLI, add a minimal A2UI web surface for checkpoint reports. Use Bandit + Lit renderer. Validate that interactive checkpoint findings are genuinely more useful than text output.

3. **Phase 3 (graph + MCP):** Add the architecture graph surface with Cytoscape.js custom component. The MCP server and web interface share the same Graph.Server data, so building both in Phase 3 is efficient.

4. **Post-Phase 3:** Evaluate whether to upgrade to full Phoenix LiveView based on Phase 2/3 experience. If the web interface sees real use, the investment in LiveView's diff engine and component model is worth it. If it doesn't, Bandit + Lit is sufficient.

5. **Always optional:** `lode run` works without the web interface. `lode run --web` or `lode run --ui` enables it. No user should need a browser to use LodeTime.

---

## Open questions for architecture phase

1. **Should the A2UI encoder be a separate Hex package?** If we're building the first Elixir A2UI library, it could be useful to the broader community. But maintaining an open-source library is a commitment.

2. **Bandit vs Phoenix vs raw `:gen_tcp`?** The right answer depends on how complex the web interface becomes. Start minimal, but know the upgrade path.

3. **Custom graph component ownership:** The Cytoscape.js wrapper for A2UI is JavaScript. Who maintains it? Should it be contributed upstream to the A2UI project?

4. **Multi-user / remote access:** If LodeTime runs in a devcontainer and the developer accesses it from the host browser, does the WebSocket connection work across that boundary? (Likely yes, with port forwarding, but needs validation.)

5. **How does this interact with the "not a visualization tool" principle?** Proposed reframe: "LodeTime is not a visualization *product*. It is a structured data provider that can *emit* visualizations via standard protocols when a renderer is available."

---

## Standalone Library: ex_a2ui

A standalone Elixir A2UI library has been created at [github.com/23min/ex_a2ui](https://github.com/23min/ex_a2ui).
If LodeTime adopts A2UI, this is the intended implementation path — consumed as a Hex dependency
rather than built into LodeTime directly. This keeps A2UI concerns decoupled and reusable by
any BEAM application.

**Current state (v0.0.1):** core protocol types, encoder, decoder, builder. No WebSocket server yet.
See the ex_a2ui ROADMAP.md for the standalone development plan.

---

## References

- [A2UI official site](https://a2ui.org/)
- [A2UI GitHub (Google)](https://github.com/google/A2UI)
- [A2UI Renderer Development Guide](https://a2ui.org/guides/renderer-development/)
- [A2UI Components & Structure](https://a2ui.org/concepts/components/)
- [Google Developers Blog: Introducing A2UI](https://developers.googleblog.com/introducing-a2ui-an-open-project-for-agent-driven-interfaces/)
- [The State of Agentic UI: AG-UI, MCP-UI, and A2UI (CopilotKit)](https://www.copilotkit.ai/blog/the-state-of-agentic-ui-comparing-ag-ui-mcp-ui-and-a2ui-protocols)
- [Agent UI Standards: MCP Apps and A2UI (The New Stack)](https://thenewstack.io/agent-ui-standards-multiply-mcp-apps-and-googles-a2ui/)
- [A2A, MCP, AG-UI, A2UI Protocol Stack (Vishal Mysore)](https://medium.com/@visrow/a2a-mcp-ag-ui-a2ui-the-essential-2026-ai-agent-protocol-stack-ee0e65a672ef)
- [Agentic Knowledge Graphs with A2UI (Vishal Mysore)](https://medium.com/@visrow/agentic-knowledge-graphs-with-a2ui-why-ai-reasoning-looks-different-in-2026-8e51f3d26cec)
- [Phoenix LiveView Documentation](https://hexdocs.pm/phoenix_live_view/)
- [Phoenix LiveView JavaScript Interop](https://hexdocs.pm/phoenix_live_view/js-interop.html)
- [Bandit HTTP Server for Elixir](https://github.com/mtrudel/bandit)
