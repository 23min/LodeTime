# Commit Message Format Guide

This project uses [Conventional Commits](https://www.conventionalcommits.org/).

---

## Structure

```
<type>(<scope>): <brief summary in imperative mood>

<optional body with bullet points>

<optional footer>
```

## Types

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `chore:` Maintenance, config, dependencies
- `refactor:` Code restructuring without behavior change
- `test:` Adding or updating tests

## Guidelines

- Keep subject line under 72 characters
- Use imperative mood: "add" not "added" or "adds"
- Body explains what and why, not how
- Reference issues/PRs if relevant

## Examples

```
docs: add AI configuration documentation

feat(reporting): implement data extraction pipeline

chore(deps): update dependencies to latest versions
```

## Co-authorship

For AI-assisted work, add a co-author trailer. The specific attribution depends on which AI tool was used — see per-target instructions.
