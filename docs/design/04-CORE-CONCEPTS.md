# Core Concepts

> Components, Contracts, Zones, Rules, and State

---

## Components

A **component** is a logical unit of your codebase.

```yaml
id: user-service
name: User Service
status: implemented  # planned | implementing | implemented | deprecated

location: lib/my_app/users/

depends_on:
  - database-client
  - auth-provider

contracts:
  - user-api
```

### Component Status

```
planned → implementing → implemented → deprecated
```

- **planned**: Defined but no code yet (KEY DIFFERENTIATOR)
- **implementing**: Code exists, work in progress
- **implemented**: Complete, tests pass
- **deprecated**: Being phased out

---

## Contracts

Define interfaces between components:

```yaml
id: user-api
operations:
  - name: create_user
    input: {email: string, password: string}
    output: {id: string, email: string}
    errors: [validation_error, duplicate_email]
```

---

## Zones

Different parts of your codebase get different treatment:

```yaml
zones:
  core:
    paths: [lib/my_app/]
    tracking: full
    rules: [tests-required, contracts-required]
    
  legacy:
    paths: [lib/legacy/]
    tracking: full
    rules: []  # Relaxed
    on_import: warn
    
  tests:
    paths: [test/]
    tracking: none
```

---

## Rules

Architectural constraints that LodeTime validates continuously:

```yaml
rules:
  - id: no-circular-deps
    severity: error

  - id: no-legacy-imports
    severity: warning
```

### Component-Level Constraints (Anti-Debt Rules)

Beyond global rules, components can declare **constraints** — patterns they must follow or forbid. These are lightweight anti-debt guards, not code-level linting:

```yaml
id: payment-gateway
constraints:
  require: [result-wrapper, idempotent-operations]
  forbid: [direct-db-access, raw-try-catch]
```

Constraints encode *how* a component must be built, not just *what* it depends on. They prevent architectural erosion that dependency rules alone can't catch.

See: `docs/discussion/2026-02-09-sdd-drift-analysis.md` for rationale (SDD anti-debt concept).

---

## State

Runtime information (not persisted):

- Component health (green/yellow/red)
- Test results
- Recent activity
- What's blocked by what
