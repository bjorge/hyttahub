## 0.2.0

* **Breaking: `reconnectRealtime()`**: `forceReconnect()` is now `reconnectRealtime()`, implementing the new `BaseHyttaHubStorage` member. `listenEvents` takes an `int Function()` version cursor rather than an `int`.
* **Event Loss on Seed**: `listenEvents` now subscribes before seeding. An event written while the seed fetch was in flight appeared in neither the snapshot nor the stream, and since later refetches filter on a version that subsequent events push past, it was unrecoverable. The seed is built from the floor captured before subscribing, so the overlap is re-emitted and the consumer de-duplicates.
* **Single Version Cursor**: Removed the watermark this package kept alongside the consumer's. The two could drift, and the class of bug where the storage advanced past an event the consumer never processed is now unrepresentable rather than merely fixed.
* **Server-Side Version Filter**: `getCollection` applies the new `newerThan` bound as a PocketBase filter term, so a long event log is no longer transferred in full on every seed, reconnect and gap fill. The field name is rejected unless it is a plain identifier, since it is interpolated as a bare identifier and cannot be quoted the way values are.
* **Shared SSE Connection**: Reconnect state is now tracked per `PocketBase` client rather than per storage instance. The Dart SDK multiplexes every subscription over one `SseClient` and only closes it when all topics are removed, so one listener re-subscribing on its own reused the dead connection — reconnects have to be client-wide.
* **Reconnect Bookkeeping**: `reconnectRealtime()` waits for its restarts rather than just the teardown, so a second reconnect mid-restart cannot wipe subscriptions still being established. A restart arriving while a listener is connecting is queued instead of dropped, and an auth error no longer latches the setup guard on and swallows every later reconnect. The post-reconnect catch-up retries on a backoff instead of making a single attempt and silently giving up.
* **Removed the Resync Heuristic**: The storage no longer infers a resync from a path being cancelled and re-listened within five seconds with more than one listener active. Consumers call `reconnectRealtime()` explicitly.
* **Testing**: Added unit tests for the reconnect state machine and integration tests driving the listeners against a fake SSE backend, covering subscribe-before-seed ordering, reconnects across storages sharing a client, restart queueing, and the version filter reaching the wire.
* **Dependency Update**: Upgraded `hyttahub` dependency constraint to `^0.2.0`.

## 0.1.8

* **Dependency Update**: Upgraded `hyttahub` dependency constraint to `^0.1.60`.

## 0.1.7

* **Query Projection & Result Limiting in `getCollection`**: Added support for `limit` and `fields` parameters in `getCollection()`, allowing callers to cap the maximum number of returned records (`perPage`) and select specific fields (`fields`) to optimize network payload size.
* **Batch Operation Support**: Implemented `runBatch` and `PocketbaseHyttaHubBatch` leveraging PocketBase's transactional batch service (`createBatch()`) to perform queued document creations (`setDocument`) and updates (`updateDocument`) in a single HTTP batch request (`/api/batch`).
* **Unit Testing for Batches**: Added unit tests verifying `runBatch` HTTP requests, payload encoding, and handling of empty batch operations.
* **PocketBase Emulator Upgrade**: Upgraded local emulator server (`tool/pocketbase_emulator`) to PocketBase `v0.39.9` and Go `1.25.0`, adapting route interceptors, schema creation hooks, and access rules (`rules.json`) to the v0.39 API contract.
* **Emulator Containerization**: Updated `Podmanfile` to build with `golang:1.25-alpine` and updated automated protobuf model code generation.

## 0.1.6

* **App Lifecycle Auto-Reconnect**: Added a lifecycle observer to automatically reconnect real-time subscriptions and catch up on state when the application is resumed (`AppLifecycleState.resumed`).
* **Subscription Leak Mitigation**: Fixed a race condition where cancelling a stream subscription before connection setup completes leaked the subscription on the server, causing subsequent subscription attempts to ignore events.
* **Transient Error Retries**: Introduced automatic retries with a backoff delay for transient network/socket exceptions during the initial real-time connection setup.

## 0.1.5

* **Server-Side Real-Time Filtering**: Added support for PocketBase server-side filtering (`info.filter`) during real-time subscriptions, reducing client-side network traffic and event processing by filtering events directly on the server.

## 0.1.4

* **Optimized Document Creation**: Removed the redundant lookup (`_findRecord`/`get` call) from both `setDocument` and the batch `setDocument` implementations. Under the flattened schema model, `setDocument` performs a clean `create` operation, while modifications are explicitly routed via `updateDocument`.

## 0.1.3

* **BREAKING CHANGE (Flat Schema Refactoring)**: Transitioned the PocketBase integration from a dynamic, on-demand collection creation model to a robust flat schema with a fixed set of 7 pre-configured collections (`hyttahub_site_users`, `hyttahub_service_users`, `hyttahub_beta_users`, `hyttahub_site_events`, `hyttahub_site_files`, `hyttahub_account_events`, `hyttahub_service_events`). Existing databases must be reset or migrated.
* **Path Introspection & Client Filtering**: Added `PathInfo` in Dart to automatically parse hierarchical paths, map them to flat collections, and populate parent identifiers (`app`, `siteId`, `accountId`, `serviceId`) as fields in the record. Implemented real-time client-side SSE filtering using these fields.
* **Custom Collections Support**: Added support for consumers to register custom flat collections via `PathInfo.customParsers`.
* **Robust Security & Rules**: Added a deletion rule to `ColAccountEvents` allowing authenticated users to delete their own account events. Restructured emulator creation hooks, test suites, cascading deletion logic, and site-copy/import flows to seamlessly support the flat schema.
* **Developer Tooling**: Added `start_podman.sh` script to quickly start the PocketBase emulator via podman.

## 0.1.2

* **Performance Optimization**: Implemented incremental collection updates in `PocketbaseHyttaHubStorage`. Real-time subscriptions now update individual records in memory rather than re-fetching the entire collection on every event.
* **Efficient Event Streaming**: Real-time event streams now process record data directly when available, reducing unnecessary network calls.
* **Robustness**: Maintained full-fetch fallbacks for all real-time listeners to ensure data consistency in edge cases.
* **Improved Logging**: Added detailed SSE event logging for better debugging in development mode.

## 0.1.1

* Added a per-subscription unsubscribe function to avoid cancelling other blocs' subscriptions on the same collection.
* Added experimental support for auto-join and anonymous login for PocketBase.

## 0.1.0

* Initial release. Simplified PocketBase implementations for `hyttahub` core storage and authentication.
* Supports real-time collection listening via PocketBase SSE.
* Cross-platform site cloning logic is now handled in core, making the PocketBase storage implementation more focused on data persistence.
