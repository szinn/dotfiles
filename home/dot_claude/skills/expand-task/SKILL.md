---
name: expand-task
description: Expand a brief task description into a structured, context-rich prompt that maximizes first-attempt success. Research-only — does not make code changes.
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

- `"add a new field to InferencePipelineRequest"`
- `"migrate the ShipmentTrackingApi.getStatus endpoint to the shipping service"`
- `"add retry logic to the brand sync job"`
- `"create a new setting for controlling recommendation batch size"`

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
- Identify the projcte build system (e.g. Cargo.toml) and the root project
- Look for similar patterns in the codebase (how was this done before?)
- Check for proto definitions if the target involves request/response types

**For new code creation:**

- Find the appropriate project/module to place the new code
- Identify naming conventions from neighboring files
- Find similar existing implementations to use as a template
- Check build system files (e.g., `Cargo.toml``) for available dependencies
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
- **Project**: [Gradle project path or module]
- **Related files**: [list key files: tests, protos, Guice modules, etc.]
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

- [ ] [Tests compile and unit tests run — do NOT run non unit tests, let CI handle that. Verify how the project definitions
- [ ] [Lint passes
- [ ] [No dead code left behind]
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
- **Don't be verbose**: The structured prompt should be concise and actionable.
  Aim for something that fits on one screen and is easily readable.
- **Don't guess file paths**: Every path in the output should come from actual tool results.
- **Don't over-research**: Spend up to 1 minute on research. Focus on the files
  that directly matter.
- **Don't include style guide rules**: Only include architectural constraints that actually apply
  to this specific task.

## Success Criteria

You have successfully used this skill when:

- [ ] The structured prompt contains real file paths verified by tools
- [ ] At least one existing pattern/template was found and referenced
- [ ] The requirements are specific enough that another engineer could follow them
- [ ] The acceptance criteria include runnable verification commands
- [ ] The user had a chance to review before any code changes were made
