# `bd` Ontology: The Graph Theory of Work

## 1. The Directed Acyclic Graph (DAG)

`beads` treats work as a graph, not a list. This allows for mathematical determination of what matters.

## 2. Dependency Semantics

- **blocks**: Hard constraint. Prerequisites.
- **related**: Contextual relevance. Soft link.
- **parent-child**: Hierarchy (Epics to Tasks).
- **discovered-from**: The "Audit Trail" of how work was found.

## 3. Computational Metrics

- **PageRank**: Measures "Foundation." A task is foundational if many things depend on it. High PageRank = "Build this first to unblock the rest."
- **Betweenness Centrality**: Measures "Bottlenecks." A node that acts as a bridge between separate clusters. High Betweenness = "High-risk gatekeeper."
- **Hubs & Authorities**:
  - **Authorities**: Critical utilities/infrastructure (depended on).
  - **Hubs**: Feature aggregates/Epics (depend on many).

## 4. Semantic Compaction

- Use `bd compact` to summarize old, closed tasks.
- Mimics biological memory decay: preserves structure (what was achieved) while shedding noise (individual sub-task logs).

## 5. Collision Resistance

- Identity is derived from content hashing (SHA-256).
- Truncated hashes (`bd-a1b2`) balance human readability with machine-grade collision avoidance.
- Enables multi-agent "Swarm" engineering without a central server.
