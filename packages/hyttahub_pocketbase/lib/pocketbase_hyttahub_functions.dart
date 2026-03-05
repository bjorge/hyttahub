// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:hyttahub/functions/base_hyttahub_functions.dart';

/// A [BaseHyttaHubFunctions] stub for PocketBase.
///
/// PocketBase does not have a built-in equivalent of Firebase Cloud Functions.
/// Server-side logic can be triggered via PocketBase hooks (Go) or custom
/// API routes.
///
/// Both [copySite] and [listSiteFiles] throw [UnimplementedError] by default.
/// Extend this class and override these methods to call your own PocketBase
/// hooks or an external backend:
///
/// ```dart
/// class MyPocketbaseFunctions extends PocketbaseHyttaHubFunctions {
///   MyPocketbaseFunctions(this._pb);
///   final PocketBase _pb;
///
///   @override
///   Future<Map<String, dynamic>> copySite({
///     required String siteId,
///     required String appName,
///     int? upToVersion,
///     String? mockUserEmail,
///   }) async {
///     final result = await _pb.send(
///       '/api/my-hooks/copy-site',
///       method: 'POST',
///       body: {'siteId': siteId, 'appName': appName},
///     );
///     return Map<String, dynamic>.from(result as Map);
///   }
/// }
/// ```
class PocketbaseHyttaHubFunctions implements BaseHyttaHubFunctions {
  @override
  Future<Map<String, dynamic>> copySite({
    required String siteId,
    required String appName,
    int? upToVersion,
    String? mockUserEmail,
  }) async {
    throw UnimplementedError(
      'copySite is not implemented for PocketbaseHyttaHubFunctions. '
      'Extend this class and call your PocketBase hook or custom backend.',
    );
  }

  @override
  Future<Map<String, dynamic>> listSiteFiles({
    required String siteId,
    required String appName,
  }) async {
    throw UnimplementedError(
      'listSiteFiles is not implemented for PocketbaseHyttaHubFunctions. '
      'Extend this class and call your PocketBase hook or custom backend.',
    );
  }

  @override
  Future<void> dispose() async {}
}
