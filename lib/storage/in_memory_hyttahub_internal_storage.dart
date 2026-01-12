// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:hyttahub/storage/base_hyttahub_internal_storage.dart';

class InMemoryHyttaHubInternalStorage implements BaseHyttaHubInternalStorage {
  // Map of path -> data
  final Map<String, Uint8List> _files = {};
  final Map<String, StreamController<double>> _progressControllers = {};

  @override
  Future<void> uploadFile(String path, Uint8List data) async {
    final controller = _progressControllers.putIfAbsent(path, () => StreamController<double>.broadcast());
    
    // Simulate progress
    const steps = 5;
    for (var i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      controller.add(i / steps);
    }

    _files[path] = data;
    _progressControllers.remove(path);
  }

  @override
  Future<Uint8List> downloadFile(String path) async {
    final data = _files[path];
    if (data == null) throw Exception('File not found: $path');
    return data;
  }

  @override
  Future<void> dispose() async {
    for (final controller in _progressControllers.values) {
      await controller.close();
    }
    _progressControllers.clear();
  }

  @override
  Future<void> deleteFile(String path) async {
    _files.remove(path);
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    return _files.keys.where((path) => path.startsWith(prefix)).toList();
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
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Stream<double> uploadProgress(String path) {
    return _progressControllers[path]?.stream ?? const Stream.empty();
  }
}
