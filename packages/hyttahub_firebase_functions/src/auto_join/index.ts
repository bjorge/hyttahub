import { admin } from "../shared/firebase";
import * as logger from "firebase-functions/logger";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { AccountEvent } from "../ts/account_events";
import { FieldValue } from "firebase-admin/firestore";
import {
  firebaseAccountEventsPath,
  firebaseServiceBetaUsersPath,
  firebaseServiceEventsPath,
  docPayload,
  docVersion,
  docTimeStamp,
  docBetaUsers,
  triggerSiteUsersPath,
  triggerAccountEvents1Path,
  collectionGroupSiteUsers,
  firebaseSiteUsersPath,
} from "../shared/collection_paths";
import { BloomFilterProcessor, defaultBloomFilterSize, defaultBloomFilterHashCount } from "./bloom_filter";
import { ServiceEvent } from "../ts/service_events";

/**
 * Cloud function that listens for a new member being added to a site.
 * When a document is created in `hyttahub/{appPathSegment}/sites/{siteId}/site_users/{email}`,
 * it automatically adds a `joinSite` event to the user's account if they aren't already joined.
 * It also adds the user to the authorized emails list (beta users) if applicable.
 */
export const autoJoinOnMemberAdded = onDocumentCreated(
  triggerSiteUsersPath,
  async (event) => {
      const { appPathSegment, siteId } = event.params;
      const email = event.params.email.toLowerCase();

      logger.info(`Auto-join triggered for ${email} on site ${siteId} (app: ${appPathSegment})`);

      try {
        const db = admin.firestore();
      const accountEventsRef = db.collection(firebaseAccountEventsPath(appPathSegment, email));

      // Fetch all account events to determine current state
      const snapshot = await accountEventsRef.orderBy(docVersion, "asc").get();
      
      let isJoined = false;
      let lastVersion = 0;

      logger.info(`Fetched ${snapshot.size} account events for ${email}`);

      // NEW: Check if this is the only user in the site.
      // If it is, this user created the site and we should skip the auto-join as it's redundant.
      const siteUsersRef = db.collection(firebaseSiteUsersPath(appPathSegment, siteId));
      const siteUsersSnapshot = await siteUsersRef.count().get();
      const siteUsersCount = siteUsersSnapshot.data().count;

      logger.info(`Site ${siteId} has ${siteUsersCount} user(s).`);

      // NEW: Check if account exists (specifically if version 1 exists)
      const accountExists = snapshot.docs.some(doc => doc.id === "1");
      
      if (siteUsersCount <= 1) {
        logger.info(`Only one user in site ${siteId} (the creator). Skipping join event creation to avoid redundancy.`);
      } else if (!accountExists) {
        logger.info(`Account for ${email} has not been initialized yet (version 1 missing). Skipping join event creation. It will be handled by onAccountCreated later.`);
      } else {
        snapshot.docs.forEach((doc) => {
          const data = doc.data();
          const version = data[docVersion];
          if (typeof version === "number" && version > lastVersion) {
            lastVersion = version;
          }

          if (data[docPayload] && typeof data[docPayload] === "string") {
            try {
              const buffer = Buffer.from(data[docPayload], "base64");
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
            [docPayload]: base64Payload,
            [docVersion]: newVersion,
            [docTimeStamp]: FieldValue.serverTimestamp(),
          });

          logger.info(`Successfully auto-joined ${email} to ${siteId} with version ${newVersion}`);
        } else {
          logger.info(`Skipping auto-join for ${email} as they are already a member of ${siteId}`);
        }
      }

      // Phase 2: Handle authorized emails (beta users)
      const betaUsersRef = db.doc(firebaseServiceBetaUsersPath(appPathSegment));
      const betaUsersDoc = await betaUsersRef.get();

      if (betaUsersDoc.exists) {
        const data = betaUsersDoc.data();
        const betaUsersStr = data?.[docBetaUsers] || "";
        const rawList = betaUsersStr.split(/[,\n]/).map((s: string) => s.trim().toLowerCase()).filter((s: string) => s.length > 0);
        const betaUsersList: string[] = Array.from(new Set<string>(rawList));

        if (!betaUsersList.includes(email)) {
          logger.info(`Adding ${email} to authorized emails list`);
          betaUsersList.push(email);
          const updatedBetaUsersStr = betaUsersList.join(",");
          
          await betaUsersRef.update({
            [docBetaUsers]: updatedBetaUsersStr,
            [docTimeStamp]: FieldValue.serverTimestamp(),
          });

          // Update Bloom Filter in service events
          const bloomProcessor = new BloomFilterProcessor(defaultBloomFilterSize, defaultBloomFilterHashCount);
          bloomProcessor.addAll(betaUsersList);

          const serviceEventsRef = db.collection(firebaseServiceEventsPath(appPathSegment, "status"));
          const serviceSnapshot = await serviceEventsRef.orderBy(docVersion, "desc").limit(1).get();
          const lastServiceVersion = serviceSnapshot.empty ? 0 : serviceSnapshot.docs[0].data()[docVersion];
          const nextServiceVersion = lastServiceVersion + 1;

          const serviceEvent: ServiceEvent = {
            version: nextServiceVersion,
            author: 1, // Default author for auto-updates
            betaUsersFilter: {
              bitArray: bloomProcessor.bitArray,
              size: bloomProcessor.size,
              hashCount: bloomProcessor.hashCount,
            },
          };

          const serviceBuffer = ServiceEvent.encode(serviceEvent).finish();
          const serviceBase64 = Buffer.from(serviceBuffer).toString("base64");

          await serviceEventsRef.doc(String(nextServiceVersion)).set({
            [docPayload]: serviceBase64,
            [docVersion]: nextServiceVersion,
            [docTimeStamp]: FieldValue.serverTimestamp(),
          });

          logger.info(`Updated bloom filter in service events version ${nextServiceVersion}`);
        }
      }
    } catch (error) {
      logger.error(`Error in autoJoinOnMemberAdded for ${email} on site ${siteId}:`, error);
    }
  }
);

/**
 * Cloud function that listens for new user accounts and joins them to all sites they were added to.
 * Listens for the creation of `hyttahub/{appPathSegment}/accounts/{email}` document.
 */
export const onAccountCreated = onDocumentCreated(
  triggerAccountEvents1Path,
  async (event) => {
    const { appPathSegment } = event.params;
    const email = event.params.email.toLowerCase();
    logger.info(`Account creation trigger started for ${email} in app segment: ${appPathSegment}`);

    try {
      const db = admin.firestore();
      
      // Find all sites where this email is in `site_users`
      logger.info(`Searching for sites where ${email} is pre-configured in site_users...`);
      const siteUsersQuery = db.collectionGroup(collectionGroupSiteUsers);
      const sitesSnapshot = await siteUsersQuery.get();
      logger.info(`CollectionGroup 'site_users' query returned ${sitesSnapshot.size} total documents across all sites.`);

      const sitesToJoin: string[] = [];
      sitesSnapshot.docs.forEach(doc => {
        const path = doc.ref.path;
        if (doc.id.toLowerCase() === email && path.startsWith(`hyttahub/${appPathSegment}/`)) {
          // doc path: hyttahub/{appPathSegment}/sites/{siteId}/site_users/{email}
          const siteId = doc.ref.parent.parent?.id;
          if (siteId) {
            sitesToJoin.push(siteId);
            logger.info(`Match found: Email ${email} is configured for site ${siteId} in segment ${appPathSegment}`);
          }
        }
      });

      if (sitesToJoin.length === 0) {
        logger.info(`No pre-configured sites found for ${email}. No automatic joins will be performed.`);
        return;
      }

      logger.info(`Found ${sitesToJoin.length} site(s) to join for ${email}: ${sitesToJoin.join(", ")}`);

      const accountEventsRef = db.collection(firebaseAccountEventsPath(appPathSegment, email));
      const accountSnapshot = await accountEventsRef.orderBy(docVersion, "desc").limit(1).get();
      let lastVersion = accountSnapshot.empty ? 0 : accountSnapshot.docs[0].data()[docVersion];
      logger.info(`Current last version for ${email} account events is ${lastVersion}`);

      for (const siteId of sitesToJoin) {
        lastVersion++;
        logger.info(`Joining ${email} to ${siteId}. Creating event version ${lastVersion}...`);
        
        const newEvent: AccountEvent = {
          version: lastVersion,
          joinSite: siteId,
        };

        const buffer = AccountEvent.encode(newEvent).finish();
        const base64Payload = Buffer.from(buffer).toString("base64");

        await accountEventsRef.doc(String(lastVersion)).set({
          [docPayload]: base64Payload,
          [docVersion]: lastVersion,
          [docTimeStamp]: FieldValue.serverTimestamp(),
        });
        logger.info(`Successfully auto-joined ${email} to ${siteId} with version ${lastVersion}.`);
      }
      logger.info(`Automatic site joining completed for ${email}. Total sites joined: ${sitesToJoin.length}`);
    } catch (error) {
      logger.error(`Error in onAccountCreated for ${email}:`, error);
    }
  }
);
