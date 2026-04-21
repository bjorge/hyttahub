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
