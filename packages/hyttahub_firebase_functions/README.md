# @hyttahub/firebase-functions

Firebase Cloud Functions implementation for the `hyttahub` package.

This package completes the implementation of the Firebase persistence abstraction for the Hyttahub framework. It provides the core backend logic required by the framework, including secure file storage management, automated site cleanup, and site copying functionality. 

Please note that these functions do not handle event sourcing logic directly; events are created and replayed within the client application, while Firebase serves as the central server-side storage and synchronization mechanism for those events.

## Installation

Install the package via npm in your Firebase functions directory:

```bash
npm install @hyttahub/firebase-functions
```

## Usage

In your Firebase Functions `index.ts` (or `index.js`), export the required Hyttahub cloud functions.

```typescript
import * as admin from "firebase-admin";

admin.initializeApp();

import {
  uploadFile,
  deleteFiles,
  getFile,
// Re-export them for Firebase to discover and deploy
export {
  uploadFile,
  deleteFiles,
  getFile,
  copySite,
  processMarkForDeleteRecords,
  listSiteFiles,
  autoJoinOnMemberAdded,
  onAccountCreated,
};
```

## Archive Storage (Optional)

To enable automatic archiving of uploaded files to a separate GCS bucket (e.g., one configured with the "Archive" storage class for lower costs), call `setArchiveBucketName` in your `index.ts`:

```typescript
import { setArchiveBucketName } from "@hyttahub/firebase-functions";
setArchiveBucketName("your-project-archive");
```

**Behavior:**
- **Production**: When configured, every file uploaded via `uploadFile` is also saved to the specified archive bucket. If not configured, a log message is produced and the archive step is skipped.
- **Emulator**: Archive files are stored using a path-based approach (`archive_files/` prefix) within the default bucket, so no additional emulator configuration is needed.
- **Archive files are never deleted** — the `deleteFiles` function only removes files from the primary bucket.

> **Note:** You must create the archive bucket in the GCP Console and configure it with the desired storage class before deploying.

## Exported Functions & Features

The following features can be enabled by exporting their respective functions in your Firebase project. If you wish to disable a feature (such as auto-joining), simply omit it from your `exports`.

### File Storage Management
*   **`uploadFile`**: Handles secure file uploads via a callable HTTPS function. Verifies that the user is an authenticated member of the target site before providing a signed upload URL or directly uploading the file (in emulator mode).
*   **`getFile`**: Generates a secure, expiring signed URL for downloading a specific file, ensuring the requester is an authorized member of the site.
*   **`deleteFiles`**: Allows authorized site members to batch-delete multiple files from Firebase Storage.
*   **`listSiteFiles`**: Retrieves a list of all files (and their sizes) associated with a specific site for an authorized member.

### Site Backups & Copying
*   **`copySite`**: A memory-intensive callable function that duplicates an entire site. It copies all events (up to an optional specified version), site storage files, adds a join event to the creator's account, and creates an `ImportEvent` on the new site.

### Housekeeping & Data Integrity
*   **`processMarkForDeleteRecords`**: A Firestore trigger that listens for users being marked for deletion/removal from a site. It processes the removal by adding `LeaveSite` or `RemoveSite` events to the site and account event logs, and then deletes the member record. It also handles automatic cascading deletion of the site data and storage files immediately when the final member has left.

### Auto-Join Behavior
*   **`autoJoinOnMemberAdded`**: A Firestore trigger that listens for new members being added to a site. If a user is added to a site by an admin, this function automatically creates a `joinSite` event in their account (and adds them to a service-level Bloom filter for beta access, if enabled). 
    *   *Note: Do not export this function if you want users to manually accept invites instead.*
*   **`onAccountCreated`**: A trigger that fires when a new user account is first initialized. It scans all existing sites to see if the user was pre-invited before their account existed, and automatically generates `joinSite` events for all matching sites.
    *   *Note: Do not export this function if you want users to manually accept invites instead.*

## Development

Instructions for building and testing the functions locally:

```bash
# Install dependencies
npm install

# Build the TypeScript code
npm run build

# Run tests
npm test

```
