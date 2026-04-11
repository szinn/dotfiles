---
name: using-jj-workspaces
description: Set up isolated jj workspaces for parallel development in jj projects. ALWAYS use this skill — not git worktree skills — when the project contains a .jj/ directory. Use when starting feature work that needs isolation, before executing implementation plans, creating new workspaces, or any time physical directory isolation is needed in a jj repo.
metadata:
  version: 1.0.0
---

# Using JJ Workspaces

You're helping set up and use an isolated jj workspace for parallel development work without disrupting the current workspace.

## Core Workflow: Systematic Directory Selection + Safety Verification

### 0. Workspace Check (Always Run First)

Before doing anything else, determine whether workspace creation is actually needed:
(Exiting this skill means stopping here and returning to the conversation — no workspace is created.)

1. **Check for explicit user instruction**: If the user has expressed intent to work in the current directory without creating a new workspace — for example "work here", "use this workspace", "don't create a new workspace", or "work in the main workspace" — confirm that choice and **exit this skill**. Do not proceed to Step 1.

2. **Check current workspace**: Run `jj workspace list`. If the command fails or the directory is not a jj repo, **exit this skill** and inform the user that no jj repository was found. If you are already in a named workspace other than `default` (the main workspace), ask: "You are already in workspace `<name>`. Should I create a new workspace, or continue work here?" If they want to continue here, **exit this skill**. If they want a new workspace, continue to Step 1.

3. **Proceed**: If neither condition applies, continue to Step 1.

### 1. Directory Selection (Priority Order)

Check for workspace directory preferences in this order:

1. **First**: Check if `.workspaces/` or `workspaces/` directory exists in project root
2. **Second**: Review CLAUDE.md or similar project documentation for workspace preferences
3. **Third**: If neither exists, ask the user:
   - Option A: Create project-local directory (`.workspaces/` or `workspaces/`)
   - Option B: Use global location (e.g., `~/workspaces/`)

**Never assume** - always follow this priority system.

### 2. Safety Verification (CRITICAL for project-local directories)

If using a project-local directory (`.workspaces/`, `workspaces/`, etc.):

1. **Check `.gitignore`** for the workspace directory pattern (jj reads `.gitignore` files — there is no separate `.jjignore`)
2. **If NOT in .gitignore**:
   - If the working copy has uncommitted changes (`jj status` shows modifications), run `jj new` first to move to a clean changeset
   - Add the ignore entry: `echo "workspaces/" >> .gitignore` (or `.workspaces/` as appropriate)
   - Commit the change: `jj describe -m "gitignore: Add workspaces directory"`
   - This prevents accidentally tracking workspace contents

**Never skip this verification** - it's a critical safety check.

### 3. Workspace Creation

```bash
# Construct workspace path
WORKSPACE_PATH="<selected-directory>/<branch-or-feature-name>"

# Create the workspace
jj workspace add "$WORKSPACE_PATH"

# JJ will automatically:
# - Create the directory
# - Set up a new workspace tracking the current repository
# - Create a new working-copy commit
```

### 4. Project Setup (Auto-detect and run)

Check with the project's CLAUDE.md for project-specific instructions on getting a new workspace ready. If these instructions are missing, notify the user and ask.

**Always:**

1. Change to workspace directory: `cd "$WORKSPACE_PATH"`
2. Run the appropriate setup commands
3. Report any setup errors to the user

### 5. Baseline Verification

Check with the project's CLAUDE.md for project-specific instructions on test verification to ensure a clean state. If these instructions are missing, notify the user and ask.

**If baseline tests fail:**

- Report the failure to the user
- **Do NOT proceed** with implementation unless user explicitly approves
- The workspace may have inherited an unstable state

### 6. Report Status

Provide a clear summary:

```
✓ JJ workspace created at: <path>
✓ Project setup completed: <command run>
✓ Baseline tests: <passed/failed>
✓ Ready to work on: <feature/branch name>

To switch to this workspace:
  cd <workspace-path>

To return to main workspace:
  cd <original-path>

To list all workspaces:
  jj workspace list
```

## JJ Workspace Commands Reference

```bash
# Create new workspace
jj workspace add <path>

# List all workspaces
jj workspace list

# Remove a workspace (doesn't delete files)
jj workspace forget <workspace-name>

# Show workspace root
jj workspace root

# Update workspace to latest changes
jj workspace update-stale
```

## Critical Rules

1. **Never skip .gitignore verification** for project-local workspace directories
2. **Always follow the directory priority system** - don't assume location
3. **Require explicit permission** before proceeding if baseline tests fail
4. **Report clearly** when workspace is ready with all relevant paths and commands
5. **Auto-detect and run setup** - don't make the user do it manually

## JJ-Specific Considerations

Unlike git worktrees, jj workspaces:

- Share the same operation log (visible in `jj op log`)
- Each workspace has its own working-copy commit
- Changes in one workspace don't affect others until explicitly moved/rebased
- No need to specify a branch - jj creates a new working-copy commit automatically
- Use `@` to refer to the current workspace's working-copy commit

## Integration Notes

This skill is typically invoked during:

- Feature development requiring isolation from main work
- Testing changes without affecting current workspace
- Parallel development on multiple features
- Experimentation that might be abandoned

Pairs well with:

- JJ squash workflow for finishing work
- JJ split for organizing changes before moving back to main workspace
