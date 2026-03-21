// Copyright (c) 2025 bjorge

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub/functions/base_hyttahub_functions.dart';
import 'package:hyttahub/collection_paths.dart';
import 'package:hyttahub_pocketbase/pocketbase_hyttahub_storage.dart';

/// A [BaseHyttaHubFunctions] implementation for PocketBase.
///
/// Server-side operations (copySite, listSiteFiles) are performed directly
/// against the PocketBase REST API rather than through Cloud Functions.
class PocketbaseHyttaHubFunctions implements BaseHyttaHubFunctions {
  PocketbaseHyttaHubFunctions({required PocketBase client}) : _client = client;

  final PocketBase _client;

  @override
  Future<Map<String, dynamic>> listSiteFiles({
    required String siteId,
    required String appName,
  }) async {
    final colName = encodePath(collectionSiteFilesPath(siteId, cloudRoot: appName));

    try {
      final records = await _client.collection(colName).getFullList();
      final result = <Map<String, dynamic>>[];

      for (final record in records) {
        final docId = record.getStringValue('doc_id');
        final storedFiles = record.getListValue<String>('file');
        if (storedFiles.isEmpty) continue;

        // Use an HTTP HEAD request to get Content-Length without downloading.
        int size = 0;
        try {
          final fileUrl = _client.files.getUrl(record, storedFiles.first);
          final head = await http.head(fileUrl);
          final contentLength = head.headers['content-length'];
          if (contentLength != null) size = int.tryParse(contentLength) ?? 0;
        } catch (_) {
          // Non-critical: size just shows as 0 in the UI.
        }

        result.add({'name': docId, 'size': size});
      }

      return {'files': result};
    } on ClientException catch (e) {
      if (e.statusCode == 404) return {'files': []};
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {}
}
