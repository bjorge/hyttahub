import 'dart:async';
import 'dart:convert';

import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/storage/hyttahub_internal_storage_factory.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:rxdart/rxdart.dart';

import 'package:hyttahub/storage/database_factory_provider.dart';
import 'package:flutter/foundation.dart';

class SembastHyttaHubStorage implements BaseHyttaHubStorage {
  Database? _db;
  Completer<Database>? _dbOpenCompleter;
  
  // Stream controller for simulated real-time updates (similar to InMemory)
  final StreamController<Map<String, dynamic>> _updateController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get updates => _updateController.stream;

  Future<Database> get _readyDb async {
    if (_db != null) return _db!;
    if (_dbOpenCompleter != null) return _dbOpenCompleter!.future;

    _dbOpenCompleter = Completer<Database>();
    try {
      String dbPath;
      if (kIsWeb) {
        dbPath = 'hyttahub';
      } else {
        final dir = await getApplicationDocumentsDirectory();
        await dir.create(recursive: true);
        dbPath = join(dir.path, 'hyttahub.db');
      }

      final factory = databaseFactory;
      final db = await factory.openDatabase(dbPath);
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
  Future<Map<String, dynamic>?> getDocument(String path, String docId) async {
    final db = await _readyDb;
    final store = stringMapStoreFactory.store(path);
    final snapshot = await store.record(docId).getSnapshot(db);
    return snapshot?.value;
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    String? orderBy,
    bool descending = false,
  }) async {
    final db = await _readyDb;
    final store = stringMapStoreFactory.store(path);
    // Note: Sembast sort order boolean is 'ascending'.
    // HyttaHub 'descending' = true means we want descending trigger.
    // If we want descending, we pass false to Sembast SortOrder? 
    // Wait, Sembast SortOrder(field, [bool ascending = true]).
    // So if descending is true, we pass false.
    // BUT, the logic above: SortOrder(orderBy, false) forces descending always?
    // Let's fix that.
    
    Finder? correctedFinder;
    if (orderBy != null) {
      correctedFinder = Finder(sortOrders: [SortOrder(orderBy, !descending)]);
    }

    final snapshots = await store.find(db, finder: correctedFinder);
    return snapshots.map((e) => e.value).toList();
  }

  @override
  Future<void> setDocument(
    String path,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final db = await _readyDb;
    final store = stringMapStoreFactory.store(path);
    await store.record(docId).put(db, data);
    _updateController.add({'path': path, 'docId': docId});
  }

  @override
  Future<void> updateDocument(
    String path,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final db = await _readyDb;
    final store = stringMapStoreFactory.store(path);
    // split update into check exists + update to match firestore usage mostly,
    // or just use update which returns null if not found?
    // Firestore throws if document doesn't exist on update usually.
    // Sembast update returns null if key not found.
    final result = await store.record(docId).update(db, data);
    if (result == null) {
       throw Exception('Document not found: $path/$docId');
    }
    _updateController.add({'path': path, 'docId': docId});
  }

  @override
  Stream<Map<String, Map<String, dynamic>>> listenCollection(String path) {
    // We need a stream that emits a Map<DocId, Data>
    return Stream.fromFuture(_readyDb).switchMap((db) {
       final store = stringMapStoreFactory.store(path);
       return store.query().onSnapshots(db).map((snapshots) {
         return {
           for (var s in snapshots) s.key: s.value,
         };
       });
    });
  }

  @override
  Stream<Map<int, String>> listenEvents(
    String path, {
    required int lastVersion,
    required String versionField,
    required String payloadField,
  }) {
    // Similar to collection listen but with filtering
      return Stream.fromFuture(_readyDb).switchMap((db) {
       final store = stringMapStoreFactory.store(path);
       return store.query(
         finder: Finder(
           filter: Filter.greaterThan(versionField, lastVersion),
           sortOrders: [SortOrder(versionField, true)]
         )
       ).onSnapshots(db).map((snapshots) {
          final events = <int, String>{};
          for(var snap in snapshots) {
            final version = snap.value[versionField] as int;
            final payload = snap.value[payloadField] as String;
            events[version] = payload;
          }
          return events;
       });
    });
  }

  @override
  dynamic get serverTimestamp => DateTime.now().toIso8601String();

  @override
  bool isPermissionDenied(Object error) => false;

  @override
  Future<void> runBatch(Future<void> Function(HyttaHubBatch batch) action) async {
    await runBatchInternal(action);
  }

  @override
  Future<void> uploadFile({
    required String appName,
    required String siteId,
    required String fileName,
    required String base64Data,
  }) async {
    final internalStorage = HyttaHubInternalStorageFactory.getInternalStorage(StorageEnum.localStorage);
    final path = firebaseFilesPath(siteId, fileName);
    await internalStorage.uploadFile(path, base64Decode(base64Data));
    _updateController.add({'path': siteId, 'docId': fileName});
  }

  @override
  Future<Uint8List> getFileBytes({
    required String appName,
    required String siteId,
    required String fileName,
  }) async {
    final internalStorage = HyttaHubInternalStorageFactory.getInternalStorage(StorageEnum.localStorage);
    final path = firebaseFilesPath(siteId, fileName);
    return await internalStorage.downloadFile(path);
  }

  @override
  Future<void> deleteFiles({
    required String appName,
    required String siteId,
    required List<String> fileNames,
  }) async {
    final internalStorage = HyttaHubInternalStorageFactory.getInternalStorage(StorageEnum.localStorage);
    for (final fileName in fileNames) {
      final path = firebaseFilesPath(siteId, fileName);
      await internalStorage.deleteFile(path);
    }
    _updateController.add({'path': siteId});
  }

  @override
  Future<String> getFileUrl({
    required String appName,
    required String siteId,
    required String fileName,
    int? expirationDays,
  }) async {
    final internalStorage = HyttaHubInternalStorageFactory.getInternalStorage(StorageEnum.localStorage);
    final path = firebaseFilesPath(siteId, fileName);
    return await internalStorage.getDownloadUrl(path);
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    final internalStorage = HyttaHubInternalStorageFactory.getInternalStorage(StorageEnum.localStorage);
    return await internalStorage.listFiles(prefix);
  }
}

class SembastHyttaHubBatch implements HyttaHubBatch {
  final Transaction _txn;
  final SembastHyttaHubStorage _storage;
  final List<Future Function()> _tasks = [];

  SembastHyttaHubBatch(this._txn, this._storage);

  @override
  void setDocument(String path, String docId, Map<String, dynamic> data) {
    _tasks.add(() async {
      final store = stringMapStoreFactory.store(path);
      await store.record(docId).put(_txn, data);
      _storage._updateController.add({'path': path, 'docId': docId});
    });
  }

  @override
  void updateDocument(String path, String docId, Map<String, dynamic> data) {
    _tasks.add(() async {
      final store = stringMapStoreFactory.store(path);
      await store.record(docId).update(_txn, data);
      _storage._updateController.add({'path': path, 'docId': docId});
    });
  }

  @override
  void commit() {
    // We don't execute here because we can't await. 
    // We rely on the runBatch wrapper to execute _tasks.
    // However, the interface contract might expect commit() to be the trigger.
    // But since it returns void, we can't bubble errors or completion.
    // This is a design limitation of the Sync batch interface for Async backends.
    // For now, we will do nothing here and let runBatch handle it.
  }
  
  Future<void> commitAsync() async {
    for (var task in _tasks) {
      await task();
    }
  }
}

// Extension to run the batch tasks
extension on SembastHyttaHubStorage {
   Future<void> runBatchInternal(Future<void> Function(HyttaHubBatch batch) action) async {
    final db = await _readyDb;
    await db.transaction((txn) async {
       final batch = SembastHyttaHubBatch(txn, this);
       await action(batch); // User queues ops
       await batch.commitAsync(); // We execute them
    });
   }
}
