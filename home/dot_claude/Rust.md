# Rust Conventions

- **Error handling:** `thiserror` for library crates, `anyhow` for binary crates
- **Testing:** Use `cargo-nextest` as the test runner; `cargo-insta` for snapshot testing (larger/structured output), regular assertions for simple checks
- **Workspace dependencies:** Define all deps in root `Cargo.toml` under `[workspace.dependencies]`; individual crates use `crate-name.workspace = true`
  - Version-only deps: inline format (`anyhow = "1.0.100"`)
  - Deps with features: section format:

```toml
[workspace.dependencies.uuid]
version = "1"
features = ["v4", "serde"]
```
