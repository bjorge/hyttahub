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
