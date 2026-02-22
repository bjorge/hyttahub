import * as admin from "firebase-admin";

/**
 * Initializes the Firebase Admin SDK, ensuring it's only done once.
 * This prevents the "The default Firebase app already exists" error.
 */
if (admin.apps.length === 0) {
  admin.initializeApp();
}

// Export the initialized admin instance for use in other modules.
export { admin };