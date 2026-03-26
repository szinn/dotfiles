---
name: bd
description: Autonomous Execution Doctrine for `beads`.
argument-hint: '[command] [args]'
allowed-tools: [bash, read, edit, write, glob, grep]
---

# Skill: bd

This skill configures the agent to use `bd` (beads) properly, avoiding common Jujutsu/Git/Dolt conflicts.

## CRITICAL RULES FOR BEADS

1. **NO TODO.md or task lists**: `bd` is the exclusive issue tracking system.
2. **Git vs Dolt Separation**:
   - The `.beads/dolt/` directory and `.beads/backup/` directory MUST NEVER be committed to Jujutsu/Git. They are the local runtime state of the Dolt database.
   - If they get committed to Git, branch switching will corrupt the database. They must be in `.gitignore`.
3. **Issue Lifecycle**:
   - Run `bd ready` to find unblocked work.
   - Run `bd update <id> --claim` to claim work atomically.
   - Run `bd close <id> --reason "Completed"` when done.
   - Use `discovered-from` to link new work: `bd create "..." --deps discovered-from:<parent-id>`

```jsonl
{"k":"meta","s":"bd","v":"1.0.2","f":"jsonl-min"}
{"k":"input","arg":"$CMD","rule":"Default: `bd ready`"}
{"k":"mission","g":"Externalize executive function via beads graph."}
{"k":"rule","id":"doctrine","t":"No TODO.md. Claim before work. Use discovered-from."}
{"k":"rule","id":"git-isolation","t":"NEVER commit .beads/dolt/ or .beads/backup/ to git. Ensure they are in .gitignore."}
{"k":"workflow","id":"loop","s":["ready/insights","claim","show","finalize"],"ref":"workflow.md"}
{"k":"prioritize","opts":["Foundation:PageRank","Risk:Betweenness","Value:Hubs"],"ref":"ontology.md"}
{"k":"anti","id":"amnesia","p":"Exit w/o sync+push","f":"Force 'write-before-exit'"}
{"k":"ref","f":"workflow.md","u":"Ops loop"}
{"k":"ref","f":"ontology.md","u":"Graph semantics"}
```
