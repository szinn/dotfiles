---
name: backlog
description: Use when the user references the backlog, asks about issues, wants to create/update/triage an issue, asks what's ready to work on, or wants to decompose an epic into child issues
---

# Backlog

Manage a file-based issue backlog in `.backlog/` at the project root. Issues are Markdown files with YAML frontmatter, tracked in VCS.

## Issue Format

Filename: `<type>-<slug>.md`  — e.g. `bug-login-broken.md`, `epic-v2-migration.md`

```yaml
---
slug: bug-login-broken
type: bug           # bug | feature | epic
status: not-started # needs-triage | not-started | in-progress | on-hold | abandoned | complete
description: Short one-line description
priority: P1        # P0 critical | P1 high | P2 medium | P3 low | P4 backlog
parent:             # optional: slug of parent epic
depends-on:         # optional: slugs that must be complete before this starts
  - other-slug
---
```

Issue body is freeform Markdown:
- **bug**: problem statement, reproduction steps, expected vs. actual
- **feature**: requirements, user scenarios, acceptance criteria
- **epic**: overall goal + plan; decomposed into child issues before orchestration

Completed issues append `## Handoff` only when there is context for the next issue to use.

## Query & Summarize

Run the summary script from the project root and present the output:

```bash
python3 ~/.claude/skills/backlog/backlog-summary.py
```

Output is grouped by status. Within `not-started`, items are split into **Ready** (all `depends-on` complete) and **Blocked** (unmet deps listed). An item is only Ready if its deps are complete recursively.
For filtered views (e.g., by type or status), read `.backlog/` files directly.

## Triage

For `needs-triage` items: read the issue body and ask targeted questions to build out the plan, requirements, and any needed research. When the issue is sufficiently planned — meaning the implementation approach is clear and a subagent could execute it in one shot without further research — update `status` to `not-started`.

## Create Issues

1. Generate a slug (lowercase, hyphens, no spaces)
2. Choose filename: `<type>-<slug>.md`
3. Write frontmatter + initial body
4. Confirm with user before writing the file

## Update Issues

Change `status`, `priority`, add/remove `depends-on` entries, or append content to the body. Always read the current file before editing. Confirm with user before writing status changes.

## Epic Decomposition

When an epic is ready to break down:

1. Read the epic's plan section
2. Identify logical phases/steps as candidate child issues
3. For each child: create `<type>-<slug>.md` with `parent: <epic-slug>` and appropriate `depends-on` (including deps on prior sibling steps)
4. Show the full dependency chain to the user and confirm before writing any files
5. Write every child slug into the epic's `depends-on:` frontmatter list. Since `backlog-summary.py` only marks an item Ready when all its deps are `complete`, this makes the epic appear Ready only after all children are done — signaling it is ready for final verification.
6. Update the epic's body to note it has been decomposed

## What This Skill Does NOT Do

Does not execute work, create worktrees, or dispatch subagents. Use `backlog-orchestrator` for that.
