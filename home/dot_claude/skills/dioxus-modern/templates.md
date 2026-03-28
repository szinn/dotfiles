# Dioxus 0.7 Modern Templates

## 1. High-Performance Store List

```rust
#[derive(Store, Default, Clone, PartialEq)]
struct AppState { users: Vec<User> }

#[component]
fn UserList(state: Store<AppState>) -> Element {
    rsx! {
        ul {
            // Each user gets its own sub-signal; only that <li> re-renders on update
            for user in state.users().iter() {
                UserItem { user }
            }
        }
    }
}

#[component]
fn UserItem(user: ReadSignal<User>) -> Element {
    rsx! { li { "{user.read().name}" } }
}
```

## 2. Bi-directional WebSocket App

```rust
#[derive(Serialize, Deserialize)]
enum Msg { Chat(String), Join(String) }

#[component]
fn Chat() -> Element {
    let mut socket = use_websocket(|| connect_chat(WebsocketOptions::new()));

    rsx! {
        div { "Status: {socket.status():?}" }
        button {
            onclick: move |_| async move { socket.send(Msg::Chat("Hi".into())).await; },
            "Send Hi"
        }
    }
}

#[server]
async fn connect_chat(o: WebsocketOptions) -> Result<Websocket<Msg, Msg>, ServerFnError> {
    Ok(o.on_upgrade(|mut ws| async move {
        while let Ok(msg) = ws.recv().await {
            ws.send(msg).await.ok();
        }
    }))
}
```

## 3. Streaming Text (LLM UI)

```rust
#[component]
fn AIResponse() -> Element {
    let response = use_resource(|| stream_answer("Explain Dioxus"));
    let mut text = use_signal(String::new);

    use_future(move || async move {
        if let Some(Ok(mut stream)) = response.read().as_ref() {
            while let Some(chunk) = stream.next().await {
                text.write().push_str(&chunk);
            }
        }
    });

    rsx! { div { "{text}" } }
}

#[server]
async fn stream_answer(q: String) -> Result<TextStream, ServerFnError> {
    Ok(TextStream::spawn(|tx| async move {
        for word in ["Dioxus ", "is ", "fast!"] {
            tx.unbounded_send(word.to_string()).ok();
            tokio::time::sleep(Duration::from_millis(100)).await;
        }
    }))
}
```

## 4. Static Site Generation Endpoint

```rust
#[derive(Routable, Clone, PartialEq)]
enum Route {
    #[route("/")] Index {},
    #[route("/blog")] Blog {},
}

#[server(endpoint = "static_routes", output = server_fn::codec::Json)]
async fn static_routes() -> Result<Vec<String>, ServerFnError> {
    Ok(Route::static_routes().iter().map(|r| r.to_string()).collect())
}
```

## 5. Native Launch with Host

```rust
fn main() {
    #[cfg(not(feature = "server"))]
    dioxus::fullstack::set_server_url("https://my-api.com");

    dioxus::LaunchBuilder::new()
        .with_context(server_only! {
            ServeConfig::builder().enable_out_of_order_streaming()
        })
        .launch(App);
}
```

## 6. Custom Hook Template

```rust
fn use_persistent_signal<T: Serialize + DeserializeOwned + Default + 'static>(
    key: &str,
) -> Signal<T> {
    let state = use_signal(|| {
        LocalStorage::get(key).unwrap_or_default()
    });

    use_effect(move || {
        LocalStorage::set(key, &state());
    });

    state
}
```
