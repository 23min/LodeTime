# Skill: release

**Maturity:** Production-ready (updated)

**Purpose:** Execute release ceremony after epic is wrapped and merged to main. This creates git tags and updates documentation. For infrastructure deployment, use the separate `deployment.md` skill.

**Trigger phrases:**
- "Create a release"
- "Release epic [name]"
- "Tag and deploy [epic]"

**Use when:** 
- An epic has been wrapped and merged to main
- Ready to create an official release with git tag

## Prerequisites

- Epic wrapped (epic-wrap completed)
- Epic merged to main
- Epic release document exists in `work/epics/releases/<epic-slug>.md`
- Root `CHANGELOG.md` updated

## Process

### Step 1: Verify Epic Release Document

Confirm that `work/epics/releases/<epic-slug>.md` exists and is complete with:
- All milestone summaries
- Breaking changes (if any)
- Impact statement

### Step 2: Create Git Tag

**Tag format:** `epic/<epic-slug>`

Example tags:
- `epic/user-authentication`
- `epic/data-pipeline`
- `epic/api-redesign`

```bash
# Create annotated tag with epic summary
git tag -a epic/<epic-slug> -m "Epic: [Epic Name]

[One-sentence summary from epic release doc]

See work/epics/releases/<epic-slug>.md for details."

# Push tag to remote
git push origin epic/<epic-slug>
```

### Step 3: Create GitHub Release (if using GitHub)

- Navigate to repository releases
- Create new release from tag `epic/<epic-slug>`
- Title: `Epic: [Epic Name]`
- Description: Copy from `work/epics/releases/<epic-slug>.md`

### Step 4: Notify Team

Announce the release:
- Team chat (Slack, Teams)
- Email to stakeholders
- Update project status board

## Outputs

- Git tag created: `epic/<epic-slug>`
- GitHub Release created (if applicable)
- Team notified
- Traceability established (epic slug in tag)
- **Next step:** Use `deployment.md` skill if infrastructure changes needed

## Git Tag Benefits

Using `epic/<epic-slug>` format provides:
- **Traceability**: Tag name directly references epic documentation
- **Searchability**: Easy to find all epic releases (`git tag -l "epic/*"`)
- **Context**: Clear indication this is an epic-level release
- **Documentation link**: Epic slug maps to `work/epics/releases/<epic-slug>.md`

---

**Version:** 2.0.0  
**Last Updated:** 2026-01-28

**Agent:** deployer
