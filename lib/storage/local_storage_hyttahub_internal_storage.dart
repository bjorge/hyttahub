// Copyright (c) 2025 bjorge

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hyttahub/storage/base_hyttahub_internal_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageHyttaHubInternalStorage implements BaseHyttaHubInternalStorage {
  Future<Directory> get _filesDir async {
    if (kIsWeb) {
      throw UnsupportedError('Local storage file system is not supported on Web. Use Sembast Base64 storage instead.');
    }
    final appDocDir = await getApplicationDocumentsDirectory();
    final dir = Directory(join(appDocDir.path, 'hyttahub_files'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  @override
  Future<void> uploadFile(String path, Uint8List data) async {
    // path is usually like "siteId/filename" or similar relative path
    final root = await _filesDir;
    final file = File(join(root.path, path));
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    await file.writeAsBytes(data);
  }

  @override
  Future<Uint8List> downloadFile(String path) async {
    final root = await _filesDir;
    final file = File(join(root.path, path));
    if (!await file.exists()) {
      throw Exception('File not found: $path');
    }
    return await file.readAsBytes();
  }

  @override
  Future<void> deleteFile(String path) async {
     final root = await _filesDir;
    final file = File(join(root.path, path));
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    final root = await _filesDir;
    final dir = Directory(join(root.path, prefix));
    if (!await dir.exists()) {
      return [];
    }
    final entities = await dir.list(recursive: true).toList();
    return entities
        .whereType<File>()
        .map((e) => relative(e.path, from: root.path))
        .toList();
  }

  @override
  Stream<double> uploadProgress(String path) {
    // Local write is instant enough
    return Stream.value(1.0);
  }

  @override
  Future<String> getDownloadUrl(String path) async {
    final root = await _filesDir;
    final file = File(join(root.path, path));
    // For local storage, we return the absolute file path as URI.
    // This allows Image.file(File(path)) or Image.network(uri) handling dependent on protocol.
    // Usually file:// URI.
    return file.uri.toString();
  }
  
  @override
  Future<void> dispose() async {}
}
