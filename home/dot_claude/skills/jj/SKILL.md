---
name: jj
description: Jujutsu (jj) version control expert. Use when the project contains a `.jj/` directory, user asks about jj, jujutsu, workflow isolation, stacking changes, bookmarks, rebasing, conflict resolution, or any VCS operations involving jj. Covers the full jj command surface including workspaces, operation log, revsets, and GitHub/Gerrit integration.
argument-hint: [command or workflow question]
---

You are an expert in **Jujutsu (jj)**, the Git-compatible VCS. Apply deep knowledge of jj's model, commands, and idioms. Always prefer jj-native patterns over Git mental models.

If the project you are working in has a `.jj/` directory in the project root (`jj root`) then you should use Jujutsu commands for version control. DO NOT use Git commands as they may corrupt the source code and repository.

## Core Mental Model

- **Working copy IS a commit** (`@`). Edits auto-amend. No staging area, no stash.
- **Change IDs are stable** across rewrites. Commit IDs are not. Use change IDs in workflows.
- **Anonymous branches are normal.** Bookmarks are optional labels, not required for work.
- **Conflicts are first-class.** You can commit with conflicts and resolve later.
- **All operations are logged and undoable** via `jj op log` / `jj undo` / `jj op Interactivestore`.
- **Automatic rebasing**: editing an ancestor automatically rebases all descendants.

## Workflow Isolation Patterns

### 1. Anonymous Branch Isolation (Default)

The simplest isolation — just start new work from trunk:

```bash
jj new main          # isolated change rooted at main
# work...
jj new               # finish, start next isolated change
jj new main          # another isolated line of work
```

Each line of work is an independent anonymous branch. Switch between them with `jj edit <change-id>`. No branch naming, no checkout conflicts.

### 2. Workspace Isolation

See @jj-workspaces.md for using workspaces.
e

### 3. Stacked Change Isolation

Build dependent changes as an isolated stack:

```bash
jj new main                              # base of stack
# first logical change...
jj commit -m "part 1: data model"
# second logical change...
jj commit -m "part 2: API layer"
# third logical change...
jj describe -m "part 3: UI integration"
```

Navigate the stack: `jj prev`, `jj next`, `jj edit <change-id>`.
Restructure: `jj rebase`, `jj squash`, `jj split`, `jj parallelize`.

### 4. Isolate Then Merge

Create parallel work then combine:

```bash
jj new main          # work A
# ...
jj new main          # work B (independent)
# ...
jj new <change-A> <change-B>   # merge commit with both as parents
```

## Essential Commands Reference

### Creating & Navigating

| Command                | Purpose                                                 |
| ---------------------- | ------------------------------------------------------- |
| `jj new [parents...]`  | New change (optionally with multiple parents for merge) |
| `jj commit -m "msg"`   | Describe current change and start a new one             |
| `jj describe -m "msg"` | Set/update description without creating new change      |
| `jj edit <change-id>`  | Switch to editing a specific change                     |
| `jj prev [--edit]`     | Move to parent (optionally edit it directly)            |
| `jj next [--edit]`     | Move to child                                           |

### History Rewriting

| Command                    | Purpose                                                        |
| -------------------------- | -------------------------------------------------------------- |
| `jj squash`                | Fold working copy into parent                                  |
| `jj split`                 | Interactively break a change into two                          |
| `jj absorb`                | Intelligently distribute hunks to appropriate ancestor commits |
| `jj rebase -d <dest>`      | Move changes onto a new base                                   |
| `jj parallelize <revset>`  | Convert linear stack to parallel siblings                      |
| `jj duplicate <change-id>` | Copy change with new identity                                  |
| `jj abandon <change-id>`   | Discard change (descendants preserved and rebased)             |
| `jj diffedit -r <change>`  | Surgically edit what a commit contains                         |

### Bookmarks (Branch Labels)

| Command                             | Purpose                                   |
| ----------------------------------- | ----------------------------------------- |
| `jj bookmark set <name> -r @`       | Create or move bookmark to current change |
| `jj bookmark create <name>`         | Create new (fails if exists)              |
| `jj bookmark list`                  | Show all bookmarks                        |
| `jj bookmark track <name>@<remote>` | Track a remote bookmark                   |
| `jj bookmark delete <name>`         | Remove bookmark                           |

### Syncing with Remotes

| Command                                     | Purpose                                |
| ------------------------------------------- | -------------------------------------- |
| `jj git fetch`                              | Pull remote changes                    |
| `jj git push --bookmark <name> --allow-new` | First push of a bookmark               |
| `jj git push --bookmark <name>`             | Update existing remote bookmark        |
| `jj git push --change @ --allow-new`        | Push with auto-generated bookmark name |
| `jj rebase -d main@origin`                  | Rebase onto latest remote main         |

### Conflict Resolution

| Command                     | Purpose                   |
| --------------------------- | ------------------------- |
| `jj status`                 | Shows conflicted files    |
| `jj resolve`                | Interactive merge tool    |
| `jj resolve --tool=:ours`   | Take our side             |
| `jj resolve --tool=:theirs` | Take their side           |
| `jj resolve --list`         | List all conflicted files |

### Safety & Undo

| Command                 | Purpose                      |
| ----------------------- | ---------------------------- |
| `jj undo`               | Reverse last operation       |
| `jj redo`               | Restore after undo           |
| `jj op log`             | Full operation history       |
| `jj op restore <op-id>` | Jump to any prior repo state |

### Inspection

| Command                            | Purpose                               |
| ---------------------------------- | ------------------------------------- |
| `jj log`                           | Commit graph (smart default view)     |
| `jj status`                        | Working copy state                    |
| `jj diff`                          | Changes in current commit             |
| `jj evolog`                        | Evolution history of a change         |
| `jj interdiff --from <a> --to <b>` | Diff between two versions of a change |
| `jj bisect run '<cmd>'`            | Binary search for bug introduction    |
| `jj file list`                     | Tracked files                         |
| `jj file show <path> -r <rev>`     | File contents at revision             |

## Revset Quick Reference

| Expression       | Meaning                               |
| ---------------- | ------------------------------------- |
| `@`              | Current working copy                  |
| `@-`             | Parent of working copy                |
| `main`           | Named bookmark                        |
| `main@origin`    | Remote bookmark                       |
| `main..@`        | Commits between main and working copy |
| `trunk()`        | Main development branches             |
| `tags()`         | All tagged releases                   |
| `ancestors(x)`   | All ancestors of x                    |
| `descendants(x)` | All descendants of x                  |
| `heads(x)`       | Head commits in set x                 |

## Immutable Commits

`trunk()`, `tags()`, and `untracked_remote_bookmarks()` are immutable by default — jj prevents accidental rewrites of shared history.

## Stacked PR Workflow (GitHub)

```bash
jj new main
# work on part 1...
jj commit -m "feat: part 1"
# work on part 2...
jj commit -m "feat: part 2"

jj bookmark set part-1 -r @--
jj bookmark set part-2 -r @-
jj git push --bookmark part-1 --allow-new
jj git push --bookmark part-2 --allow-new

# After review feedback:
jj edit <change-id-of-part-1>
# fix...
jj new                              # continue forward
jj git push --bookmark part-1       # update PR
# descendants auto-rebase, so part-2 is already updated
jj git push --bookmark part-2       # push rebased part-2
```

## Key Differences from Git

| Concept        | jj                             | Git                     |
| -------------- | ------------------------------ | ----------------------- |
| Staging        | None (auto-amend)              | Explicit `git add`      |
| Identity       | Change ID (stable) + Commit ID | SHA only                |
| Branching      | Anonymous + optional bookmarks | Named branches required |
| Conflicts      | First-class, deferrable        | Workflow blockers       |
| History safety | Full operation log + undo      | Reflog (easy to lose)   |
| Rebase         | Automatic on ancestor edit     | Manual                  |

## Anti-Patterns to Avoid

| Anti-Pattern                      | Problem                              | jj Solution                                                          |
| --------------------------------- | ------------------------------------ | -------------------------------------------------------------------- |
| Using `git stash`                 | Fragile, easy to lose work           | Working copy is already a commit — just `jj new` to start fresh      |
| Naming every branch               | Noise, bookkeeping overhead          | Use anonymous branches; only `jj bookmark set` when pushing to forge |
| Using commit IDs in scripts       | IDs change on rewrite                | Use change IDs (stable across rewrites)                              |
| Manual rebasing after edits       | Error-prone, conflicts accumulate    | jj auto-rebases descendants when you `jj edit` an ancestor           |
| Resolving conflicts immediately   | Blocks workflow, context-switch cost | Commit with conflicts, defer resolution (`jj resolve` when ready)    |
| Force-pushing to fix history      | Dangerous, destroys remote state     | Use `jj op restore` locally; push clean bookmarks                    |
| `git checkout -b` mental model    | Misapplies Git branching to jj       | Use `jj new main` for isolation, `jj edit` for switching             |
| Forgetting to fetch before rebase | Rebasing onto stale trunk            | Always `jj git fetch` before `jj rebase -d main@origin`              |
| Large monolithic changes          | Hard to review, hard to rebase       | Use stacked changes with `jj split` and `jj squash`                  |
| Ignoring `jj op log`              | Losing track of repo state history   | Check `jj op log` before any recovery; use `jj op restore`           |

## Best Practices

### Workflow Discipline

- **Start every task from trunk**: `jj new main` ensures clean isolation
- **Describe early, describe often**: `jj describe -m "..."` costs nothing and aids `jj log` readability
- **Commit small, commit often**: jj's auto-amend means your working copy is always saved — use `jj new` to checkpoint
- **Fetch before rebase**: `jj git fetch && jj rebase -d main@origin` prevents stale-trunk surprises

### Isolation Best Practices

- **Default to anonymous branches** for local work — no naming ceremony needed
- **Use workspaces** when you need physically separate directories (e.g., AI sandbox, parallel experiments)
- **Use stacked changes** when work is logically dependent (feature parts 1, 2, 3)
- **Use `jj parallelize`** to convert a linear stack into independent siblings when parts become independent

### Safety & Recovery

- **Always check `jj op log`** before attempting recovery
- **Use `jj op restore`** over manual fixes — it restores complete repo state atomically
- **Never panic about lost work** — jj's operation log means nothing is truly lost
- **Use `jj evolog`** to trace how a specific change has evolved over time

### Collaboration

- **Only create bookmarks when pushing** — `jj bookmark set feat -r @` right before `jj git push`
- **Use `--allow-new`** only on first push; omit it on updates to catch accidental new bookmarks
- **After force-push, communicate** — jj makes history rewriting safe locally, but collaborators need to know
- **Track remote bookmarks explicitly**: `jj bookmark track <name>@origin`

### Code Review & Stacking

- **One logical change per commit** — use `jj split` if a change grows too large
- **Address review feedback with `jj edit`** — auto-rebase keeps the stack consistent
- **Push all bookmarks in a stack** after editing any part — descendants auto-rebase but remotes need explicit push
- **Use `jj absorb`** to automatically distribute fixup hunks to the right commits in a stack

## Quality Gates Checklist

Before pushing any work, verify:

- [ ] All changes have descriptions (`jj log` shows no empty descriptions on bookmarked changes)
- [ ] No unintended conflicts (`jj status` clean, or conflicts are intentionally deferred)
- [ ] Stack is rebased onto latest trunk (`jj git fetch && jj rebase -d main@origin`)
- [ ] Bookmarks point to correct changes (`jj bookmark list`)
- [ ] Tests pass on each change in the stack (navigate with `jj edit`, run tests, `jj new` to return)
- [ ] No abandoned changes left cluttering the log (`jj abandon` unused experiments)
- [ ] Remote is synced (`jj git push --bookmark <name>` for each bookmark)

## Troubleshooting

### "Change is immutable"

```
Problem: jj refuses to edit a change
Cause: Change is in trunk(), tags(), or untracked_remote_bookmarks()

Fix: Create a new change on top instead:
  jj new <immutable-change>
  # make your edits here

Or duplicate it:
  jj duplicate <immutable-change>
  jj edit <new-change-id>
```

### "Bookmark already exists"

```
Problem: jj bookmark create fails
Cause: Bookmark name already taken

Fix: Use set instead of create:
  jj bookmark set <name> -r @
```

### Conflicted changes after rebase

```
Problem: jj rebase introduces conflicts
Cause: Upstream changes overlap with your work

Fix (resolve now):
  jj resolve              # interactive merge tool
  jj resolve --list       # see all conflicted files

Fix (defer resolution):
  # Just keep working — conflicts are stored in the change
  # Resolve later when ready:
  jj edit <conflicted-change>
  jj resolve
```

### Lost a change

```
Problem: Accidentally abandoned or can't find a change
Cause: Change is hidden from default log view

Fix:
  jj op log               # find the operation before the loss
  jj op restore <op-id>   # restore entire repo state

Or find hidden changes:
  jj log -r 'all()'       # show everything including abandoned
```

### Push rejected

```
Problem: jj git push fails
Cause: Remote has changes not in local repo

Fix:
  jj git fetch
  jj rebase -d main@origin
  jj git push --bookmark <name>

Safety: jj never force-pushes by default
```

### Workspace out of sync

```
Problem: Workspace shows stale state
Cause: Changes made in another workspace

Fix:
  jj workspace update-stale   # refresh workspace state
```

## Guidelines

- When suggesting commands, always use `jj` syntax, never `git`.
- Prefer change IDs over commit IDs in instructions.
- Default to anonymous branches unless the user needs to push to a forge.
- When the user needs isolation, evaluate which pattern fits: anonymous branch (lightest), workspace (strongest), or stacked changes (dependent work).
- Always mention `jj undo` / `jj op restore` as the safety net when suggesting destructive-looking operations.
- For GitHub workflows, show the bookmark + push pattern.
- When resolving conflicts, remind the user they can defer resolution.

---

**Skill Version**: 1.0.0
**Last Updated**: March 2026
**Status**: Production-Ready
