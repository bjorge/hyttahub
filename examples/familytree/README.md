# Hytta Hub Family Tree

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter framework designed to be a solid starting point for new applications, demonstrated with a sample photo album app.

## ✨ Key Features

-   **Localization:** Support for multiple languages.
-   **Theming:** Dynamic light and dark mode support.
-   **Robust Navigation:** A clear router stack (`landing` -> `service` -> `account` -> `app`) managed by `go_router`.
-   **Clean Architecture:** A streamlined design with minimal boilerplate and a unified data model (see Architecture section).
-   **Store-Ready Features:** Built-in support for common application lifecycle and store-publishing requirements (see Core Application Features).

## Core Application Features

This framework provides implementations for common application lifecycle and store-publishing requirements:

-   **Terms of Service & Privacy Policy:** A complete flow for presenting and requiring user acceptance of legal terms, including versioning for updates.
-   **Service Status & Forced Upgrades:** The ability to set a minimum required application version or disable the service for maintenance, and communicate this to users.
-   **Account Deletion:** A clear, user-accessible path for account deletion, a common requirement for app stores.
-   **User Flow:** Full account creation, login, and site management.

## 🏁 Getting Started

### Prerequisites

-   Install flutter with Chrome support
    - Run "flutter doctor" and make sure the version is minimum 3.32.1, and Chrome is enabled (or run "flutter --version" and "flutter devices")

-   Install either docker or podman

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone git@github.com:bjorge/flutter_framework.git
    cd flutter_framework
    ```

2.  **Start the firebase emulator (docker/podman):**
    ```sh
    cd dev_tools/firebase_emulator
    # Follow the README file in the dev_tools/firebase_emulator directory
    ```

### Running the Application

```sh
# In the flutter_framework directory
flutter run -d chrome
```

## 🗺️ Router Stack

Navigation is managed by `go_router` and follows a clear, hierarchical structure.

-   `/` (**Landing**): Language and theme selection (persisted locally).
-   `/userlogin` (**User Login**): Handles user authentication.
    -   `/userlogin/account` (**Account**):
        -   View list of sites.
        -   Accept updated Terms of Service.
        -   Manage account settings (e.g., deletion).
        -   `/userlogin/account/site/:siteId` (**Site**):
            -   View and manage a specific site's family tree.
-   `/servicelogin` (**Service Login**): Admin login for service management.
    -   `/servicelogin/service` (**Service Admin**):
        -   Manage service status (maintenance, required upgrades).
        -   Update Terms of Service and Privacy Policy.

## 🏛️ Architecture

This project is built on a foundation of event sourcing using Firebase Firestore as the event store.

### Unified Data Model with Protobuf

A key architectural principle of this framework is the use of a single, unified data model powered by Protocol Buffers. The `protobuf` definitions serve as the single source of truth for all event and state structures.

-   **No Marshalling:** The same generated `protobuf` class that represents an event in the database is the exact same object used to manage state within a form's `SubmitBloc`.
-   **End-to-End Consistency:** This creates a seamless flow of data from the user interface, through the business logic, to the database, and back to the state replay system without any need for data transformation or mapping between different models.
-   **Reduced Complexity:** By eliminating the common practice of having separate models for the database, business logic, and UI, the framework significantly reduces boilerplate code and potential sources of error.

### Event Sourcing with `BaseReplayBloc`

Instead of storing the current state of the application directly, we store a sequence of events. The application state is reconstructed by replaying these events. This is managed by the `BaseReplayBloc`.

-   **Data Integrity:** Events are immutable, providing a complete and auditable history of changes.
-   **State Management:** The client streams events from Firebase and replays them to build the current state. This is highly efficient and scalable.
-   **Resilience:** The use of `HydratedBloc` caches events locally. Only the latest events are downloaded from firebase.

### Why Protocol Buffers?

Protocol Buffers (`protobuf`) are used for defining BLoC states, events, and data models.

-   **Type Safety:** `protobuf` provides strict typing across the entire stack, from the Flutter client to the Node.js Cloud Functions.
-   **Efficiency:** They produce small, binary payloads, which are ideal for network transmission and storage in Firestore.
-   **Immutability:** Generated `protobuf` objects in Dart can be frozen (`..freeze()`), which helps enforce unidirectional data flow and prevents accidental state mutations within the UI layer.
-   **Automatic Equality:** Generated classes come with `==` and `hashCode` implementations, simplifying state comparisons in BLoC.
-   **Code Generation:** The `protoc` compiler automatically generates data classes (models) and the necessary serialization/deserialization logic, removing the manual boilerplate code required for data handling.
-   **Cross-Language Compatibility:** Protocol Buffers can be compiled to many languages supported by cloud functions, such as TypeScript or Go. This means data stored by the client in protobuf format can be directly interpreted and used by backend cloud functions, enabling seamless, type-safe integration between your Flutter app and server-side logic.

## ❓ FAQ

**How do I compile the language files?**

After updating the `.arb` files, run:

```sh
flutter gen-l10n
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

The current code uses email as a key in Firebase rules and site member management. Firebase auth options that retain the user's email will work. For Apple, since users can anonymize their email, changes would have to be made to accomodate for this case.


