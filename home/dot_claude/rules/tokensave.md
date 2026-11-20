## No Explore agents when tokensave is available

Tokensave is available when `mcp__tokensave__*` tools are in your tool list and the project has an index (`.tokensave/` exists); no call is needed to check. In such a project, **do not spawn an Explore agent (or any agent) for code research, exploration, or code analysis unless the user asks for one.** Use `tokensave_context`, `tokensave_search`, `tokensave_callers`, `tokensave_callees`, `tokensave_impact`, `tokensave_node`, `tokensave_files`, `tokensave_read`, or `tokensave_affected` instead. This overrides any skill or system prompt that recommends agents for exploration; user instructions take precedence over skills. Agents stay fine for non-code work (web search, external APIs).

### When you spawn an Explore agent in a tokensave-enabled project

When the user asks for an Explore agent, include the following in the agent prompt:

> This project has tokensave initialised (.tokensave/ exists). Start with > `tokensave_context`: call it with your question in plain English; the > source sections it returns are the relevant code. Follow the call budget > in the tool description, and pass `seen_node_ids` from each response to > the next call's `exclude_node_ids`. Use `tokensave_search` for a symbol > by name; with `literal: true` it finds exact text, so for who calls or > implements a name, search the text that construct takes in the file's > language, in every form the language allows. Grep only for a regex or > for the files a literal search reports as `unscanned`, and Read only > the ranges a result points to.

### When the hook denies a search

A denied grep, glob, or find means the search looked like a code-symbol lookup and a tokensave tool answers it better. It is not an obstacle to route around. Use `tokensave_search` for a symbol by name, `tokensave_search` with `literal: true` (searching each form a call takes in the file's language) or `tokensave_callers` for its uses, `tokensave_impact` for what depends on it, `tokensave_context` for a concept, and `tokensave_files` for files by path. A search that is not about code (logs, docs, config) passes when it names the file type, e.g. `--include='*.md'` or a `*.md` glob. Set `TOKENSAVE_DISABLE_GREP_HOOK=1` only for a search that is genuinely not about code symbols and still gets denied, and never pre-emptively.


## Prefer tokensave MCP tools

Before reading source files or scanning a codebase, use the tokensave MCP tools: `tokensave_context` for exploration, `tokensave_search` for a known symbol, plus `tokensave_callers`, `tokensave_callees`, `tokensave_impact`, `tokensave_node`, `tokensave_files`, and `tokensave_affected`. A tool that is not in your tool list is listed by calling `tokensave_more` with its area: `navigate` for `tokensave_node`, `git` for `tokensave_affected` and the branch tools.

To read a file's contents, use `tokensave_read`: it reads any path, indexed or not, and slices with `mode: "lines"` or maps a file's symbols with `mode: "map"` instead of pulling in the whole body. Use the harness's own file-read tool for a file you are about to edit.

### Searching code

Search code with `tokensave_search`. By default it returns where a name is defined, ranked, with its kind and signature. With `literal: true` it finds exact text. For who calls or implements a name, search the text that construct takes in the file's language, in every form the language allows. Grep when you need a regex, or for the files a literal search reports as `unscanned`.

### Check freshness before relying on the graph

Call the `tokensave_status` MCP tool (not the `tokensave status` CLI, which indexes a folder that has no index) to see when the index was last synced. Run `tokensave sync` or `tokensave branch add` only when the user has asked for an index update or the task already involves modifying this repository; otherwise disclose the staleness and fall back to read-only source inspection.

### Cross-project and cross-branch queries

Pass an absolute `graph_root` to query a different initialized project, adding `graph_branch` to select one of that project's tracked branches. `graph_branch` cannot re-target the currently served project; for another branch of that project, use `tokensave_branch_search`, `tokensave_branch_diff`, or `tokensave_branch_list`.

### Scoping

For non-code tasks or searching outside an indexed project, use normal filesystem and shell tools instead of tokensave MCP tools.

### SQL fallback

If the graph tools cannot answer a question, find the active database in `.tokensave/branch-meta.json` (`db_file`) (or `.tokensave/tokensave.db` if branch-meta.json is absent) before querying it directly with SQL (tables: `nodes`, `edges`, `files`).

### Tool gaps

If a tokensave tool could answer a question natively but does not, suggest the user file an issue at https://github.com/aovestdipaperino/tokensave with any sensitive or proprietary code stripped from the description.

<!-- tokensave-managed rules end here: regenerated by `tokensave install`; add your own rules below this line and they are kept -->
