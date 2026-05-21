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
