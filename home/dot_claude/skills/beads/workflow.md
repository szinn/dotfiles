# `bd` Workflow: The Autonomous Execution Doctrine

## 1. Triage (The Strategic Choice)

Identify the "Execution Frontier" using the dependency graph.

- `bd ready --json`: Fetches all tasks with ZERO open blockers.
- `bv --robot-insights`: Use for complex prioritization:
  - **Foundational Work**: High PageRank (unblocks the future).
  - **Risk Reduction**: High Betweenness Centrality (bridges silos).
  - **Value Delivery**: High Hub scores (Epics aggregating value).

## 2. Claim & Execute

Lock the task to prevent coordination conflicts in a swarm.

- `bd update <ID> --status in_progress --assignee self`
- `bd show <ID> --json`: Read description, parent epics, and comments.

## 3. Organic Discovery (Genealogy)

If you find a bug or missing requirement during execution, do NOT hold it in your context window.

- `bd create "Title" --deps discovered-from:<Current-ID>`
- `bd dep add <New-ID> <Current-ID>`: If it blocks you.

## 4. Finalize (The Landing)

- `bd update <ID> --status closed`: Mark as done.
- commit the change using the project's VCS.
