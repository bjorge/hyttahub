// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:typed_data';

import 'package:hyttahub/storage/base_hyttahub_internal_storage.dart';

/// A [BaseHyttaHubInternalStorage] stub for PocketBase.
///
/// **Note**: Standard HyttaHub "Site Files" (like photos uploaded to a site)
/// are handled by `PocketbaseHyttaHubStorage`. This class is for low-level,
/// app-wide blob storage that does not belong to a specific site.
///
/// Because PocketBase requires files to be fields on records, generic path
/// mapping is app-specific. Most apps using the standard Site features
/// **do not need to implement this**.
///
/// **How to use**: If your app requires custom app-wide blob storage, extend
/// this class, inject a [PocketBase] client, and override the methods
/// below to match your file collection schema:
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
