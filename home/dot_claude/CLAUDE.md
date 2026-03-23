## Commit message closing

When writing commits to git or jujutsu. Use the following for the closing comments instead of your default

```
Pair-programmed with Claude Code - https://claude.com/claude-code

Co-Authored-By: Claude <noreply@anthropic.com>
Co-Authored-By: Scotte <scotte@zinn.ca>
```

## Version Control

If the project root contains a `.jj` directory, use `jj` (jujutsu), not `git`. Key commands: `jj commit`, `jj describe`, `jj new`, `jj log`, `jj status`.

## Commits

Follow conventional commits: `type(scope): description`. Scopes are project-specific.

When asked to "update jj desc" (or similar), always run `jj diff` first to review
all changed files in the current changeset, then generate the description from the
actual diff — not from memory of what was done.

## Secrets

Encrypt with `sops`, never commit plaintext secrets.

## Rust

For Rust projects, see @~/.claude/Rust.md for conventions.
