---
name: dioxus-modern
description: Modern Dioxus 0.7 + Tailwind CSS development guide. Use when asking about Signals, Stores, ReadSignal props, async patterns, components, or Tailwind integration in Dioxus 0.7.
argument-hint: [dioxus question, component pattern, state management, tailwind setup, async data fetching]
user-invocable: true
version: 1.9.0
---

# Modern Dioxus 0.7 Guide

Dioxus 0.7 is a massive leap forward in Rust UI development, focusing on **Copy signals**, **fine-grained reactivity**, and **automatic asset handling**.

## Core Architecture

1. **Reactivity**: Built on Signals and Stores. State is `Copy + Send + Sync`.
2. **Fullstack**: Unified server/client code with `#[server]` functions and `use_server_future`.
3. **Styling**: Native Tailwind CSS integration using the `dx` CLI.
4. **Performance**: Sub-second hot-patching and WASM bundle splitting.

## Rules
- Use `use_signal` for atomic values, `use_store` with `#[derive(Store)]` for collections/nested state. Never use `use_state` in 0.7.
- Use `ReadSignal<T>` for component props that receive reactive values.
- Always use `#[component]` macro. Components are memoized by default.
- Dioxus 0.7 has automatic Tailwind integration. Use `asset!("/assets/tailwind.css")` via `document::Stylesheet` and run `dx serve`.
- Use `use_resource` for async state. Use `use_server_future` for hydration-safe data. Avoid waterfalls by starting all requests first.

## Workflow
1. Identify state container (Signal vs Store)
2. Define props using ReadSignal
3. Implement UI with rsx! macro
4. Style with Tailwind class strings
5. Add async data with use_resource

## CLI Cheat Sheet

```bash
dx new          # Create new project
dx serve        # Start dev server with hot-reload
dx bundle       # Build for production
dx translate    # Convert HTML to RSX
```

## Support Files

- **reference.md**: Hook API reference, key types, events, macros, patterns, anti-patterns
- **fullstack.md**: Server functions, WebSockets, SSE streaming, middleware, SSG
- **templates.md**: Reusable code templates (Store list, WebSocket, TextStream, SSG, custom hooks)
- **examples.md**: Before/after examples
- **migration.md**: Upgrading from 0.5/0.6, breaking changes checklist
