## 0.1.52

*   **Account Removal Improvements**:
    *   Fixed a navigation crash in `RemoveAccountScreen` by using absolute navigation instead of multiple back-pops.
    *   Restored account events cleanup during account removal; users' personal event logs are now properly deleted in all storage modes.
    *   Added `deleteCollection` method to `BaseHyttaHubStorage` to enable thorough data cleanup across storage implementations.
*   **In-Memory and Local Data Cleanup**:
    *   Implemented inline cleanup logic for `InMemoryHyttaHubStorage` and `HydratedHyttaHubStorage`.
    *   Added `cleanUpOrphanedSite` utility to ensure data consistency when members leave or are removed from a site in non-cloud modes.
    *   Improved GDPR compliance by ensuring site archive files and orphaned records are deleted during cleanup.
*   **Cloud & Firebase Functions**:
    *   Optimized Firebase Cloud Functions to reduce costs by introducing manual cleanup triggers for orphaned sites.
    *   Updated functions to use `admin.firestore().recursiveDelete()` for more reliable data clearing.
    *   Consolidated and simplified Firebase path constants and configuration.

## 0.1.51

* Prevent members from changing their own email on the Update Member screen; only another admin can change a member's email.
* Make the author of a copy-site (import event) an admin on the imported site.
* Cleaned up unused import in `add_member_screen.dart`.
* Example app improvements: added delete photo screen, updated favicons, cleaned up unused code and localization strings.

## 0.1.50

* Added `maxLength` constraints to all text input form fields via `BaseTextFormField`.
* Added centralized `HyttaHubLimits` constants class (`lib/utilities/constants.dart`) for input length limits and site caps.
* Limit users to a maximum of 20 sites; Create, Join, and Copy site options are greyed out when the limit is reached.
* Upgraded `protobuf` to `^6.0.0` and `protoc_plugin` to `^25.0.0`; regenerated all protobuf files.
* Upgraded `go_router` to `^17.1.0`.
* Added `WrappedRegExp` utility (`lib/utilities/pattern_utils.dart`) to avoid deprecated `RegExp` usage as `Pattern`.
* Fixed lint errors from latest Flutter SDK.

## 0.1.49

* Prepare package for pub.dev publication.
