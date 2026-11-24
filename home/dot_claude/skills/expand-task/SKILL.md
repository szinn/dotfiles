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

## Input

`$ARGUMENTS` — A brief, natural-language task description.

**Examples:**

- `"add a field to a request struct"`
- `"move an endpoint to another service"`
- `"add retry logic to a sync job"`
- `"add a config setting for batch size"`

## Mandatory Process

### Phase 1: Research the Codebase

Research the codebase without editing files. Gather what the structured prompt below needs: the
real target files, their tests, an existing pattern to follow, every call site a change would
touch, and any project instructions (CLAUDE.md / AGENTS.md) that bear on it.

### Phase 2: Produce the Structured Prompt

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

[Bullet list of the outcomes the change must produce; number them only where order matters]

- [Outcome — name the files, types, or signatures it must touch or preserve]
- [Outcome]
- ...

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

### Phase 3: Present for Review

After outputting the structured prompt:

1. Ask the user to clarify any ambiguity
2. Ask the user if they want to adjust anything before execution
3. If the user approves, proceed to execute the task using the structured prompt as the plan
4. If the user wants changes, revise and re-present

## Anti-Patterns to Avoid

- **Don't skip research**: The whole point is front-loading context. Never produce a structured
  prompt based only on the brief description without reading the codebase.
- **Don't make code changes**: This skill is research-only in Phases 1-2. Changes happen only
  after the user approves in Phase 3.
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
