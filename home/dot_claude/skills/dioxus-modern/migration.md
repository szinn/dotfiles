# Dioxus Migration Guide

## 0.5/0.6 → 0.7 Breaking Changes

### 1. dioxus-lib Removed
```rust
// 0.5/0.6
use dioxus_lib::prelude::*;

// 0.7
use dioxus::prelude::*;
```

### 2. Form Submission Behavior
```rust
// 0.6: Forms didn't submit by default
form { onsubmit: |e| {} }

// 0.7: Forms submit by default, call prevent_default() to prevent
form { onsubmit: |e| e.prevent_default() }
```

### 3. Asset Options API
```rust
// 0.6
asset!("/image.png", ImageAssetOptions::new().with_size(size))

// 0.7
asset!("/image.png", AssetOptions::image().with_size(size))
```

### 4. Server Function Codec
```rust
// 0.6: URL-encoded form data by default
#[server]
async fn my_function(arg: MyStruct) -> ServerFnResult<MyResponse> { ... }

// 0.7: JSON by default
#[server(protocol = Http<GetUrl, Json>)]  // Explicit if needed
async fn my_function(arg: MyStruct) -> ServerFnResult<MyResponse> { ... }
```

### 5. Removed from Prelude
```rust
// These are no longer in dioxus::prelude:
use_drop
Runtime
queue_effect
provide_root_context
```

### 6. Owned Event Listener Type
Custom renderers should accept `impl SuperInto<ListenerCallback<$data>, __Marker>` instead of `EventHandler`.

## Migration Checklist

- [ ] Replace `dioxus_lib` with `dioxus`
- [ ] Add `e.prevent_default()` to form submissions
- [ ] Update asset options to use `AssetOptions::image()`
- [ ] Update server functions to use JSON codec
- [ ] Import removed items explicitly if used
- [ ] Update event handler types in custom renderers

## Testing After Migration

1. Run `cargo check` to catch compilation errors
2. Run `cargo clippy` to fix warnings
3. Test form submissions
4. Verify asset bundling
5. Check server function calls
