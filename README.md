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

A Flutter framework designed to be a solid starting point for new applications, demonstrated with a sample photo album app.

## Features

-   **Terms of Service & Privacy Policy:** A complete flow for presenting and requiring user acceptance of legal terms, including versioning for updates.
-   **Service Status & Forced Upgrades:** The ability to set a minimum required application version or disable the service for maintenance, and communicate this to users.
-   **Account Deletion:** A clear, user-accessible path for account deletion, a common requirement.
-   **Localization:** Support for multiple languages.
-   **Theming:** Dynamic light and dark mode support.
-   **Shared Site (Resource) Management:** The common application use case of members sharing a common resource, or "site", such as a set of photo albums, a calendar, etc., is supported. The framework includes adding and removing members from a site, and self-removal. Site members can be assigned administrative roles as well. Firebase rules ensure site privacy.
-   **Event Source Framework Replayed in the Client:** The common practice of having separate models for forms in the UI, network marshalling, database and business logic is eliminated, thus reducing boilerplate code and eliminating app logic on the server side. A couple cloud functions are included to assist in cleanup upon account deletion. Events are persisted on the client thus reducing significantly service queries.

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
    cd exmple/familytree/tools/firebase_emulator
    # Follow the README file in the tools/firebase_emulator directory
    ```

### Running the Application

```sh
# In the familytree directory
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

Protocol buffer files can be compiled for both Dart and TypeScript using Podman or Docker. See the README in [`dev_tools/protobuf-compiler`](dev_tools/protobuf-compiler) for instructions.

**Is any server-side code required for this project?**

The intent is to use Cloud Functions sparingly—only when necessary to provide access to parts of the system that are inaccessible to the client due to Firebase rules. For example, when a site admin removes a member, a Cloud Function will also add a "remove" event to that member's account stream (which the admin cannot access directly). Cloud Functions are also used for cleanup tasks, such as removing abandoned site data when the last member leaves a site.

**How is shared member data kept private?**

Firebase rules, defined in [`firestore.rules`](firestore.rules) and [`storage.rules`](storage.rules), are designed to ensure member data privacy. Only site members are permitted to access site data, and only administrators can add new members. Likewise, only the owner of an account can modify their account settings, and only a service administrator can update the service status.

**Can a hacker mess up site data without server-side validation?**

Due to Firebase rules, only a site member could potentially upload invalid data, and only within the scope of their site. For higher security, you can add cloud functions to validate events uploaded from clients.

**Can I add social authentication, such as Google or Apple logins?**

The current implementation uses email as a key in Firebase rules and site member management. Firebase auth options that retain the user's email will work. For Apple, since users can anonymize their email, changes would have to be made to accomodate for this case.
