# Dioxus 0.7 Fullstack Reference

## 1. Server Functions

### Basic Usage
```rust
#[server]
async fn get_data(id: u32) -> Result<Data, ServerFnError> {
    Ok(database::fetch(id).await?)
}
```

### Protocol and Codec
Dioxus 0.7 defaults to JSON. You can customize:
```rust
#[server(protocol = Http<GetUrl, Json>)]
async fn search(query: String) -> Result<Vec<Result>, ServerFnError> { ... }
```

## 2. Real-time Communication

### Websockets
Strongly typed messaging:
```rust
#[get("/api/ws")]
async fn chat_ws(options: WebSocketOptions) -> Result<Websocket<ClientMsg, ServerMsg>> {
    Ok(options.on_upgrade(|mut socket| async move {
        while let Ok(msg) = socket.recv().await {
            socket.send(process(msg)).await.ok();
        }
    }))
}
```

### SSE & Unidirectional Streams
- `TextStream`: Perfect for LLM token streaming.
- `ByteStream`: For raw file/binary data.
- `FileStream`: Optimized for large transfers.

## 3. Streaming & Hydration

### Out-of-Order Streaming
```rust
ServeConfig::builder().enable_out_of_order_streaming()
```

### use_server_cached
Store a value on the server during SSR and retrieve it on the client without re-executing logic.
```rust
let data = use_server_cached("my-key", || compute());
```

## 4. Middleware & Security

### Axum Layers
```rust
dioxus::serve(|| async move {
    Ok(dioxus::server::router(app).layer(TraceLayer::new_for_http()))
});
```

### Route Middleware
Use `#[middleware]` attribute on server functions for endpoint-specific auth or rate limiting.

## 5. Static Site Generation (SSG)

### Setup
1. Enable `incremental` rendering in `ServeConfig`.
2. Define a server function at endpoint `"static_routes"`.
3. Return `Route::static_routes()`.
4. Build with `dx bundle --ssg`.

### Hybrid Mode
Dioxus SSG generates static HTML but hydrates into a full SPA — static SEO pages can have dynamic sub-regions.
