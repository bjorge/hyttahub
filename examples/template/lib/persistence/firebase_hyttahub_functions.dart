// Copyright (c) 2025 bjorge

import 'package:cloud_functions/cloud_functions.dart';
import 'package:hyttahub/functions/base_hyttahub_functions.dart';

class FirebaseHyttaHubFunctions implements BaseHyttaHubFunctions {
  @override
  Future<Map<String, dynamic>> importSite({
    String? base64Data,
    String? storagePath,
    required String appName,
  }) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'importSite',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 540),
      ),
    );
    final result = await callable.call(<String, dynamic>{
      if (base64Data != null) 'base64Data': base64Data,
      if (storagePath != null) 'storagePath': storagePath,
      'appName': appName,
    });
    return Map<String, dynamic>.from(result.data);
  }

  @override
  Future<Map<String, dynamic>> copySite({
    required String siteId,
    required String appName,
    int? upToVersion,
  }) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'copySite',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 540),
      ),
    );
    final result = await callable.call(<String, dynamic>{
      'siteId': siteId,
      'appName': appName,
      if (upToVersion != null) 'upToVersion': upToVersion,
    });
    return Map<String, dynamic>.from(result.data);
  }

  @override
  Future<void> assignUserToImportedSite({
    required String siteId,
    required String memberId,
    required String appName,
  }) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'assignUserToImportedSite',
    );
    await callable.call(<String, dynamic>{
      'siteId': siteId,
      'memberId': memberId,
      'appName': appName,
    });
  }

  @override
  Future<Map<String, dynamic>> listExports({
    required String siteId,
    required String appName,
  }) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'listExports',
    );
    final result = await callable.call(<String, dynamic>{
      'siteId': siteId,
      'appName': appName,
    });
    return Map<String, dynamic>.from(result.data);
  }

  @override
  Future<void> deleteExport({
    required String siteId,
    required String appName,
    required String fileName,
  }) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'deleteExport',
    );
    await callable.call(<String, dynamic>{
      'siteId': siteId,
      'appName': appName,
      'fileName': fileName,
    });
  }

  @override
  Future<Map<String, dynamic>> getExportDetails({
    required String siteId,
    required String appName,
    required String fileName,
  }) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'exportDetails',
    );
    final result = await callable.call(<String, dynamic>{
      'siteId': siteId,
      'appName': appName,
      'fileName': fileName,
    });
    return Map<String, dynamic>.from(result.data);
  }

  @override
  Future<Map<String, dynamic>> listSiteFiles({
    required String siteId,
    required String appName,
  }) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'listSiteFiles',
    );
    final result = await callable.call(<String, dynamic>{
      'siteId': siteId,
      'appName': appName,
    });
    return Map<String, dynamic>.from(result.data);
  }

  @override
  Future<void> dispose() async {}
}
