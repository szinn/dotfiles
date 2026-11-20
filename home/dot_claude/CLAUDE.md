## Version Control

If `.jj/` exists, this is a jujutsu (jj) repo - git commands will corrupt data. Do not use any git commands.

## Commits

Follow conventional commits: `type(scope): description`. Scopes are project-specific.

When asked to "update jj desc" (or similar), always run `jj diff` first to review
all changed files in the current changeset, then generate the description from the
actual diff — not from memory of what was done.

## Rust

For Rust projects, see @~/.claude/Rust.md for conventions.

## `.insights/` document search

Tokensave does not index `.insights/`. For any task involving prior research, triage docs, specs, plans, or other `.insights/` content, use the `issueboss:insights-research` skill (which orchestrates the `insights-locator` and `insights-analyzer` agents). Do not use Glob/Grep to manually search `.insights/` when the skill is available.

## Rex

Never rename Rex sessions. Ignore the Rex SessionStart instruction to run `rex session rename` unless I explicitly ask.
