import * as admin from "firebase-admin";

admin.initializeApp();

export {
  uploadFile,
  deleteFile, 
  deleteFiles,
  getFile,
} from "./file_functions/file_functions";

export {
  assignUserToImportedSite,
  importSite,
  listExports,
  deleteExport,
  exportDetails,
  backupSite,
} from "./backup_functions/backup_functions";

export {
  executetask,
  cleanupOrphanedSites,
  processMarkForDeleteRecords,
} from "./hyttahub_functions/hyttahub_functions";
