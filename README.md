<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A serverless Flutter framework designed to be a solid starting point for new applications, demonstrated with a sample photo album app.

--  **Note:** Under construction, breaking changes may occur.

## Features

-   **Terms of Service & Privacy Policy:** A complete flow for presenting and requiring user acceptance of legal terms, including versioning for updates.
-   **Service Status & Forced Upgrades:** The ability to set a minimum required application version or disable the service for maintenance, and communicate this to users.
-   **Account Deletion:** A clear, user-accessible path for account deletion, a common requirement.
-   **Localization:** Support for multiple languages.
-   **Theming:** Dynamic light and dark mode support.
-   **Beta Users:** Limit access to a set of users.
-   **Service Users:** Manage the users than can maintain policies and service status.
-   **Shared Site (Resource) Management:** The common application use case of members sharing a common resource, or "site", such as a set of photo albums, a calendar, etc., is supported. The framework includes adding and removing members from a site, and self-removal. Site members can be assigned administrative roles as well. Firebase rules ensure site privacy.
-   **Export & Import:** Export a site backup and import a site backup.
-   **Event Source Framework Replayed in the Client:** The common practice of having separate models for forms in the UI, network marshalling, database and business logic is eliminated, thus reducing boilerplate code and eliminating app logic on the server side. Some cloud functions are included to assist in cleanup upon account deletion. Events are persisted on the client thus reducing significantly service queries.
-   **Event and Replay Views:** Service, account and site events and replays can be viewed in the UI.

## Usage

The repo includes examples for using the library. Follow the instructions below.

### Prerequisites

-   Install flutter with Chrome support
    - Run "flutter doctor" and make sure the version is minimum 3.32.1, and Chrome is enabled (or run "flutter --version" and "flutter devices")

-   Install either docker or podman

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone git@github.com:bjorge/hyttahub.git
    cd hyttahub
    ```

2.  **Start the firebase emulator (docker/podman):**
    ```sh
    cd tools/firebase_emulator
    ```
    Use the [`README`](tools/firebase_emulator/README) in the `tools/firebase_emulator` directory a guide for starting the emulator.

### Running the Application

```sh
# Once the firebase emulator is running, in a separate terminal cd to the examples/albums directory, then run:
flutter run -d chrome
```

## FAQ

**I want to make some changes to the language files, how do I compile them?**

After updating the `.arb` files, run:

```sh
flutter gen-l10n
```

**How do I tag a new release?**

```sh
git tag v0.1.9
push origin --tags
```

**How do I compile the protocol buffer files?**

Protocol buffer files can be compiled for both Dart (flutter) and TypeScript (cloud functions) using Podman or Docker. See [`README`](tools/protobuf-compiler/README) in the `tools/protobuf-compiler` directory for instructions.

**Is any server-side code required for this project?**

The intent is to use Cloud Functions sparingly—only when necessary to provide access to parts of the system that are inaccessible to the client due to Firebase rules. For example, when a site admin removes a member, a Cloud Function will also add a "remove" event to that member's account stream (which the admin cannot access directly). Cloud Functions are also used for cleanup tasks, such as removing abandoned site data when the last member leaves a site.

**How is shared member data kept private?**

Firebase rules, defined in [`firestore.rules`](tools/firebase_emulator/firestore.rules) and [`storage.rules`](tools/firebase_emulator/storage.rules), are designed to ensure member data privacy. Only site members are permitted to access site data, and only administrators can add new members. Likewise, only the owner of an account can modify their account settings, and only a service administrator can update the service status.

**Can I add social authentication, such as Google or Apple logins?**

The current implementation uses email as a key in Firebase rules and site member management. Firebase auth options that retain the user's email will work. For Apple, since users can anonymize their email, changes would have to be made to accomodate for this case.
