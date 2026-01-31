# Handling Real-World Codebases

> Cross-repo dependencies, messy code, and gradual adoption

---

## Cross-Repo Dependencies

### Level 0: Manual Stubs (Start Here)

```yaml
# .lodetime/external/platform-core.yaml
id: platform-core
type: external-stub
source: "https://github.com/acme/platform-core"

provides:
  - name: PlatformService
    description: "Base class for all services"
```

### Level 1: Remote Fetch

```yaml
external_sources:
  shared-lib:
    type: lodetime-remote
    url: https://github.com/myorg/shared-lib
    path: .lodetime/
    cache_ttl: 24h
```

---

## Dealing with Legacy

```yaml
zones:
  legacy:
    paths: [lib/legacy/]
    tracking: full
    rules: []  # No enforcement
    on_import: warn
```

---

## Gradual Adoption

```bash
# Start minimal
lodetime init --minimal

# Add components incrementally
lodetime add-component user-service --location=lib/users/

# Enable stricter tracking later
lodetime config set zones.core.tracking full
```

---

## The Ratchet

Start permissive, gradually tighten:

- Week 1: Track but don't enforce
- Week 2: Add warning-level rules
- Month 2: Promote to errors
- Month 3: Full enforcement
