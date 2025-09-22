// Copyright (c) 2025 bjorge

// Firebase paths for various data structures in the application.

// Service paths
import 'package:hyttahub/hyttahub_options.dart';

String firebaseServiceCollectionName = 'status';

String firebaseServiceEventsPath1(String status) =>
    'hyttahub/${HyttaHubOptions.firebaseRootCollection}/services/$status/service_events';

String firebaseServiceEventsPath(String status) =>
    'hyttahub/${HyttaHubOptions.firebaseRootCollection}/services/$status/service_events';

// The service admins that have write access to the service events
String firebaseServiceServiceAdminsPath(String status) =>
    'hyttahub/${HyttaHubOptions.firebaseRootCollection}/services/$status/service_users';

// The service beta users field
String firebaseServiceBetaUsersPath() =>
    'hyttahub/${HyttaHubOptions.firebaseRootCollection}/services/beta_users';

// Account paths
String firebaseAccountEventsPath(String userId) =>
    'hyttahub/${HyttaHubOptions.firebaseRootCollection}/accounts/$userId/account_events';

// Site paths
String firebaseSiteEventsPath(String siteId) =>
    'hyttahub/${HyttaHubOptions.firebaseRootCollection}/sites/$siteId/site_events';

String firebaseSiteUsersPath(String siteId) =>
    'hyttahub/${HyttaHubOptions.firebaseRootCollection}/sites/$siteId/site_users';

// Storage paths
String firebasePhotosPath(String siteId, String photoId) =>
    'hyttahub/${HyttaHubOptions.firebaseRootCollection}/$siteId/$photoId';

// Document keys
const fbUserId = 'u';
const fbTimeStamp = 't';
const fbVersion = 'v';
const fbPayload = 'p';
const fbBetaUsers = 'b';
const fbMarkedForDeletion = 'm';
