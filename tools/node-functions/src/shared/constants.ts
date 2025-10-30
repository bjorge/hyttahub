export const isRunningInEmulator = (): boolean => {
  // Check for the FIREBASE_AUTH_EMULATOR_HOST or FIRESTORE_EMULATOR_HOST environment variable
  return (
    !!process.env.FIREBASE_AUTH_EMULATOR_HOST ||
    !!process.env.FIRESTORE_EMULATOR_HOST
  );
};

export const firebaseServiceEventsPath = (
  appPathSegment: string,
  status: string
) => `hyttahub/${appPathSegment}/services/${status}/service_events`;

export const firebaseServiceServiceAdminsPath = (
  appPathSegment: string,
  status: string
) => `hyttahub/${appPathSegment}/services/${status}/service_users`;

export const firebaseServiceBetaUsersPath = (appPathSegment: string) =>
  `hyttahub/${appPathSegment}/services/beta_users`;

export const firebaseAccountEventsPath = (
  appPathSegment: string,
  userId: string
) => `hyttahub/${appPathSegment}/accounts/${userId}/account_events`;

export const firebaseSiteEventsPath = (
  appPathSegment: string,
  siteId: string
) => `hyttahub/${appPathSegment}/sites/${siteId}/site_events`;

export const firebaseSiteUsersPath = (appPathSegment: string, siteId: string) =>
  `hyttahub/${appPathSegment}/sites/${siteId}/site_users`;

export const firebaseSitesPath = (appPathSegment: string) =>
  `hyttahub/${appPathSegment}/sites`;

export const firebaseSiteExportPath = (
  appPathSegment: string,
  siteId: string
) => `hyttahub/${appPathSegment}/sites/${siteId}/site_exports/export_request`;

export const firebaseSiteExportsBasePath = (
  appPathSegment: string,
  siteId: string
) => `hyttahub/${appPathSegment}/sites/${siteId}/site_exports`;



export const firebaseFilesPath = (
  appPathSegment: string,
  siteId: string,
  fileId: string
): string => {
  if (isRunningInEmulator()) {
    return `emulator/${appPathSegment}/sites/${siteId}/${fileId}`;
  } else {
    return `hyttahub/${appPathSegment}/sites/${siteId}/${fileId}`;
  }
};

export const firebaseExportsPath = (
  appPathSegment: string,
  siteId: string,
  fileName: string
): string => {
  if (isRunningInEmulator()) {
    return `emulator/${appPathSegment}/exports/${siteId}/${fileName}`;
  } else {
    return `hyttahub/${appPathSegment}/exports/${siteId}/${fileName}`;
  }
};

// Document keys
export const fbUserId = "u";
export const fbTimeStamp = "t";
export const fbVersion = "v";
export const fbPayload = "p";
export const fbBetaUsers = "b";
export const fbMarkedForDeletion = "m";
export const fbAppId = "a";