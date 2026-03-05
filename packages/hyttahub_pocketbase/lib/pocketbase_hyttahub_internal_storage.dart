// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:typed_data';

import 'package:hyttahub/storage/base_hyttahub_internal_storage.dart';

/// A [BaseHyttaHubInternalStorage] stub for PocketBase.
///
/// PocketBase stores files as fields on records rather than in a dedicated
/// blob store. Because the collection/record layout depends on the consumer's
/// schema, all methods in this class throw [UnimplementedError] by default.
///
/// **How to use**: Extend this class, inject a [PocketBase] client, and
/// override the methods below to match your file collection schema:
///
/// ```dart
/// class MyPocketbaseStorage extends PocketbaseHyttaHubInternalStorage {
///   MyPocketbaseStorage(this._pb);
///   final PocketBase _pb;
///
///   @override
///   Future<void> uploadFile(String path, Uint8List data) async {
///     // Use _pb.collection('files').create(...) with a multipart body.
///   }
///   // ... etc.
/// }
/// ```
class PocketbaseHyttaHubInternalStorage implements BaseHyttaHubInternalStorage {
  @override
  Future<void> uploadFile(String path, Uint8List data) async {
    throw UnimplementedError(
      'uploadFile is not implemented. Extend PocketbaseHyttaHubInternalStorage '
      'and implement uploads against your PocketBase file collection schema.',
    );
  }

  @override
  Future<Uint8List> downloadFile(String path) async {
    throw UnimplementedError(
      'downloadFile is not implemented. Extend PocketbaseHyttaHubInternalStorage '
      'and implement downloads against your PocketBase file collection schema.',
    );
  }

  @override
  Future<void> deleteFile(String path) async {
    throw UnimplementedError(
      'deleteFile is not implemented. Extend PocketbaseHyttaHubInternalStorage '
      'and implement deletion against your PocketBase file collection schema.',
    );
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    throw UnimplementedError(
      'listFiles is not implemented. Extend PocketbaseHyttaHubInternalStorage '
      'and implement listing against your PocketBase file collection schema.',
    );
  }

  @override
  Future<String> getDownloadUrl(String path) async {
    throw UnimplementedError(
      'getDownloadUrl is not implemented. Extend PocketbaseHyttaHubInternalStorage '
      'and implement URL generation against your PocketBase file collection schema.',
    );
  }

  @override
  Stream<double> uploadProgress(String path) {
    // PocketBase's Dart SDK does not expose upload progress natively.
    // Return an empty stream; override this method if you need progress tracking.
    return const Stream.empty();
  }

  @override
  Future<void> dispose() async {}
}
