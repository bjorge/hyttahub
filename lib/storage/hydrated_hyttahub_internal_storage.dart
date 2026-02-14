// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hyttahub/storage/base_hyttahub_internal_storage.dart';

class HydratedHyttaHubInternalStorage implements BaseHyttaHubInternalStorage {
  final String storageKey;
  final Map<String, Uint8List> _files = {};

  HydratedHyttaHubInternalStorage({required this.storageKey}) {
    _loadFromStorage();
  }

  void _loadFromStorage() {
    try {
      final storedFiles = HydratedBloc.storage.read(storageKey);
      if (kDebugMode) {
        print('HydratedHyttaHubInternalStorage: loading from $storageKey, found: ${storedFiles != null}');
      }
      if (storedFiles != null && storedFiles is Map) {
        storedFiles.forEach((key, value) {
          if (value is List) {
            _files[key.toString()] = Uint8List.fromList(value.cast<int>());
          }
        });
        if (kDebugMode) {
          print('HydratedHyttaHubInternalStorage: loaded ${_files.length} files');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('HydratedHyttaHubInternalStorage: error loading: $e');
      }
    }
  }

  Future<void> _persist() async {
    try {
      if (kDebugMode) {
        print('HydratedHyttaHubInternalStorage: persisting ${_files.length} files to $storageKey');
      }
      await HydratedBloc.storage.write(storageKey, _files.map((k, v) => MapEntry(k, v.toList())));
    } catch (e) {
      if (kDebugMode) {
        print('HydratedHyttaHubInternalStorage: error persisting: $e');
      }
    }
  }

  @override
  Future<void> uploadFile(String path, Uint8List data) async {
    if (kDebugMode) {
      print('HydratedHyttaHubInternalStorage: uploadFile $path (${data.length} bytes)');
    }
    _files[path] = data;
    await _persist();
  }

  @override
  Future<Uint8List> downloadFile(String path) async {
    if (kDebugMode) {
      print('HydratedHyttaHubInternalStorage: downloadFile $path');
    }
    final file = _files[path];
    if (file == null) {
      if (kDebugMode) {
        print('HydratedHyttaHubInternalStorage: file not found $path');
      }
      throw Exception('File not found: $path');
    }
    return file;
  }

  @override
  Future<void> deleteFile(String path) async {
    if (kDebugMode) {
      print('HydratedHyttaHubInternalStorage: deleteFile $path');
    }
    _files.remove(path);
    await _persist();
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    return _files.keys.where((k) => k.startsWith(prefix)).toList();
  }

  @override
  Future<String> getDownloadUrl(String path) async {
    final data = _files[path];
    if (data == null) throw Exception('File not found: $path');
    
    final base64String = base64Encode(data);
    final mimeType = _getMimeType(path);
    return 'data:$mimeType;base64,$base64String';
  }

  String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'tar':
        return 'application/x-tar';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'txt':
        return 'text/plain';
      case 'json':
        return 'application/json';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Stream<double> uploadProgress(String path) => Stream.value(1.0);

  @override
  Future<void> dispose() async {}
}
