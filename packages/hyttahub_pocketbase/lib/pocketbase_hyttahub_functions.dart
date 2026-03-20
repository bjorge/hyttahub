// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub/functions/base_hyttahub_functions.dart';
import 'package:hyttahub/proto/site_util.pb.dart';
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
    final colName = encodePath('hyttahub/$appName/sites/$siteId/site_files');

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
  Future<Map<String, dynamic>> copySite({
    required String siteId,
    required String appName,
    int? upToVersion,
    String? mockUserEmail,
  }) async {
    final usersCol = encodePath('hyttahub/$appName/sites/$siteId/site_users');

    try {
      // 1. Find the site user record for this member
      final results = await _client
          .collection(usersCol)
          .getFullList(filter: 'doc_id = "$mockUserEmail"');

      if (results.isEmpty) {
        throw Exception('Member not found in site: $siteId');
      }

      final record = results.first;
      final authorId = record.getIntValue('u');

      // 2. Create the MarkForCopy proto
      final mark = MarkForCopy(
        author: authorId,
        upToVersion: upToVersion ?? 0,
      );

      // 3. Update the record with the mark in field
      final mValue = base64Encode(mark.writeToBuffer());
      await _client.collection(usersCol).update(record.id, body: {docSiteMemberMarkedForCopy: mValue});

      return {'message': 'Site copy requested'};
    } on ClientException catch (e) {
      throw Exception('PocketBase error: ${e.response}');
    }
  }

  @override
  Future<void> dispose() async {}
}
