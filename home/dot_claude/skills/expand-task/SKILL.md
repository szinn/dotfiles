---
name: expand-task
description: Expand a brief task description into a structured, context-rich prompt that maximizes first-attempt success. Makes no code changes until the user approves the prompt.
disable-model-invocation: true
metadata:
  product_area: code_authoring
---

# Expand Task Skill

Takes a brief task description and produces a structured prompt enriched with codebase context,
conventions, and acceptance criteria — designed to maximize the chance of one-shotting the task.

## When This Skill Activates

Use this skill when:

1. You have a task to perform but want to front-load research before executing
2. The task touches unfamiliar code or multiple files
3. You want a reviewable plan before the Agent starts making changes
4. The task is complex enough that missing context could cause a failed attempt

## Input

`$ARGUMENTS` — A brief, natural-language task description.

**Examples:**

- `"add a field to a request struct"`
- `"move an endpoint to another service"`
- `"add retry logic to a sync job"`
- `"add a config setting for batch size"`

## Mandatory Process

### Phase 1: Understand the Task

Parse `$ARGUMENTS` to identify:

- **Action type**: create, modify, migrate, remove, refactor, fix, etc.
- **Target**: the specific class, file, endpoint, or module involved
- **Domain**: which part of the system this touches

### Phase 2: Research the Codebase

Perform targeted research to gather context. Do NOT edit files.
Adapt the research to the task type:

**For modifications to existing code:**

- Locate the target class/file and read it
- Find existing tests (unit, integration, component) for the target
- Identify the project build system (e.g. Cargo.toml) and the root project
- Look for similar patterns in the codebase (how was this done before?)
- Check for proto definitions if the target involves request/response types

**For new code creation:**

- Find the appropriate project/module to place the new code
- Identify naming conventions from neighboring files
- Find similar existing implementations to use as a template
- Check build system files (e.g., `Cargo.toml`) for available dependencies
- Look for existing protos that may need extending

**For migrations/refactors:**

- Map the full dependency chain (what depends on this? what does this depend on?)
- Identify all call sites
- Find related configuration (settings, feature flags)
- Check for database entities involved

**Always check:**

- Relevant style guide sections in `styleguide/` (if in a repo with one)
- Project-specific CLAUDE.md or AGENTS.md instructions
- Existing patterns for the same type of change

### Phase 3: Produce the Structured Prompt

Output a structured prompt in the following format, enclosed in a markdown code block
so the user can copy it:

```markdown
## Context

[2-5 bullet points of critical context discovered during research]

- **Target**: [file path + class/function name]
- **Project**: [crate / workspace member or module]
- **Related files**: [list key files: tests, related modules, config, schemas]
- **Existing pattern**: [reference to similar code that should be followed]

## Task

[Clear, specific description of what to do — expanded from the original brief description.
Include the "why" if it can be inferred.]

## Requirements

[Numbered list of specific, unambiguous steps]

1. [Step 1 — be specific about file paths, class names, method signatures]
2. [Step 2]
3. ...

## Constraints

[Bullet list of rules to follow — drawn from style guides, existing patterns, and conventions]

- [Constraint from style guide]
- [Pattern observed in codebase]
- [Anti-pattern to avoid]

## Acceptance Criteria

[How to verify the task is complete]

- [ ] Code compiles and unit tests pass (run only unit tests; leave other suites to CI)
- [ ] Lint passes
- [ ] No dead code left behind
```

### Phase 4: Present for Review

After outputting the structured prompt:

1. Ask the user to clarify any ambiguity
2. Ask the user if they want to adjust anything before execution
3. If the user approves, proceed to execute the task using the structured prompt as the plan
4. If the user wants changes, revise and re-present

## Anti-Patterns to Avoid

- **Don't skip research**: The whole point is front-loading context. Never produce a structured
  prompt based only on the brief description without reading the codebase.
- **Don't make code changes**: This skill is research-only in Phase 1-3. Changes happen only
  after the user approves in Phase 4.
- **Size**: Keep the structured prompt concise and actionable, about one screen.
- **Don't guess file paths**: Every path in the output should come from actual tool results.
- **Keep research proportionate**: read the files that directly bear on the task, not
  the whole module.
- **Only constraints that apply**: Include style-guide rules and architectural constraints only
  where they bear on this specific task.

## Success Criteria

You have successfully used this skill when:

- [ ] The structured prompt contains real file paths verified by tools
- [ ] At least one existing pattern/template was found and referenced
- [ ] The requirements are specific enough that another engineer could follow them
- [ ] The acceptance criteria include runnable verification commands
- [ ] The user had a chance to review before any code changes were made
