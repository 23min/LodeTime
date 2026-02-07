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

**Last Updated:** 2026-02-07
