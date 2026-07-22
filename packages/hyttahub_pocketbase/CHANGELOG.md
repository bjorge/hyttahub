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
