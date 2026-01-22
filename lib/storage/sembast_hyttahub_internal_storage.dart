// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:hyttahub/storage/base_hyttahub_internal_storage.dart';
import 'package:hyttahub/storage/database_factory_provider.dart';
import 'package:sembast/sembast.dart';

class SembastHyttaHubInternalStorage implements BaseHyttaHubInternalStorage {
  Database? _db;
  Completer<Database>? _dbOpenCompleter;

  Future<Database> get _readyDb async {
    if (_db != null) return _db!;
    if (_dbOpenCompleter != null) return _dbOpenCompleter!.future;

    _dbOpenCompleter = Completer<Database>();
    try {
      final factory = databaseFactory;
      // Use the same database name as SembastHyttaHubStorage for consistency
      // or a separate one if preferred. For simplicity and shared access, same name.
      final db = await factory.openDatabase('hyttahub');
      _db = db;
      _dbOpenCompleter!.complete(db);
      return db;
    } catch (e) {
      _dbOpenCompleter!.completeError(e);
      rethrow;
    } finally {
      _dbOpenCompleter = null;
    }
  }

  @override
  Future<void> uploadFile(String path, Uint8List data) async {
    final db = await _readyDb;
    final store = stringMapStoreFactory.store('web_files');
    await store.record(path).put(db, {'content': base64Encode(data)});
  }

  @override
  Future<Uint8List> downloadFile(String path) async {
    final db = await _readyDb;
    final store = stringMapStoreFactory.store('web_files');
    final record = await store.record(path).get(db);
    if (record != null && record['content'] is String) {
      return base64Decode(record['content'] as String);
    }
    throw Exception('File not found: $path');
  }

  @override
  Future<void> deleteFile(String path) async {
    final db = await _readyDb;
    final store = stringMapStoreFactory.store('web_files');
    await store.record(path).delete(db);
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    final db = await _readyDb;
    final store = stringMapStoreFactory.store('web_files');
    final records = await store.find(db);
    return records
        .map((r) => r.key)
        .where((key) => key.startsWith(prefix))
        .toList();
  }

  @override
  Future<String> getDownloadUrl(String path) async {
    // For web internal storage, we return a data URI
    try {
      final bytes = await downloadFile(path);
      final base64 = base64Encode(bytes);
      String mime = 'application/octet-stream';
      if (path.endsWith('.png')) mime = 'image/png';
      if (path.endsWith('.jpg') || path.endsWith('.jpeg')) mime = 'image/jpeg';
      return 'data:$mime;base64,$base64';
    } catch (e) {
      return '';
    }
  }

  @override
  Stream<double> uploadProgress(String path) {
    // Persistent write is instant enough on web
    return Stream.value(1.0);
  }

  @override
  Future<void> dispose() async {
    // We don't close the DB here as it might be shared with SembastHyttaHubStorage
  }
}
