# AI Integration

> How LodeTime talks to AI coding assistants

---

## The Problem

AI tools can see code but not:
- What you're PLANNING to build
- What's deprecated vs just old
- What contracts must hold
- What's currently broken

LodeTime provides this missing layer via MCP.

---

## MCP Tools

### lodetime_context
Get full context for a file/component:
```json
{"tool": "lodetime_context", "input": {"path": "lib/users/registration.ex"}}
→ {component, dependencies, contracts, warnings}
```

### lodetime_validate
Check if action is allowed:
```json
{"tool": "lodetime_validate", "input": {"action": "add_dependency", ...}}
→ {allowed: false, violations, suggestions}
```

### lodetime_affected
Impact analysis:
```json
{"tool": "lodetime_affected", "input": {"component": "database-client"}}
→ {affected_components, affected_tests}
```

### lodetime_update
Update status:
```json
{"tool": "lodetime_update", "input": {"component": "X", "status": "implemented"}}
→ {success, now_unblocked: [...]}
```

---

## AI Workflow Example

```
User: "Implement the payment-gateway component"

Claude:
1. lodetime_context("payment-gateway") → planned, blocked by stripe-adapter
2. lodetime_validate(implement payment-gateway) → need stripe-adapter first
3. Implements stripe-adapter
4. lodetime_update(stripe-adapter, "implemented")
5. → payment-gateway now unblocked
6. Continues with payment-gateway
```
