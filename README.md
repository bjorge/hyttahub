A serverless Flutter framework designed to be a solid starting point for new casual applications, demonstrated with an example app.

--  **Note:** Under construction; breaking changes may occur.

## Built-in Features


-   **Service Management**
    -   **Service Status & Forced Upgrades:** The ability to set a minimum required application version or disable the service for maintenance, and smoothly communicate this to users.
    -   **Service Administrators:** Manage the users who can maintain policies and service status.
    -   **Beta/Authorized Users:** Limit application access to a predefined set of regular users.
-   **GDPR and App Store Compliance**
    -   **Terms of Service & Privacy Policy:** A complete flow for presenting and requiring user acceptance of legal terms, including versioning for updates.
    -   **Account Deletion:** A clear, user-accessible path for account deletion.
    -   **User Data Access:** Since all the event source data is cached on the client, the user can export their data at any time. The application just needs to provide an export feature (example copy events to the clipboard). If the application supports media, then it can provide a way to export the media as well (according to its terms of service).
-   **App Appearance & Personalization**
    -   **Localization:** Support for multiple languages.
    -   **Theming:** Dynamic light and dark mode support.
-   **Collaboration & Core Features**
    -   **Shared Site (Resource) Management:** Supports the common application use case of members sharing a common resource, or "site" (such as a set of photo albums, a calendar, etc.). The framework manages adding and removing site members, as well as self-removal. Site members can be assigned administrative roles. Firebase rules ensure site data privacy.
-   **Clean Architecture**
    -   **Event Source Framework Replayed in the Client:** The common practice of having separate models for UI forms, network marshalling, database storage, and business logic is eliminated. This reduces boilerplate code and removes the need for app logic on the server side. Events are persisted on the client, significantly reducing service queries. Note: Some cloud functions are included to assist with cleanup upon account deletion.
    -   **Event and Replay Views:** Service, account, and site events (and their resulting replays) can be viewed directly in the UI, assisting with debugging without needing to access the backend services.
    -   **Persistence-Agnostic:** The framework is designed to support various storage providers (e.g., Firebase, Pocketbase) and allows switching between them at runtime. Built-in memory and local file storage are also supported out of the box.

## Usage

The repository includes examples of using the library. Follow the instructions below.

### Prerequisites

- Install Flutter with Chrome support.
- Run `flutter --version` to check your version. Ensure it is at least 3.32.1.
- Run `flutter devices` to check that Chrome is listed as an available device.

### Installation & Setup

```sh
git clone git@github.com:bjorge/hyttahub.git
cd hyttahub
flutter pub get
flutter test
```
### Running the Application

```sh
cd example/template
flutter run -d chrome
```

### Persistence Registration

HyttaHub is persistence-agnostic and uses a dynamic registration system. 

Please see [PERSISTENCE.md](PERSISTENCE.md) for details on how to register and use multiple storage providers.

## FAQ

**I want to make some changes to the language files, how do I compile them?**

After updating the `.arb` files, run:

```sh
flutter gen-l10n
```

**I want to run the example app using the Firebase Emulator, how do I do that?**

-   Install either Docker or Podman.
-   Follow the instructions in the [`README`](tool/firebase_emulator/README) found in the `tool/firebase_emulator` directory to set up and start the emulator (this will also start the cloud functions in the emulator).
-   In a separate terminal, navigate to the `example/template` folder and run:
    ```sh
    flutter run -d chrome
    ```
-   In the app, select "Firebase" as the storage implementation.

**How do I tag a new release?**

```sh
git tag v0.1.9
git push origin --tags
```

**How do I compile the protocol buffer files?**

Protocol buffer files can be compiled for both Dart (Flutter) and TypeScript (Cloud Functions) using Podman or Docker. See the [`README`](tool/protobuf-compiler/README) in the `tool/protobuf-compiler` directory for instructions.

**Is any server-side code required for this project?**

The project requires no long-running server-side code. As far as Cloud Functions go, the intent is to use them sparingly—only when absolutely necessary to provide access to parts of the system that are inaccessible to the client due to Firebase security rules. For example, when a site admin removes a member, a Cloud Function will securely add a "remove" event to that member's account stream (which the admin cannot access directly). Cloud Functions are also used for housekeeping tasks, such as removing abandoned site data when the last member leaves a site.

**How is shared member data kept private?**

Firebase rules, defined in [`firestore.rules`](tool/firebase_emulator/firestore.rules) and [`storage.rules`](tool/firebase_emulator/storage.rules), are designed to ensure member data privacy. Only site members are permitted to access site data, and only site administrators can add new members. Likewise, only the owner of an account can modify their account settings, and only a service administrator can update the global service status. In the case of Pocketbase, these same rules are coded into the go code that runs on the server.

**Can I add social authentication, such as Google or Apple logins?**

The current implementation uses email addresses as keys in Firebase rules and site-member management. Any Firebase Auth options that reliably retain the user's email will work natively. For Apple sign-ins, since users can choose to anonymize their email via a relay, changes would need to be made to the framework to accommodate that specific case.
