// Copyright (c) 2025 bjorge

// Firebase paths for various data structures in the application.

// Service paths
import 'package:hyttahub/hyttahub_options.dart';

String collectionServiceCollectionName = 'status';

String _root() => HyttaHubOptions.implementation?.cloudRootCollection ?? '';

String collectionSiteEventsPath(String siteId) {
  return 'hyttahub/${_root()}/sites/$siteId/site_events';
}

String collectionSiteUsersPath(String siteId) {
  return 'hyttahub/${_root()}/sites/$siteId/site_users';
}

String collectionServiceEventsPath(String serviceCollectionName) {
  return 'hyttahub/${_root()}/services/$serviceCollectionName/service_events';
}

String collectionServiceAdminsPath(String serviceCollectionName) {
  return 'hyttahub/${_root()}/services/$serviceCollectionName/service_admins';
}

String collectionServiceBetaUsersPath() {
  return 'hyttahub/${_root()}/services/status/beta_users';
}

String collectionServiceAlphaUsersPath() {
  return 'hyttahub/${_root()}/services/status/alpha_users';
}

String collectionAccountEventsPath(String accountEmail) {
  return 'hyttahub/${_root()}/accounts/$accountEmail/account_events';
}

String collectionFilesPath(String siteId, String fileName) {
  if (fileName.isEmpty) {
    return '${_root()}/$siteId';
  }
  return '${_root()}/$siteId/$fileName';
}

String collectionArchiveFilePath(String siteId, String fileName) {
  if (fileName.isEmpty) {
    return '${_root()}/$siteId';
  }
  return '${_root()}/$siteId/$fileName';
}

String emulatorArchiveFilesPath(String siteId, String fileName) {
  if (fileName.isEmpty) {
    return 'archive_files/${_root()}/$siteId';
  }
  return 'archive_files/${_root()}/$siteId/$fileName';
}

// Document keys
const fbUserId = 'u';
const fbTimeStamp = 't';
const fbVersion = 'v';
const fbPayload = 'p';
const fbBetaUsers = 'b';
const fbSiteMemberMarkedForDeletion = 'm';
const fbSiteMemberMarkedForCopy = 'MarkForCopy';
const fbSiteMarkedForDeletion = 'sm';

const firstCollectionEventVersion = 1;
