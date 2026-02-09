# Triggers & Notifications

> When LodeTime acts and how it communicates

---

## The Trigger Spectrum

```
File save → Debounced → Git stage → Pre-commit → Post-commit
(noisy)    (balanced)  (intentional) (gate)      (record)
```

## Checkpoint Protocol (preferred)

LodeTime should avoid “over‑the‑shoulder” noise. Instead:
- `begin-work` → observe only (collect signals)
- `checkpoint` (`lode check`) → validate current snapshot
- `end-work` → full validation + report

Fallback: if no explicit checkpoint, a **quiescence window** (no file events for N seconds) can trigger a checkpoint.

## Severity + Snooze

- **info** → FYI only  
- **warn** → visible, does not fail checks  
- **error** → fails `lode check`  
- **block** → prevents “tell” updates; status degraded until resolved  

Snooze should act like **do‑not‑disturb**: defer warnings until checkpoint or end‑work, with critical issues optionally surfaced immediately.

---

## Configuration

```yaml
triggers:
  file_system:
    enabled: true
    debounce_ms: 2000
    ignore: ["_build/**", "deps/**"]
    
  git:
    on_stage: true
    on_commit: true
    pre_commit_hook: false
```

---

## YAML-Drift Detection

The file watcher doesn't just map code changes to tests — it also detects when code changes **without** corresponding `.lodetime/` updates. This is the reverse validation flow:

```
File changed: lib/users/registration.ex
         ↓
Component: user-service (last YAML update: 12 commits ago)
         ↓
Drift signals:
  - New module appeared not matching declared dependencies
  - Actual imports diverge from depends_on
  - Significant code churn but YAML untouched
         ↓
Severity: warn (at checkpoint) → error (at end-work if unresolved)
```

This is LodeTime's answer to **spec drift** — the problem where code evolves but architecture definitions go stale. A static spec file cannot detect its own obsolescence; a running companion can.

Detection strategies (progressive):
- **Staleness heuristic**: code under a component's `location` changed N times without YAML update → warn
- **Dependency divergence**: actual imports don't match `depends_on` → error
- **Orphan detection**: new modules appear under a component's path with no declared relationship → warn

See: `docs/discussion/2026-02-09-sdd-drift-analysis.md` for rationale (two layers of drift).

---

## Smart Test Selection

```
File changed: lib/users/registration.ex
         ↓
Component: user-service
         ↓
Affected: [user-service, auth-provider, api-gateway]
         ↓
Tests prioritized:
  1. Recently failed
  2. Fast tests first
  3. Direct before integration
```

Tests are typically run at **checkpoint**; slow tests may run async and report later.

---

## Notification Channels

```yaml
notifications:
  terminal:
    enabled: true
    bell_on_error: true
    
  desktop:
    enabled: false
    quiet_hours: "22:00-08:00"
    
  file:
    path: .lodetime/status.json  # For editor integration
```
