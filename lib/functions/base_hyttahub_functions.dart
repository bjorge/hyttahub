// Copyright (c) 2025 bjorge

import 'dart:async';

abstract class BaseHyttaHubFunctions {
  Future<Map<String, dynamic>> importSite({
    String? base64Data,
    String? storagePath,
    required String appName,
  });

  Future<Map<String, dynamic>> copySite({
    required String siteId,
    required String appName,
    int? upToVersion,
  });


  Future<void> assignUserToImportedSite({
    required String siteId,
    required String memberId,
    required String appName,
  });

  Future<Map<String, dynamic>> listExports({
    required String siteId,
    required String appName,
  });

  Future<void> deleteExport({
    required String siteId,
    required String appName,
    required String fileName,
  });

  Future<Map<String, dynamic>> getExportDetails({
    required String siteId,
    required String appName,
    required String fileName,
  });

  Future<Map<String, dynamic>> listSiteFiles({
    required String siteId,
    required String appName,
  });

  Future<void> dispose();
}
