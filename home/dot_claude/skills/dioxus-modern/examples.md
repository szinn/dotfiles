# Dioxus 0.7 Modern Examples

## Good: Signal State

```rust
let mut count = use_signal(|| 0);
rsx! { h1 { "Count: {count}" } }
```
Signals are Copy + Send + Sync, no lifetime issues.

## Bad: use_state (Legacy)

```rust
let mut count = use_state(|| 0);  // ❌ Don't use in 0.7
```
`use_state` is legacy API in Dioxus 0.7.

---

## Good: ReadSignal Props

```rust
#[component]
fn Display<T: PartialEq>(value: ReadSignal<T>) -> Element {
    rsx! { "{value}" }
}

// Can pass Signal, Memo, Resource, or computed value
Display { value: my_signal }
Display { value: my_memo }
Display { value: expensive_computation() }
```
`ReadSignal` accepts any reactive type with auto-conversion.

## Bad: Mutable Props

```rust
#[component]
fn Incrementer(mut sig: Signal<i32>) -> Element {  // ❌
    rsx! { button { onclick: move |_| sig += 1 } }
}
```
Breaks one-way data flow. Use callbacks instead.

---

## Good: Async with use_resource

```rust
fn use_user_data(user_id: Signal<u32>) -> Resource<User> {
    use_resource(move || async move {
        let response = reqwest::get(format!(
            "https://api.example.com/users/{}",
            user_id()
        )).await?;
        response.json::<User>().await
    })
}

rsx! {
    if let Some(result) = &*user_data.read() {
        match result {
            Ok(user) => rsx! { "{user.name}" },
            Err(e) => rsx! { "Error: {e}" },
        }
    } else {
        "Loading..."
    }
}
```
Automatically subscribes to signal changes, handles loading/error states.

---

## Good: Avoiding Waterfalls

```rust
// Start all requests first
let item1 = use_resource(fetch_item_1);
let item2 = use_resource(fetch_item_2);

// Process results after all requests started
let data1 = item1.suspend()?;
let data2 = item2.suspend()?;

rsx! { Item { data1 } Item { data2 } }
```
All requests execute in parallel.
