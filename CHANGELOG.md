## 0.1.58

*   **Terms of Service & Privacy Policy Limits**:
    *   Increased the maximum character limits for Terms of Service and Privacy Policy (`maxTermsLength` and `maxPrivacyLength` in `HyttaHubLimits`) from 10,000 to 50,000 characters.


## 0.1.57

*   **Multi-Lingual Terms of Service & Privacy Policy**:
    *   Added support for localized legal documents using Markdown-style language delimiters (e.g., `### en ###`, `### nb ###`).
    *   Implemented `getLocalizedContent` inside `localization_utils.dart` to parse localized sections with robust fallbacks (direct language match → English → first defined section → entire text).
    *   Updated `ServiceTermsDisplay` and `ServicePrivacyDisplay` to watch the active language from `LanguageCubit` and display only the relevant localized section.
    *   Added comprehensive parser tests in `localization_utils_test.dart`.
*   **Consumer Default Language**:
    *   Added support for a consumer default language (`AppLanguage`) configurable in `HyttaHubOptions.defaultLanguage`.
    *   Ensured that if a default language is not set, English (`AppLanguage.en`) is used as the global fallback.
*   **Terms of Service Dialog Fix**:
    *   Fixed a race condition during login where the Terms of Service update dialog is displayed as account events are still being read, causing an event version mismatch.
    *   Resolved the bug by watching the account state dynamically instead of reading it at a static point in time.
*   **PocketBase Integration Improvements**:
    *   Updated the PocketBase client dependency to v0.1.4.
    *   Optimized `setDocument` by removing an unnecessary get call, aligning with the flattened schema design where `setDocument` is strictly used for creation and `updateDocument` for updates.
*   **Maintenance**:
    *   Updated version metadata and dependencies to support the 0.1.57 release.
## 0.1.56

*   **Robust Service Admin Authentication**:
    *   Introduced a `serviceLogin` parameter in `AuthBloc` to explicitly initialize and persist the `isServiceAdmin` state.
    *   Updated route definitions (`serviceAdminProviderShellRoute` and `serviceUserProviderShellRoute`) to enforce correct configuration, preventing admin state leakage and ensuring reliable session isolation.
*   **In-Memory Storage Stability**:
    *   Added a null-safety guard for `docId` within the `InMemoryHyttaHubStorage` updates listener to gracefully handle event updates lacking a document ID.
*   **Maintenance**:
    *   Updated version metadata and dependencies to support the 0.1.56 release.

## 0.1.55

*   **Web Renderer & Browser Detection**:
    *   Added runtime detection for the active Flutter web renderer (Skwasm, CanvasKit, or JS/HTML).
    *   Added browser detection to identify if the app is running in Chrome vs. other browsers.
    *   Displayed this information in the `HyttaHubInfoPage` for improved debugging and environment awareness on the web.
*   **Flexible Isolate Configuration**:
    *   Introduced a global `useIsolates` flag in `HyttaHubOptions` to allow controlling the use of background isolates for computationally intensive tasks like replay logic.
    *   Enabled conditional disabling of isolates in the web environment to ensure compatibility across a wider range of browsers and hosting configurations.
*   **UI Customization**:
    *   Added configuration options to the `HyttaHubAppBarActions` widget to toggle the visibility of the Language, Theme, and Platform pickers.
    *   Provides developers with greater control over the app bar interface, allowing them to hide controls that are not relevant to their deployment.
*   **Maintenance**:
    *   Updated version metadata to reflect the v0.1.55 release.

## 0.1.54

*   **Standardized Terminology ("Hub" Strategy)**:
    *   Transitioned the entire application from "Site" terminology to the more generic and versatile **"Hub"**.
    *   Implemented a "Lite" localization strategy that removes redundant nouns where the UI context is clear (e.g., "Site Name" → "Name", "Leave Site" → "Leave").
    *   Applied these changes consistently across all supported languages (English, Spanish, Italian, Norwegian, and Dutch).
*   **Localization & Internationalization Improvements**:
    *   Achieved 100% key coverage for all non-English localization files (`intl_es`, `intl_it`, `intl_nb`, `intl_nl`), resolving dozens of untranslated message warnings.
    *   Translated high-priority system screens, including the **Data Store Initialization** and **Service Admin** management flows.
    *   Fixed Dutch translation inaccuracies and mixed-language strings.
*   **Maintenance & Logic Cleanup**:
    *   Standardized storage deletion and cleanup logic across Firebase, PocketBase, and in-memory storage, ensuring `MarkForDeletion` documents are the single source of truth for cleanup tasks.
    *   Resolved Flutter `synthetic-package` deprecation warnings in `l10n.yaml` across the main project and all example apps.
    *   Updated `CHANGELOG.md` and version metadata to reflect the v0.1.54 release.

## 0.1.53

*   **Platform Abstraction Simplified**:
    *   Removed `HyttaHubFunctions` and `HyttaHubInternalStorage` abstractions. The framework has transitioned to a unified storage model, simplifying the implementation of new persistence layers.
    *   Updated `HyttaHubImplementationDescriptor` to remove deprecated `functionsBuilder` and `internalStorageBuilder`.
*   **Cross-Platform "Copy Site"**:
    *   Ported the "Copy Site" business logic from the PocketBase implementation into the core library.
    *   This feature is now natively supported across all platforms (Firebase, PocketBase, and In-Memory/Local Storage).
*   **Auth Architecture Refactor**:
    *   Decoupled `AuthBloc` from the global scope. It is now managed via `BlocProvider` and `PlatformCubit`, improving testability and resource management during logout/reset cycles.
*   **Enhanced Service Shell**:
    *   Split the `ServiceShell` into two distinct flows: **Service Admin Login** and **Normal Login**.
    *   Administrative replay events and service-wide management features are now strictly isolated to the admin login flow.
*   **Site & Account Submit Improvements**:
    *   Refactored `SiteSubmitBloc` and `AccountSubmitBloc` to use standardized event submission patterns.
    *   Consolidated site event creation logic to ensure consistency between cloud and local storage modes.
*   **General Maintenance**:
    *   Updated internal dependencies and resolved lint warnings from the latest Flutter SDK.
    *   Added comprehensive unit tests for cross-platform site cloning (`copy_site_memory_test.dart`).

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
