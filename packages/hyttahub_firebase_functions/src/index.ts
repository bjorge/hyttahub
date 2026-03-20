/**
 * Main entry point for the @hyttahub/functions package.
 * This file exports all the cloud functions that can be reused in other Firebase projects.
 */

export {
  uploadFile,
  deleteFiles,
  getFile,
  listSiteFiles,
} from "./file_functions/file_functions";

export {
  processMarkForDeleteRecords,
} from "./hyttahub_functions/hyttahub_functions";

export {
  autoJoinOnMemberAdded,
  onAccountCreated,
} from "./auto_join/index";

// Export helper functions for app cloud functions.
export {
  createSiteEventPayload,
} from "./shared/app_payload";

export {
  fbPayload,
  fbTimeStamp,
  firebaseSiteEventsPath,
  fbVersion,
  firebaseSitesPath,
} from "./shared/constants";

export { setArchiveBucketName } from "./shared/config";
