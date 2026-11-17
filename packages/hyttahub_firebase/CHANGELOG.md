## 0.2.0

* **Breaking: Storage Interface**: Implemented `reconnectRealtime()` as a no-op — the Firestore SDK owns its own connection and resumes its listeners, so there is no transport for a caller to re-establish. `listenEvents` takes an `int Function()` version cursor rather than an `int`.
* **Version-Bounded Reads**: `getCollection` applies the new `newerThan` bound as a `where(field, isGreaterThan:)` clause, matching what `listenEvents` already did for its query. Note that Firestore requires the first ordering to match the inequality field, so combining `newerThan` with an `orderBy` on a different field will be rejected.
* **Dependency Update**: Upgraded `hyttahub` dependency constraint to `^0.2.0`.

## 0.1.2

* Removed functions and internal storage abstractions as they are no longer used by the core framework.
* Simplified persistence implementation to focus on Firestore and Authentication.
* Updated platform initialization to align with the core hyttahub storage model.
* Ports for "Copy Site" logic from PocketBase are now completed and ready for manual testing.
* Eliminated hard-coded paths within the package.

## 0.1.1

*   Implemented `deleteCollection` in `FirestoreHyttaHubStorage` to support thorough data cleanup (e.g., account events removal).
*   Upgraded dependency on `hyttahub` to `^0.1.52`.

## 0.1.0

* Initial release. Extracted from the `hyttahub` core package examples.
