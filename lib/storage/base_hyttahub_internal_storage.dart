// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:typed_data';

abstract class BaseHyttaHubInternalStorage {
  Future<void> uploadFile(String path, Uint8List data);
  Future<Uint8List> downloadFile(String path);
  Future<void> deleteFile(String path);
  Future<List<String>> listFiles(String prefix);
  Future<String> getDownloadUrl(String path);
  
  Stream<double> uploadProgress(String path);

  Future<void> dispose();
}
