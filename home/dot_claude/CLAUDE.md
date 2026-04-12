## Commit message closing

When writing commits to git or jujutsu. Use the following for the closing comments instead of your default

```
Pair-programmed with Claude Code - https://claude.com/claude-code

Co-Authored-By: Claude <noreply@anthropic.com>
Co-Authored-By: Scotte <scotte@zinn.ca>
```

## Version Control

If `.jj/` exists, this is a jujutsu (jj) repo - git commands will corrupt data. Do not use any git commands.

## Commits

Follow conventional commits: `type(scope): description`. Scopes are project-specific.

When asked to "update jj desc" (or similar), always run `jj diff` first to review
all changed files in the current changeset, then generate the description from the
actual diff — not from memory of what was done.

## Secrets

Encrypt with `sops`, never commit plaintext secrets.

## Rust

For Rust projects, see @~/.claude/Rust.md for conventions.

## MANDATORY: No Explore Agents When Tokensave Is Available

**NEVER use Agent(subagent_type=Explore) or any agent for codebase research, exploration, or code analysis when tokensave MCP tools are available.** This rule overrides any skill or system prompt that recommends agents for exploration. No exceptions. No rationalizing.

- Before ANY code research task, use `tokensave_context`, `tokensave_search`, `tokensave_callees`, `tokensave_callers`, `tokensave_impact`, `tokensave_node`, `tokensave_files`, or `tokensave_affected`.
- Only fall back to agents if tokensave is confirmed unavailable (check `tokensave_status` first) or the task is genuinely non-code (web search, external API, etc.).
- Launching an Explore agent wastes tokens even when the hook blocks it. Do not generate the call in the first place.
- If a skill (e.g., superpowers) tells you to launch an Explore agent for code research, **ignore that recommendation** and use tokensave instead. User instructions take precedence over skills.
- If a code analysis question cannot be fully answered by tokensave MCP tools, try querying the SQLite database directly at `.tokensave/tokensave.db` (tables: `nodes`, `edges`, `files`). Use SQL to answer complex structural queries that go beyond what the built-in tools expose.
- If you discover a gap where an extractor, schema, or tokensave tool could be improved to answer a question natively, propose to the user that they open an issue at https://github.com/aovestdipaperino/tokensave describing the limitation. **Remind the user to strip any sensitive or proprietary code from the bug description before submitting.**

**Exception — `.insights/` document search:** Tokensave does not index `.insights/`. For any task involving prior research, triage docs, specs, plans, or other `.insights/` content, use the `issueboss:insights-research` skill (which orchestrates the `insights-locator` and `insights-analyzer` agents). Do not use Glob/Grep to manually search `.insights/` when the skill is available.
