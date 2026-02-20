// Copyright (c) 2025 bjorge

import 'package:cloud_functions/cloud_functions.dart';
import 'package:hyttahub/functions/base_hyttahub_functions.dart';

class FirebaseHyttaHubFunctions implements BaseHyttaHubFunctions {
  @override
  Future<Map<String, dynamic>> copySite({
    required String siteId,
    required String appName,
    int? upToVersion,
    String? mockUserEmail,
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
