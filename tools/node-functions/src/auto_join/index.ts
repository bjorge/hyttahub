import { admin } from "../shared/firebase";
import * as logger from "firebase-functions/logger";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { AccountEvent } from "../ts/account_events";
import { FieldValue } from "firebase-admin/firestore";
import {
  firebaseAccountEventsPath,
  fbPayload,
  fbVersion,
  fbTimeStamp,
} from "../shared/constants";

/**
 * Cloud function that listens for a new member being added to a site.
 * When a document is created in `hyttahub/{appPathSegment}/sites/{siteId}/site_users/{email}`,
 * it automatically adds a `joinSite` event to the user's account if they aren't already joined.
 */
export const autoJoinOnMemberAdded = onDocumentCreated(
  "hyttahub/{appPathSegment}/sites/{siteId}/site_users/{email}",
  async (event) => {
    const { appPathSegment, siteId, email } = event.params;

    logger.info(`Auto-join triggered for ${email} on site ${siteId} (app: ${appPathSegment})`);

    try {
      const accountEventsRef = admin
        .firestore()
        .collection(firebaseAccountEventsPath(appPathSegment, email));

      // Fetch all account events to determine current state
      const snapshot = await accountEventsRef.orderBy(fbVersion, "asc").get();
      
      let isJoined = false;
      let lastVersion = 0;

      logger.info(`Fetched ${snapshot.size} account events for ${email}`);

      snapshot.docs.forEach((doc) => {
        const data = doc.data();
        const version = data[fbVersion];
        if (typeof version === "number" && version > lastVersion) {
          lastVersion = version;
        }

        if (data[fbPayload] && typeof data[fbPayload] === "string") {
          try {
            const buffer = Buffer.from(data[fbPayload], "base64");
            const accountEvent = AccountEvent.decode(buffer);

            if (accountEvent.joinSite === siteId || accountEvent.createSite === siteId) {
              isJoined = true;
            } else if (accountEvent.leaveSite === siteId || accountEvent.removeSite === siteId) {
              isJoined = false;
            }
          } catch (e) {
            logger.error(`Failed to decode account event for ${email} at version ${version}`, e);
          }
        }
      });

      logger.info(`Current status for ${email} on site ${siteId}: ${isJoined ? "Already joined" : "Not joined"}`);

      if (!isJoined) {
        const newVersion = lastVersion + 1;
        const newEvent: AccountEvent = {
          version: newVersion,
          joinSite: siteId,
        };

        const buffer = AccountEvent.encode(newEvent).finish();
        const base64Payload = Buffer.from(buffer).toString("base64");

        await accountEventsRef.doc(String(newVersion)).set({
          [fbPayload]: base64Payload,
          [fbVersion]: newVersion,
          [fbTimeStamp]: FieldValue.serverTimestamp(),
        });

        logger.info(`Successfully auto-joined ${email} to ${siteId} with version ${newVersion}`);
      } else {
        logger.info(`Skipping auto-join for ${email} as they are already a member of ${siteId}`);
      }
    } catch (error) {
      logger.error(`Error in autoJoinOnMemberAdded for ${email} on site ${siteId}:`, error);
    }
  }
);
