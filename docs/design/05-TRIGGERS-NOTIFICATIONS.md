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
