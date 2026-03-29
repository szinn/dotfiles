---
name: backlog-orchestrator
description: Use when the user wants to execute backlog issues via subagents — names specific slugs to work on, or wants to work through an epic's child issues
---

# Backlog Orchestrator

Execute ready backlog issues by dispatching subagents. For issue format and backlog management, see the `backlog` skill.

## Pre-Flight Check (Always)

Before any work begins, for every named issue:

1. Read the issue's frontmatter from `.backlog/<type>-<slug>.md`
2. Check `status`:
   - `needs-triage` → **hard stop** — tell the user to triage this issue with the `backlog` skill first; do not proceed under any circumstances
   - any status other than `not-started` or `needs-triage` → confirm with user before proceeding
3. Check `depends-on`: every listed slug must have `status: complete` in its frontmatter
4. Present a summary of: which issues will be worked, in what order, workspace plan
5. **Ask the user to confirm before starting**

## Batch Mode

User names the slugs explicitly. Orchestrator does not auto-select.

**Single issue:** work in the current environment — no new workspace needed unless user requests one.

**Multiple issues:** each gets its own jj workspace named after the slug.

```bash
# Create workspace for a slug (run from project root)
jj workspace add ../<slug> --name <slug>
```

When multiple issues are specified, dispatch subagents in parallel — one per issue simultaneously. Use `superpowers-extended-cc:dispatching-parallel-agents` to coordinate them.

Each subagent receives the full issue file as context. The issue's plan section must specify what implementation approach and skills to use — if it doesn't, triage the issue before proceeding.

On completion of each issue:
1. Run the end-of-task checklist (see below)
2. Apply handoff protocol (see below)
3. Update `status: complete` in the issue's frontmatter

Report a summary of all outcomes when batch is done.

## Epic Mode

User names one epic. Its child issues (those with `parent: <epic-slug>`) must already exist and be `not-started`.

1. Build execution order from `depends-on` relationships among the children
2. **Execute sequentially by default** — one child issue at a time in the current environment
3. Parallel branches (two siblings that both depend only on an already-complete step): only run in parallel if the dependency graph explicitly permits it AND the user confirms. Merge with:

```bash
jj new <change-id-of-step-5> <change-id-of-step-6>
```

To find the change IDs: run `jj log` to identify the relevant commits by their descriptions. Present the change IDs to the user and confirm the merge plan before running the command. The resulting merge commit becomes the parent for subsequent steps.

4. Before starting each child issue, check whether the previous issue left a `## Handoff` section — if so, write the handoff note into the next issue's body file (as described in Handoff Protocol below) before dispatching the subagent
5. Run the end-of-task checklist before marking each child `complete`
6. When all children are `complete`, the epic's `depends-on` are satisfied: perform final verification of the epic as a whole, then mark the epic `complete`

## Subagent Context

Pass the subagent the full content of the issue file. The issue's plan section must describe:
- What the implementation approach is
- Which skills or workflow to follow (e.g. TDD, systematic-debugging)

If the plan section is missing or too vague to implement in one shot, stop and triage the issue before dispatching.

### Version Control (jj repos)

If the project contains a `.jj/` directory, include these instructions in every subagent prompt:

- **Never use `git` commands** — this is a jj repo; git commands corrupt it.
- Each logical step must be its own jj changeset.
- **Before starting a step:** check `jj diff --stat`. Only run `jj new` if the working copy is non-empty — running `jj new` on an already-empty changeset leaves a stray empty commit.
- **After completing each step:** run the end-of-task routine (`just fmt`, `just clippy`, tests), then `jj desc -m "type(scope): description"` with the conventional commit message and project footer before beginning the next step.
- Use the commit footer from CLAUDE.md exactly.

**Dispatch mechanism:** For parallel batch execution, use `superpowers-extended-cc:dispatching-parallel-agents`. For sequential epic execution, dispatch one subagent at a time using the Agent tool with the full issue content as context.

## Discovered Issues During Implementation

Include this instruction in the context passed to each subagent: do not silently ignore unexpected problems or scope.

- **Small, in-scope problem:** resolve inline; note in the handoff
- **Out-of-scope or non-trivial:** create a new `.backlog/<type>-<slug>.md` with appropriate `status` (`needs-triage` or `not-started`) and `depends-on` if relevant; note the new slug in the handoff

## End-of-Task Checklist

Before marking any issue `complete`:

1. Check the project's `CLAUDE.md` for an end-of-task checklist section and run it
2. If no checklist is defined, run sensible defaults:
   - Build passes
   - Tests pass
   - No lint errors

Do not mark complete until checklist passes.

For jj repos: verify that each logical step has its own described changeset (`jj log` shows no empty or undescribed commits in the work).

## Handoff Protocol

After completing an issue:

- **If there is context the next issue needs** (discovered state, decisions made, artifacts, gotchas): append to the completed issue file:

```markdown
## Handoff

<context for the next subagent>
```

Then add this note at the **top of the next issue's body** (below the frontmatter fence):

```markdown
> **Note for implementer:** Read the `## Handoff` section in `.backlog/<type>-<prev-slug>.md` before starting.
```

- **If there is nothing meaningful to pass on:** skip entirely. No empty handoff sections.
