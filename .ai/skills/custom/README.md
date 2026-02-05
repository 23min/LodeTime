# Custom Skills

This folder contains **project-specific** skills that extend the generic AI framework for current project-specific workflows.

## Purpose

While the core framework (`.ai/agents/`, `.ai/skills/`, `.ai/instructions/`) should remain generic and portable, some projects need specialized workflows. Custom skills allow you to:

1. **Extend without polluting** - Keep project-specific skills separate from the generic framework
2. **Maintain portability** - Clear boundary between framework and project adaptations
3. **Share patterns** - Document project-specific approaches that might inform future framework improvements

## When to Create Custom Skills

Create a custom skill when:

- The workflow is specific to current project's architecture, tools, or processes
- It references project-specific paths, systems, or conventions
- It wouldn't make sense in a different project context
- It's too specialized to generalize into the core framework

## When NOT to Use Custom Skills

Don't create custom skills for:

- Generic development workflows (belongs in core `.ai/skills/`)
- Framework improvements (update core skills instead)
- Agent responsibilities (extend agent definitions or create new agents)
- One-off tasks (use ad-hoc instructions or PROVENANCE.md)

## Current Custom Skills

*(None yet - current project uses generic framework without project-specific extensions)*

## Example: Custom Skills from Another Project

An external project using this framework has three custom skills:

- `architecture-spec-maintenance.md` - Maintains project-specific architecture specs
- `component-refine.md` - Refines component definitions in project's architecture system
- `phase-progress.md` - Updates phase status in project's phase tracking system

These are good examples of legitimate custom skills: highly project-specific, reference project-specific systems, wouldn't apply to other projects.

## Adding Custom Skills

1. Create skill file in this folder: `.ai/skills/custom/your-skill.md`
2. Follow the standard skill template structure
3. Clearly mark as project-specific in the Purpose section
4. Reference from appropriate agent definition if needed
5. Update this README with a brief description
6. Consider: Could this be generalized for the core framework?

## Framework Portability

Custom skills intentionally break framework portability - they're meant to. When adapting the framework to a new project:

1. Review custom/ skills from source project
2. Identify if any patterns could be generalized
3. Create new custom/ skills for the new project's needs
4. Don't copy custom/ skills between projects blindly
