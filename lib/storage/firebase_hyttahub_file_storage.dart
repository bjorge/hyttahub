// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hyttahub/storage/base_hyttahub_file_storage.dart';

class FirebaseHyttaHubFileStorage implements BaseHyttaHubFileStorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Map<String, StreamController<double>> _progressControllers = {};

  @override
  Future<void> uploadFile(String path, Uint8List data) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putData(data);
    
    final controller = _progressControllers.putIfAbsent(path, () => StreamController<double>.broadcast());
    
    final subscription = uploadTask.snapshotEvents.listen((snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      controller.add(progress);
    });

    try {
      await uploadTask;
    } finally {
      subscription.cancel();
      _progressControllers.remove(path);
    }
  }

  @override
  Future<Uint8List> downloadFile(String path) async {
    final ref = _storage.ref().child(path);
    final data = await ref.getData();
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
    final ref = _storage.ref().child(path);
    await ref.delete();
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    final ref = _storage.ref().child(prefix);
    final result = await ref.listAll();
    return result.items.map((item) => item.fullPath).toList();
  }

  @override
  Future<String> getDownloadUrl(String path) async {
    final ref = _storage.ref().child(path);
    return await ref.getDownloadURL();
  }

  @override
  Stream<double> uploadProgress(String path) {
    return _progressControllers[path]?.stream ?? const Stream.empty();
  }
}
