import * as admin from "firebase-admin";

admin.initializeApp();

export {
  uploadPhoto,
  getPhoto,
  deletePhoto,
  deleteAlbumPhotos,
} from "./app_functions/app_functions";
export {
  queryservice,
  cleanupOrphanedSites,
  processMarkForDeleteRecords,
} from "./hyttahub_functions/hyttahub_functions";
