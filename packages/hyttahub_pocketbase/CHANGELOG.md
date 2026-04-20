## 0.1.1

* Added a per-subscription unsubscribe function to avoid cancelling other blocs' subscriptions on the same collection.
* Added experimental support for auto-join and anonymous login for PocketBase.

## 0.1.0

* Initial release. Simplified PocketBase implementations for `hyttahub` core storage and authentication.
* Supports real-time collection listening via PocketBase SSE.
* Cross-platform site cloning logic is now handled in core, making the PocketBase storage implementation more focused on data persistence.
