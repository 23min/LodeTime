# 2026-02-01 — LodeTime Architecture Notes

## Context

LodeTime is a long‑running BEAM runtime that maintains an internal model of components, dependencies, and contracts by watching the filesystem (directly or via a watcher that notifies the runtime). In normal use it watches **some other project**; in this repo it watches **itself** (dogfooding), which creates extra mental overhead.

At this stage the architecture is still a rough draft: components were sketched from a short AI conversation and captured in `.lodetime/`, with narrative in `docs/design/` and `docs/discussion/`. The goal now is to firm up the overall system architecture enough to define components and how they *can* talk to each other (not necessarily how they *must*), while leaving room for experimentation and design iteration.

## High‑level goals

- Make architecture and intent **live** and queryable during development.
- Provide useful feedback loops (status, drift, tests, docs) without being intrusive.
- Deliver tangible capability at each phase (0–3) with clear usage and validation steps.

## TODO — Topics to discuss (long form)

1) **Phase 0 (manual mode)**  
   - Exact deliverables (what “done” looks like)  
   - Minimum `.lodetime/` schema completeness **(resolved)**  
   - How humans/AI should use it without runtime **(resolved)**

2) **Phase 2 (watcher + validation protocol)**  
   - Which signals trigger checks? **(resolved)**  
   - What checks run at checkpoint vs full? **(resolved)**  
   - How does LodeTime avoid spam (severity levels)? **(resolved)**

3) **Phase 3 (MCP + advanced workflows)**  
   - What MCP tools are actually exposed?  
   - How “tell” works vs “ask”. **(resolved)**

4) **Runtime state & durability**  
   - What “durable queue” means in practice. **(resolved)**  
   - Where logs/metrics live and how they’re retained. **(resolved — metrics deferred)**

5) **User workflows (day‑to‑day)**  
   - “How do I use this as a developer?” **(resolved)**  
   - “How do I use this as an architect?” **(resolved)**  
   - “How does AI benefit from LodeTime in practice?” **(resolved)**

6) **Contracts & schemas**  
   - What belongs in `.lodetime/contracts` vs `.lodetime/components`. **(resolved — partial)**  
   - How strictly contracts are enforced. **(resolved)**

7) **Observability**  
   - What metrics/logs exist in each phase. **(resolved — deferred)**  
   - What the minimal “status” output contains. **(resolved)**

## System boundaries (current framing)

**Is**
- A long‑running runtime that reads architecture specs, tracks project state, and provides status/actions.
- Two‑way communication: humans/AI can *Ask* (query) and *Tell* (write), while the system *Watches* and reacts to change.

**Isn’t (yet)**
- Fully autonomous code generation or refactoring.
- A replacement for CI/CD or all project tooling.
- A system that silently mutates code without explicit intent.

## Watch → Interpret → Act (draft pipeline)

**Signals**
- File change events (code/spec/docs)
- Explicit commands from CLI
- Git diff (optional later)
- Graph changes (architecture dependency/contract graph updated)

**Interpretation**
- Which components/contracts are impacted?
- Does this violate a schema or contract?
- Does this imply a documentation update?

**Actions (examples)**
- Trigger tests (targeted or full)
- Surface warnings about doc drift or contract mismatch
- Update status/health summary
- Suggest next steps (not auto‑commit)

Note: Graph changes should be treated as a first‑class signal. The system may not know whether the change is intentional; the default behavior could be to inform or warn rather than block.

## Validation protocol (avoid “over‑the‑shoulder” noise)

LodeTime should avoid interrupting the AI while it is mid‑edit. Suggested model:

- **Work session / checkpoint protocol**:
  - AI (or user) signals: `begin-work` → LodeTime shifts to *observe‑only* (collects signals, no warnings).
  - AI signals: `checkpoint` → LodeTime runs validations (tests/lint/contract checks) on the current snapshot.
  - AI signals: `end-work` → LodeTime runs full validation and reports results.

- **Quiescence window** (fallback when no explicit signal):
  - If no changes for N seconds, treat as a safe checkpoint and run validations.

This allows AI to complete a “train of thought” before LodeTime starts commenting. Warnings/errors are buffered until a checkpoint.

## Architecture linting (concept)

Yes, this is a real concept. Call it **architecture conformance checks** or **architecture linting**:
- Validate that dependencies obey allowed directions.
- Validate that contracts referenced by a component exist and are compatible.
- Validate that declared components are implemented (or explicitly stubbed).
- Validate that runtime topology still matches `.lodetime/`.

In practice, these checks run as part of the validation protocol above.

## Runtime environment constraints (draft)

Static architecture correctness is not sufficient: runtime environments add constraints that can invalidate an otherwise “correct” design. Examples include:
- Network boundaries (ports, DNS, service discovery, segmentation)
- Resource limits (CPU, memory, file descriptors, disk/IO)
- OS/runtime capabilities (filesystem access, sockets, clock, permissions)
- Dependency availability (DB/queue endpoints, credentials, secrets)
- Distributed topology (single node vs cluster, latency, consistency)

**Idea:** model these as **runtime constraints** or **environment profiles**, distinct from component/contract specs. LodeTime can then perform:
1) **Static compatibility checks** (architecture vs environment spec)
2) **Startup checks** (probe runtime, fail fast with clear guidance)
3) **Continuous checks** (telemetry/health validation in Phase 2+)

Open question: where should these live (e.g., `.lodetime/environments/`), and how strict should enforcement be (warn vs block)?

## Ambition: runtime vs environment (draft guidance)

Running the full system under test may be impractical (too large, too distributed, or dependent on external services). We should **not** assume LodeTime can run the full SUT/SUD locally in early phases.

Suggested approach (KISS‑first, layered ambition):

**Level 0 — Documented environment assumptions**
- Capture required services, ports, secrets, and constraints in an environment profile.
- Treat this as *source of truth* for compatibility (not inferred).

**Level 1 — Static compatibility checks**
- Parse config/IaC/CI files to build an **inventory** of runtime requirements.
- Compare inventory vs environment profile; warn on mismatches.
- Do **not** attempt to run the full system.

**Level 2 — Lightweight probes (Phase 2+)**
- Optional health checks against declared dependencies (if reachable).
- Validate that required endpoints/ports are reachable *when explicitly requested*.

**Level 3 — Runtime simulation / AI interpretation (future)**
- Only if needed: consult AI to interpret ambiguous config or deployment intent.
- Keep this explicitly scoped to avoid autonomy drift.

Notes:
- “SUT” is the common term; “SUD” is less standard. We can refer to “target runtime” or “dev environment.”
- LodeTime should focus on **compatibility and clarity**, not full execution, until later phases.

## Architecture‑aware config/IaC validation (draft)

**Position:** LodeTime should be an *architecture‑aware config/IaC validator* (static, deterministic, high‑signal).

### 1) Configuration correctness (high value, but bounded)

LodeTime can do this *without AI* if it sticks to deterministic checks:
- Validate config file schema/types (YAML/JSON).
- Detect missing required keys when the contract explicitly declares them.
- Detect mismatched defaults (contract says “required”, config missing).

**Scope guardrail:** Only validate against **declared contracts**. No inference.  
If contracts are missing, LodeTime should **warn** and suggest documentation updates.

**Signal to AI assistant:** raise a structured warning (e.g., `CONFIG_MISSING_KEY`) that the AI can consume, but do not auto‑fix.

### 2) Deployment / IaC consistency (high value, static)

LodeTime should not “interpret” IaC semantically at first; it should:
- **Inventory** declared services/resources (Compose, K8s, Terraform, CI).
- Compare to architecture dependencies and contracts.
- Warn on missing or extra resources.

If ambiguity exists, the *default action* is to require documentation rather than guessing.

### External tools (linters / policy‑as‑code)

- **IaC linters**: can be invoked as optional “adapters” (Phase 2+).  
  Use them as *external checks* whose results LodeTime can surface, not as a hard dependency.

- **Policy‑as‑code**: if present, LodeTime should detect and **report** policy locations, even if it doesn’t enforce them.

### Outcome

LodeTime provides a **map** connecting architecture → config → IaC, and flags inconsistencies.  
This keeps scope practical while still delivering unique value.

## Dev environment & distribution (draft)

LodeTime is more than a CLI binary; it is a **runtime environment**. That implies higher friction (container + resources), but also predictability and portability.

### Audience (draft)
- Primary: developers and architects working in active codebases.
- Secondary: AI assistants that operate in the same repo (needs CLI access).

### Constraints vs opportunities
- **Constraint:** requires container runtime + enough memory/CPU.
- **Opportunity:** consistent environment, deterministic behavior, fewer “works on my machine” issues.

### Installation / onboarding options

**Option A — One‑liner bootstrap (recommended)**
- `curl ... | sh` (or OS‑specific installers) sets up a lightweight wrapper + container image.
- Followed by `lode run` to start the runtime.
- Lowest friction for cross‑platform, aligns with “just works.”

**Option B — Guided setup (oh‑my‑zsh style)**
- Interactive Q&A to configure paths, ports, features.
- Better for first‑time setup; slightly more work to maintain.

**Option C — VS Code extension**
- Useful for IDE integration but excludes other editors.
- Good *later* as a convenience layer, not as the primary distribution.

### Recommendation (for now)
- Start with **Option A** (one‑liner + `lode run`).
- Add **Option B** when configuration grows.
- Defer **Option C** until core runtime is stable.

Open question: should LodeTime support a **non‑container mode** for small projects, or is container‑only a firm constraint?

### Container runtime & VS Code workflows (draft)

**Container engines:** Docker is the default, but the wrapper should be able to target Podman (and possibly nerdctl/colima) via auto‑detect or config.

**Scenario A — Local host (no devcontainer)**
- `lode run` uses the detected container engine (Docker/Podman) to start the runtime container.
- `lode status` talks to loopback JSONL endpoint.

**Scenario B — VS Code devcontainer**
Two viable modes:
1) **Embedded runtime (default)**  
   - `lode run` starts the BEAM runtime *inside the devcontainer*.  
   - No extra container; lowest friction in VS Code.
2) **Sidecar runtime (compose)**  
   - Devcontainer uses docker‑compose; runtime runs as a sibling service.  
   - `lode run` attaches to the sidecar logs; CLI targets the service endpoint.

**Scenario C — AI assistant in container**
- Same as devcontainer mode; CLI uses an environment‑provided endpoint (e.g., `LODE_RUNTIME_ENDPOINT`).

**Auto‑detect order (suggested):**
1) If inside devcontainer → **embedded runtime**  
2) Else if container engine available → **container runtime**  
3) Else → clear error + install guidance

Goal: keep `lode run` consistent while letting the backend vary by environment.

### Detection & overrides (draft)

**Devcontainer detection (heuristics):**
- Environment variables: `DEVCONTAINER`, `REMOTE_CONTAINERS`, `VSCODE_REMOTE_CONTAINERS`, `CODESPACES`
- Optional: presence of `/.dockerenv` + `/workspaces` (as a weak signal)

**Container engine detection (order):**
1) Explicit config (`lode config set engine=...`)
2) `DOCKER_HOST` / `PODMAN_HOST` env vars
3) `docker` CLI available
4) `podman` CLI available
5) `nerdctl` CLI available

**Runtime endpoint overrides (order):**
1) CLI flags (`--endpoint`, `--engine`)
2) Environment variables (`LODE_RUNTIME_ENDPOINT`)
3) Project config (`.lodetime/config.yaml`)
4) User config (`~/.config/lode/config.yaml`)
5) Auto‑detect

This keeps `lode run` predictable while still allowing explicit control when needed.

## Workflow: getting started (draft)

Assumes **one runtime per repo** and container‑first default.

### 1) From zero (new repo, no LodeTime setup)
1. Install wrapper: `curl -sSL https://get.lodetime.dev | sh`
2. Initialize: `lode init` (creates `.lodetime/` skeleton + config)
3. Start runtime: `lode run`
4. Verify: `lode status`

### 2) Resume (repo already has `.lodetime/`)
1. `cd` into the repo
2. `lode run` (connects to existing runtime or starts it)
3. `lode status` (confirm graph + contracts load)

### 3) New project, LodeTime already used elsewhere
1. Install wrapper (once per machine): `curl -sSL https://get.lodetime.dev | sh`
2. In new repo: `lode init`
3. `lode run` → `lode status`

Notes:
- If running inside a devcontainer, `lode run` starts the runtime inside the container (embedded mode).
- If running on the host, `lode run` starts a per‑repo container and persists state via a volume.
- Override option: set `LODE_RUNTIME_MODE=host` inside a devcontainer to force host‑per‑repo runtime (survives devcontainer rebuilds).

## CLI: capability discovery (draft)

If external tools/adapters are configurable, the CLI should expose a way to list them.

**Naming options (geology‑friendly but clear):**
- `lode tools` (straightforward; lowest cognitive load)
- `lode inventory` (clear; hints at what’s available)
- `lode survey` (geology‑flavored; “what’s in the ground”)
- `lode assay` (geology‑flavored but less obvious)

Recommendation: **`lode tools`** for clarity, with `lode tools --json` and `lode tools --check` as future flags.

Metrics idea: surface tool usage stats (last run, duration, exit status, resource cost) so slow/heavy tools are visible. This can start as a lightweight log and mature into structured metrics later.

### Minimal tool metrics schema (draft)

Goal: start with a **small, stable** JSONL record per tool run.

```yaml
tool_run:
  run_id: string            # unique ID
  tool_id: string           # matches registry/inventory
  started_at: timestamp     # ISO 8601
  duration_ms: number
  status: ok|warn|error
  exit_code: number
  notes?: string
  resources?:               # optional, phase 2+
    cpu_ms?: number
    max_rss_mb?: number
```

Storage idea: append JSONL to a local log (e.g., `.lodetime/metrics/tools.jsonl`). Summaries can be derived later.

## Schema evolution (draft)

We should track schema changes intentionally, but keep it lightweight:

1) **Version fields**: include a `schema_version` in `.lodetime/` specs (or per file type).
2) **Change log**: maintain a short `docs/design/SCHEMA-CHANGES.md` with versioned entries.
3) **Phase notes**: when a phase introduces a breaking schema change, note it in that phase’s docs.

This is “as‑we‑go,” but **structured** enough to avoid silent drift.

## Core runtime components (draft)

Phase‑1 critical path:
- **config‑loader**: loads `.lodetime/` into runtime
- **graph‑server**: owns component dependency graph + contracts
- **cli‑socket**: runtime query/command interface
- **cli**: human entry point (e.g., `lode status`)

Phase‑2/3 extensions:
- **file‑watcher**: change events → runtime signals
- **validation runner**: check contracts/schemas/drift
- **test‑runner**: run relevant tests on change
- **notifications**: surface findings (CLI, logs, future dashboard)
- **MCP server** (Phase 3): AI integration endpoint

Open consideration: Should LodeTime ever call out to AI itself to interpret ambiguous changes? If so, this is likely Phase 3+ and should be explicitly scoped to avoid autonomy drift.

## Phase deliverables (needs explicit scope + usage)

Each phase should ship:
- **What it does** (capabilities)
- **What it does NOT do** (explicit non‑goals)
- **How to use it** (commands, examples)
- **How to validate it** (tests, expected output)

Proposed structure (to keep history but avoid process interference):
- `docs/phases/IMPLEMENTATION-PHASES.md` = overview + current phase
- `docs/phases/phase-0/README.md` (and phase‑1/2/3)
- `docs/phases/phase-0/USAGE.md`
- `docs/phases/phase-0/TESTING.md`

Suggestion: Create stubs for each phase upfront, then fill details as phases are implemented and wrapped.

## Diagram candidates (for clarity)

1) **Roles & Channels** (who talks to whom)  
2) **Validation protocol** (work session / checkpoint)  
3) **Runtime flow** (watch → interpret → act)

These can live in this discussion note or be promoted to `docs/design/` once stabilized.

### Diagram 1: Roles & Channels

```mermaid
flowchart LR
  user([User])
  ai([AI Assistant])
  ldt([LodeTime Runtime])
  repo[(Project Repo<br/>code + .lodetime + dev/ docs)]
  fs([File Watcher])
  cli[[CLI Go]]
  api[[MCP API Phase 3+]]

  user <-->|chat| ai
  user --> cli --> ldt
  ai --> cli --> ldt
  ai -. Phase 3 .-> api --> ldt

  repo --> fs --> ldt
  ldt --> repo

  ldt --> user
  ldt --> ai

  user -. edits .-> repo
  ai -. edits .-> repo
```

### Diagram 2: Validation Protocol (work session / checkpoint)

```mermaid
sequenceDiagram
  participant AI as AI Assistant
  participant LDT as LodeTime Runtime
  participant REPO as Project Repo

  AI->>LDT: begin-work
  Note over LDT: observe-only, buffer signals

  AI->>REPO: edit files (batch)
  LDT-->>LDT: collect signals (no warnings)

  AI->>LDT: checkpoint
  LDT->>REPO: run validations (tests + arch/contract checks)
  LDT-->>AI: report findings (info/warn/block)

  AI->>REPO: continue edits

  AI->>LDT: end-work
  LDT->>REPO: full validation
  LDT-->>AI: final report
```

### Diagram 3: Runtime Flow (watch → interpret → act)

```mermaid
flowchart LR
  watch[Watch<br/>file changes, graph updates, CLI]
  interpret[Interpret<br/>map to components/contracts]
  decide[Decide<br/>info, warn, block]
  act[Act<br/>test, validate, notify]
  buffer[Buffer signals<br/>until checkpoint]

  watch --> interpret --> decide --> act
  decide --> buffer
  buffer --> act
```

Epics/milestones remain in `dev/` and are not tied 1:1 to phases.

## Open questions for next discussion

1. What is the **minimal “status” payload** in Phase 1?
2. What are **allowed actions** on file change in Phase 2?
3. Which **contract violations** should be enforced vs reported?
4. Where should “phase usage” docs live (phase folders vs a single evolving doc)?
5. Which parts of `.lodetime/` are authoritative vs derived?

---

## Phase 1 decisions (draft)

- **Minimal runtime split:** config‑loader reads/validates `.lodetime/`, graph‑server builds graph + contract map for queries.
- **Failure handling:** input errors keep runtime up in *degraded* mode with a clear error summary and “last known good graph” timestamp; internal crashes are treated as bugs with clear reporting.
- **Run mode:** Phase 1 uses **foreground** `lode run` only (no daemon/stop/restart yet).
- **Persistence:** Phase 1 rebuilds from disk; durable queues/journals/snapshots are deferred to Phase 2+.
- **Commands (Phase 1):** `lode run`, `lode status`, and a minimal `lode check` stub (non‑blocking, informational).
- **`lode doctor` (future):** optional diagnostic command (environment sanity checks, config health, runtime subsystem status). Not required in Phase 1.
- **CLI protocol:** pluggable transports; default **TCP loopback + JSONL** framing (good for logging/event streams). Future adapters: UDS, stdio.

Notes:
- “Daemon mode” = running in the background (service), not attached to a terminal. We’ll add it only if needed later.
- **Gap:** if any CLI is currently named `lodetime`, it should be renamed to **`lode`**.

### Component spec impact (current)

Reviewed `.lodetime/components` at this stage:
- **config-loader** and **graph-server** responsibilities match the Phase‑1 split (load/validate → build graph).
- **cli-socket** is currently described as TCP; if we change transport semantics later, we should revisit this spec.

No component spec changes required yet; track future adjustments via `component-refine` as decisions solidify.

### Contract spec impact (current)

Reviewed `.lodetime/contracts` at this stage:
- **graph-api** aligns with Phase‑1 queries; `update_status` is a mutation we may defer until Phase 2+.
- **cli-protocol** updated to be pluggable: default TCP loopback with JSONL framing; future UDS/stdio adapters allowed.
- **mcp-tools** is Phase 3+ and can remain as‑is for now.

No contract spec changes required yet; note the potential deferrals above.

## Next steps

- Review this draft and adjust terminology/structure.
- Decide the Phase documentation structure.
- Confirm the minimal runtime interface for Phase 1.

## Phase 2 (watcher + validation) — Q&A notes (draft)

**Signals & triggers**
- Watch **code + docs + `.lodetime/`**; level of functionality may vary by Phase‑2 scope.
- Graph changes trigger checks **only at checkpoint** (avoid race conditions).
- CLI: `status` = read‑only; `check` = validation.
- Ignore paths should be **configurable at runtime** (e.g., `lode config ignore-path <path>`).

**Validation protocol**
- Default: run **full validation** at checkpoint; allow modes for partial vs full when needed.
- End‑work: same as checkpoint, with full suite by default.
- Slow tests may run **async** and report later.
- Manual checkpoints allowed without begin‑work? **(open)**

**Checkpoint (draft definition)**
- A checkpoint is an **explicit boundary** where the developer/AI asks LodeTime to validate a stable state.
- Triggered by `lode check` or `lode checkpoint` (name TBD). It can also be **auto** after an idle window, but Phase 2 likely prefers explicit checkpoints to avoid noise.
- `lode check` should execute **as soon as possible** (high‑priority command; not queued behind long background work).
- Steps:
  1. Enter checkpoint mode (accepting new signals but deferring validation).
  2. Wait for **quiescence** (no file events for N seconds).
  3. Drain the signal queue, compute graph diff.
  4. Run validation (fast checks + configured tests; slow tests can be async).
  5. Emit report, clear "dirty" flags.

**Scenarios to decide (Y/N)**
1. Edit README only -> no tests, docs-only validation. **Yes**
2. Change `.lodetime/contracts/*` -> run full validation (graph + contracts). **Yes**
3. Change `.lodetime/components/*` -> run full validation. **Yes**
4. Change non-executable docs -> no tests; log-only. **Yes**
5. Large rename/move across components -> warn at checkpoint, run full validation. **Yes**
6. Change in a leaf component -> targeted tests only (if configured). **Yes**
7. Change in a core component -> full tests. **Yes**
8. Failing test already snoozed -> do not re-emit until end-work. **Yes**
9. Graph change detected -> always run full validation. **Yes**

**Severity & spam control**
- Live warnings for **critical issues**, but allow **snooze until checkpoint**.
- De‑duplicate repeated warnings.

**Test strategy**
- Targeted tests should be guided by milestone/epic context (passed at begin‑work or milestone start).
- Allow “ignore failing test until end‑work” (snooze) during active iteration.
- Auto‑run checks should be default.

**State & durability**
- Persist **last known graph** in Phase 2.
- Durable queue / feedback persistence should be included in **Phase 2**.
- On dirty restart: re‑run full checks; re‑surface prior warnings.
- Clarify relationship between “durable event log” vs “durable queue.”

**Durability (clarify terms)**
- **Durable event log**: append-only record of signals and validation results (audit/replay).
- **Durable queue**: persisted backlog of pending signals to process after restart (no loss/dup).
- Phase 2 should include **queue persistence**; event log can start as a minimal checkpoint summary.

**Notifications & UX**
- Output to **log file** and **CLI**.
- JSON reports **opt‑in** (config or `--json`), written to project root and gitignored.
  - filename: `lode-report.json`
  - config key: `reports.json=true`
- Notify AI if possible (mechanism TBD).

**`lode status` (draft expectations)**
- High‑level system state: **running / degraded / stopped**.
- Current mode: **idle / begin‑work / checkpoint / end‑work**.
- Queue snapshot: **pending signal count**, **oldest age**, **last checkpoint time**.
- Graph info: **last known graph hash**, **last change timestamp**.
- Recent results: **last check outcome** (pass/warn/fail) and count of open warnings.
- Config summary: active profile, watched paths, ignore rules (counts only).
- Active tools: list of enabled tool adapters (names + last run timestamp).
- Runtime: LodeTime runtime **version**.
- Errors: last error(s) per supervisor/process (count + last timestamp).

**Quiescence (clarify)**
- “Quiescence” means **no file‑system events** for N seconds in watched paths (code, docs, `.lodetime/`), plus no pending internal signals in the queue.
- It does **not** require network silence or stopping external tools; it only gates on LodeTime’s own input signals.

## Phase 3 (MCP + advanced workflows) — Questions (draft)

1) **MCP surface area**  
   - Which MCP tools should exist in Phase 3 (list concrete tool names + intent)?  
   - Which ones are read‑only vs mutate?

2) **Ask vs Tell**  
   - What does “tell” actually allow (write contracts, update components, write docs, run tests)?  
   - Should “tell” be allowed to edit files directly, or only emit patches for approval?

3) **Safety / approvals**  
   - For any mutating tool, what confirmations are required (user prompt? policy file?)  
   - Should LodeTime enforce a “no writes without user approval” gate?

4) **Tool discovery & schema**  
   - Should MCP include a “capabilities” tool (same as `lode tools`), or is CLI the source of truth?  
   - How strict should tool schema versioning be?

5) **AI integration**  
   - Can LodeTime request AI help (LLM‑in‑the‑loop) in Phase 3, or is that deferred?  
   - If allowed, what can it ask (summaries only, or reasoning, or suggestions)?

6) **Notifications**  
   - How should MCP deliver findings (streaming, batched, severity‑filtered)?

7) **Permissions**  
   - Should MCP have per‑repo permissions or profiles (e.g., readonly vs editor)?  
   - Where should this be configured?

8) **Failure modes**  
   - If MCP is unavailable, what should CLI do? Degrade gracefully?

## Phase 3 (MCP + advanced workflows) — Q&A notes (Phase‑1/2‑bound)

**Safety / approvals**
- “No writes without approval” should mean **explicit user confirmation** before any MCP tool mutates repo files (including `.lodetime/`).
- Exact UX (prompt vs policy file) is **TBD**, but the gate should be enforced.

**Tool discovery & schema**
- Align MCP capability discovery with **`lode tools`** (single source of truth).
- Schema versioning strictness is **TBD** (will revisit once Phase‑2 protocols settle).

**Failure modes**
- If MCP is unavailable, CLI should **degrade gracefully** and surface clear feedback.
- Specific UX to be refined after Phase‑1/2 experience.

**Notifications**
- MCP notification semantics must match Phase‑2 **severity + snooze** model (details TBD).

**Ask vs Tell (partial)**
- LodeTime should **not** change code directly.
- “Tell” should be limited to **updating `.lodetime/`** (contracts/components/config).
- This introduces implementation debt (needs explicit workflow and tooling).

**Proposed Tell workflow (draft)**
- `lode tell <intent>` produces a **preview/patch** against `.lodetime/`.
- User approves (interactive or policy‑gated), then LodeTime applies it.
- Applied changes are recorded in the event log for traceability.

## Runtime state & durability — Q&A notes (draft)

**State location (decision)**
**Decision:** Runtime state should **not** be committed to the repo.  
Preferred options:
  - `.lodetime/state/` but **gitignored** (simple, repo‑local).
  - Host state dir (e.g., `~/.lodetime/state/<repo-id>`), mounted into the container (better for multi‑repo + persistence).
Defaults:
  - Start with `.lodetime/state/` + gitignore.
  - Add override `LODE_STATE_DIR` later.
Container persistence should rely on **named volumes or bind mounts**.
This separation applies across `.lodetime/`: **specs/config are tracked**, runtime **state is not**.

**Queue format**
- JSONL is fine for Phase 2.

**What gets persisted (open)**
- Queue should persist **signals + control commands**.
- Validation results and warnings may need **compaction** (open findings list + last check summary), not a full history.
- Consumers: CLI, MCP/AI, log file, JSON report.

**Retention (decision)**
**Decision:** Queue entries are removed once processed at checkpoint.
History/provenance is **deferred**; logs/debug data should be rotated (e.g., 7 days or N entries).

**Restart semantics (leaning)**
**Decision:** Rehydrate backlog first; accept new signals immediately into a buffer and append to disk.
`lode check` commands should preempt background work.

**Deduplication (leaning)**
- Persist **file‑changed signals** (path + type) and coalesce per path/component.
- Diffs can be computed at checkpoint if needed; no need to persist diffs in Phase 2.

**Inspection**
- Provide queue info in `lode status --verbose`, plus `lode queue` as a quick queue‑only view.

**Concrete defaults (proposal)**
- **State dir:** `.lodetime/state/` (gitignored) by default; allow override via `LODE_STATE_DIR`.
- **Retention:** logs/debug JSONL rotated by **7 days** or **N entries** (configurable).
- **Open findings:** current warnings/errors that are **unresolved** since last checkpoint; include severity, component, and first‑seen timestamp (not full history).

## User workflows (day‑to‑day) — Q&A notes (draft)

**Developer workflow**
- Day‑to‑day usage is **unknown** until we gain real experience.
- `lode check` should be run **when the developer wants validation** (manual intent).
- “Snooze” should act like **do‑not‑disturb**: defer warnings to checkpoint or end‑work.

**Architect workflow**
- Workflow details are **unknown**; will be discovered via use.
- Most valuable outputs are anything that can cause problems if ignored: **drift, dependency risks, contract coverage**.

**AI assistant workflow**
- AI should use whatever features exist in the current phase; usage depends on CLI vs MCP availability.
- AI should be able to ask **“what can I do here?”** / **“what functionality is available?”** of CLI/MCP.
- Minimal context response is **TBD**.

**Outputs**
- Logs can be more technical (timestamps, debug); CLI should be **user/AI‑oriented** with content tailored to consumer.
- A daily/weekly summary report sounds useful.

**Failure / edge cases**
- Repeated failures likely require **escalation** (create a backlog “gap” item).

**Proposed defaults (accepted)**
- **Minimal AI context response**: component name + status, deps/dependents, relevant contracts + schema versions, warnings/errors, primary file paths, suggested tests (if known).
- **Developer rhythm**: run `lode check` after a meaningful chunk (feature slice/bug fix/before commit); use `lode status` when idle or after errors; snooze scoped to current work session and auto‑cleared at end‑work.
- **Architect rhythm**: weekly `lode check --full`, review drift/coverage; use `lode status --verbose` and `lode tools` to assess readiness/tool health.

## Contracts & schemas — Q&A notes (draft)

**Boundary (partial)**
- Contract = **defined input/output between components** (general interpretation).
- Contracts can be **public or internal** (internal class/library interfaces still count).
- File paths: **unclear** whether they belong in contracts.
Contract types to include:
- **API contracts** (request/response shapes, endpoints)
- **Data contracts** (schemas, DB tables, events/messages)
- **Behavioral contracts** (idempotency, retries, ordering)
- **Runtime guarantees** (latency/throughput, availability; later if needed)
Goal: guide AI, discover drift, keep intent explicit.

**Enforcement levels (decision)**
**Decision:** Severities = **info / warn / error / block**.
  - **Info**: FYI only.  
  - **Warn**: visible, does not fail checks.  
  - **Error**: fails `lode check`, but does not stop work.  
  - **Block**: refuses “tell” updates and marks status **degraded** until resolved.
Need an **emergency recovery** path (last resort): clear queues, reload state, and re‑run full checks.

**Versioning (open)**
- Possibly **one contract per file**, making file‑level `schema_version` sufficient.

**Evolution (open)**
- Breaking changes should use **deprecated / replaced_by / migration notes**.
- Consider provenance fields (why/when/by‑who) if useful.

**Ownership (partial)**
- Anyone can edit contracts, but we must avoid LodeTime writing over concurrent human changes.
- Need a clear **update cycle** to avoid race conditions.

**Race‑condition avoidance (decision)**
- Prefer a **lock file** (`.lodetime/.lock`) during “tell” updates (simple to implement).
- Version guard is possible but may need retries/merges.
- Patch‑only approach is not preferred.

**Emergency recovery**
- Command name: `lode reset`.
- Should be **two‑phase/confirmed** (explicit Y/N after showing implications) due to destructive nature.

## Observability — Q&A notes (draft)

- Defer detailed metrics design until volume/needs are known.
- Use **JSONL** for logs initially.
- Keep metrics **internal** (no external exposure yet).
- Alerting: **CLI + log** only for now.
- No UI/dashboard until needed.
- Stick to `lode status` as the primary surface; `lode status --verbose` includes queue info, and `lode queue` is an optional quick view.

**Validation (partial)**
- Yes to existence, compatibility, dependency direction.
- Coverage meaning TBD.

**Location (partial)**
- Prefer keeping contracts **centralized** (avoid scattering); path overrides optional but not preferred.

## Phase 0 (manual mode) — Q&A notes (draft)

**Why `.lodetime/`? (decision recorded)**  
We considered other names for visibility, but decided to standardize on **`.lodetime/`** as the authoritative, machine‑readable input.  
`docs/` remains narrative/design only. Subdirectories under `.lodetime/` are sufficient for structure.  
Alternatives (e.g., `lodetime/`, `specs/`, `schemas/`) are out of scope for now.

### 1) “Done” criteria (to be finalized)
- Phase 0 is complete when the **minimum `.lodetime/` schema** is present and consistent enough for humans/AI to use in planning and implementation.
- Concrete deliverables should be agreed once requirements are clarified (see below).

### 2) Minimum `.lodetime/` completeness
- Required: `.lodetime/config.yaml`, `.lodetime/components/*.yaml`, `.lodetime/contracts/*.yaml`.
- Placeholders are allowed **if** they are tracked and not orphaned.
  - Each placeholder must include status/owner/reason/next‑action fields (exact schema TBD).
  - Blockers should be explicit (what’s missing, who decides, and when).

### 3) How humans/AI use Phase 0 (no runtime)
Options to compare for friction vs rigor:
- **Direct read**: AI reads `.lodetime/` + `docs/design/` and uses it for planning/implementation.
- **Lightweight validation script**: a simple checker validates schema + cross‑references (e.g., missing contracts, orphan components).
- **Manual checklist**: minimal checklist for architects/documenters to confirm consistency.

Goal: maximize **automation with minimal manual steps**.

### 4) Validation in Phase 0
- Prefer automated checks; any scripts should be clearly labeled as Phase‑0‑only or evolve with later phases.
- If Phase‑0 scripts are deprecated, archive rather than delete (history is useful).

### 5) Scope boundaries (explicit NOTs)
Draft “NOT included” list to confirm:
- No long‑running runtime
- No file watching
- No automatic validation on change
- No MCP/API
- No background processes or daemons
- No automated documentation updates (human/AI only)

These “NOTs” are **Phase‑0 boundaries** to prevent scope creep. Yes—this helps humans and AI avoid building Phase‑1+ features too early.
