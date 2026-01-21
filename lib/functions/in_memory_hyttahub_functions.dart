// Copyright (c) 2025 bjorge

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:get_it/get_it.dart';
import 'package:archive/archive.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/functions/base_hyttahub_functions.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/storage/hyttahub_internal_storage_factory.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';
import 'package:hyttahub/storage/sembast_hyttahub_storage.dart';

class InMemoryHyttaHubFunctions implements BaseHyttaHubFunctions {
  final StorageEnum _type;
  StreamSubscription? _storageSubscription;

  InMemoryHyttaHubFunctions(this._type) {
    _init();
  }

  void _init() {
    final storage = HyttaHubStorageFactory.getStorage(_type);
    if (storage is InMemoryHyttaHubStorage) {
      _storageSubscription = storage.updates.listen(_handleUpdate);
    } else if (storage is SembastHyttaHubStorage) {
      _storageSubscription = storage.updates.listen(_handleUpdate);
    }
  }

  void _handleUpdate(Map<String, dynamic> update) {
    final path = update['path'] as String;
    final docId = update['docId'] as String;
    
    // Pattern: hyttahub/{appName}/sites/{siteId}/site_exports
    final segments = path.split('/');
    if (segments.length == 5 &&
        segments[0] == 'hyttahub' &&
        segments[2] == 'sites' &&
        segments[4] == 'site_exports' &&
        docId == 'export_request') {
      final appName = segments[1];
      final siteId = segments[3];
      _simulateBackupSite(appName, siteId);
    }
  }

  Future<void> _simulateBackupSite(String appName, String siteId) async {
    final storage = HyttaHubStorageFactory.getStorage(_type);
    final fileStorage = HyttaHubInternalStorageFactory.getInternalStorage(_type);

    // 1. Get all events
    final sitePath = 'hyttahub/$appName/sites/$siteId/site_events';
    final events = await storage.getCollection(sitePath, orderBy: fbVersion);

    // 2. Create events.txt
    final eventsBuffer = StringBuffer();
    for (final event in events) {
      final record = SiteEventRecord(
        isoDate: (event[fbTimeStamp] as DateTime).toIso8601String(),
        version: event[fbVersion] as int,
        siteEvent: SiteEvent.fromBuffer(base64Decode(event[fbPayload] as String)),
      );
      eventsBuffer.writeln(base64Encode(record.writeToBuffer()));
    }

    final archive = Archive();
    final eventsData = utf8.encode(eventsBuffer.toString());
    archive.addFile(ArchiveFile('events.txt', eventsData.length, eventsData));

    // 3. Get all files
    // In our in-memory internal storage, the files are in a Map.
    // We can't easily iterate through all files in a prefix in BaseHyttaHubInternalStorage,
    // but InMemoryHyttaHubInternalStorage has them. 
    // Actually, BaseHyttaHubInternalStorage has listFiles!
    final filesPrefix = firebaseFilesPath(siteId, ''); // Prefix for all site files
    final filePaths = await fileStorage.listFiles(filesPrefix);

    for (final path in filePaths) {
      final data = await fileStorage.downloadFile(path);
      final fileName = path.split('/').last;
      archive.addFile(ArchiveFile('storage/$fileName', data.length, data));
    }

    // 4. Encode as TAR
    final tarData = TarEncoder().encode(archive);
    
    // 5. Upload to exports
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final exportFileName = 'export_$timestamp.tar';
    final exportPath = firebaseExportsPath(siteId, exportFileName);
    
    await fileStorage.uploadFile(exportPath, Uint8List.fromList(tarData));
  }

  @override
  Future<Map<String, dynamic>> importSite({
    String? base64Data,
    String? storagePath,
    required String appName,
  }) async {
    final storage = HyttaHubStorageFactory.getStorage(_type);
    final fileStorage = HyttaHubInternalStorageFactory.getInternalStorage(_type);
    final newSiteId = _generateId();

    Uint8List tarBytes;
    if (storagePath != null) {
      tarBytes = await fileStorage.downloadFile(storagePath);
      await fileStorage.deleteFile(storagePath);
    } else if (base64Data != null) {
      tarBytes = base64Decode(base64Data);
    } else {
      throw Exception('Either base64Data or storagePath must be provided');
    }

    final archive = TarDecoder().decodeBytes(tarBytes);
    String? eventsContent;
    final adminMembers = <Map<String, dynamic>>[];

    for (final file in archive) {
      if (file.name == 'events.txt') {
        eventsContent = utf8.decode(file.content as List<int>);
      } else if (file.name.startsWith('storage/') && file.isFile) {
        final fileName = file.name.substring('storage/'.length);
        final photoPath = firebaseFilesPath(newSiteId, fileName);
        await fileStorage.uploadFile(photoPath, Uint8List.fromList(file.content as List<int>));
      }
    }

    if (eventsContent == null) {
      throw Exception('events.txt not found in archive');
    }

    final eventLines = eventsContent.split('\n').where((l) => l.isNotEmpty).toList();
    final sitePath = 'hyttahub/$appName/sites/$newSiteId/site_events';

    await storage.runBatch((batch) async {
      final membersMap = <int, SiteReplayBlocState_Member>{};
      for (final line in eventLines) {
        final record = SiteEventRecord.fromBuffer(base64Decode(line));
        final event = record.siteEvent;
        
        batch.setDocument(
          sitePath,
          record.version.toString(),
          {
            fbPayload: base64Encode(event.writeToBuffer()),
            fbTimeStamp: DateTime.parse(record.isoDate),
            fbVersion: record.version,
          },
        );

        // Identify active members by replaying site events
        if (event.hasNewSite()) {
          membersMap[record.version] = SiteReplayBlocState_Member(
            name: event.newSite.memberName,
            admin: true,
          );
        } else if (event.hasAddMember()) {
          membersMap[record.version] = SiteReplayBlocState_Member(
            name: event.addMember.memberName,
            admin: event.addMember.admin,
          );
        } else if (event.hasUpdateMember()) {
          final id = event.updateMember.memberId;
          if (membersMap.containsKey(id)) {
            membersMap[id]!.name = event.updateMember.memberName;
            membersMap[id]!.admin = event.updateMember.admin;
          }
        } else if (event.hasRemoveMember()) {
          membersMap.remove(event.removeMember.memberId);
        } else if (event.hasLeaveSite()) {
          membersMap.remove(event.leaveSite.memberId);
        } else if (event.hasRestoreMember()) {
          membersMap[event.restoreMember.memberId] = SiteReplayBlocState_Member(
            name: event.restoreMember.memberName,
            admin: event.restoreMember.admin,
          );
        } else if (event.hasImportEvent()) {
          final authorId = event.author;
          membersMap.removeWhere((id, _) => id != authorId);
        }
      }
      
      adminMembers.addAll(membersMap.entries
          .where((e) => e.value.admin)
          .map((e) => {'memberId': e.key.toString(), 'name': e.value.name}));
    });

    return {
      'siteId': newSiteId,
      'adminMembers': adminMembers,
    };
  }

  @override
  Future<void> assignUserToImportedSite({
    required String siteId,
    required String memberId,
    required String appName,
  }) async {
    final storage = HyttaHubStorageFactory.getStorage(_type);
    final email = GetIt.instance<AuthBloc>().state.email;
    
    if (email.isEmpty) throw Exception('User not authenticated');

    // 1. Add user to site_users
    await storage.setDocument(
      'hyttahub/$appName/sites/$siteId/site_users',
      email,
      {
        fbUserId: int.parse(memberId),
        fbTimeStamp: storage.serverTimestamp,
      },
    );

    // 2. Add joinSite event to account_events
    final accountPath = 'hyttahub/$appName/accounts/$email/account_events';
    final accountEvents = await storage.getCollection(accountPath, orderBy: fbVersion, descending: true);
    final nextAccountVersion = accountEvents.isEmpty ? 1 : (accountEvents.first[fbVersion] as int) + 1;
    
    final joinSiteEvent = AccountEvent(
      joinSite: siteId,
      version: nextAccountVersion,
    );
    
    await storage.setDocument(
      accountPath,
      nextAccountVersion.toString(),
      {
        fbPayload: base64Encode(joinSiteEvent.writeToBuffer()),
        fbTimeStamp: storage.serverTimestamp,
        fbVersion: nextAccountVersion,
      },
    );

    // 3. Add importEvent to site_events
    final sitePath = 'hyttahub/$appName/sites/$siteId/site_events';
    final siteEvents = await storage.getCollection(sitePath, orderBy: fbVersion, descending: true);
    final nextSiteVersion = siteEvents.isEmpty ? 1 : (siteEvents.first[fbVersion] as int) + 1;

    final importSiteEvent = SiteEvent(
      importEvent: SiteEvent_ImportEvent(),
      version: nextSiteVersion,
      author: int.parse(memberId),
    );

    await storage.setDocument(
      sitePath,
      nextSiteVersion.toString(),
      {
        fbPayload: base64Encode(importSiteEvent.writeToBuffer()),
        fbTimeStamp: storage.serverTimestamp,
        fbVersion: nextSiteVersion,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> listExports({
    required String siteId,
    required String appName,
  }) async {
    final fileStorage = HyttaHubInternalStorageFactory.getInternalStorage(_type);
    final prefix = firebaseExportsPath(siteId, '');
    final files = await fileStorage.listFiles(prefix);
    
    final result = <Map<String, dynamic>>[];
    for (final filePath in files) {
      final url = await fileStorage.getDownloadUrl(filePath);
      result.add({
        'name': filePath.split('/').last,
        'url': url,
      });
    }
    
    return {'files': result};
  }

  @override
  Future<void> deleteExport({
    required String siteId,
    required String appName,
    required String fileName,
  }) async {
    final fileStorage = HyttaHubInternalStorageFactory.getInternalStorage(_type);
    final path = firebaseExportsPath(siteId, fileName);
    await fileStorage.deleteFile(path);
  }

  @override
  Future<Map<String, dynamic>> getExportDetails({
    required String siteId,
    required String appName,
    required String fileName,
  }) async {
    final fileStorage = HyttaHubInternalStorageFactory.getInternalStorage(_type);
    final path = firebaseExportsPath(siteId, fileName);
    
    final tarBytes = await fileStorage.downloadFile(path);
    final archive = TarDecoder().decodeBytes(tarBytes);
    
    for (final file in archive) {
      if (file.name == 'events.txt') {
        return {'events': utf8.decode(file.content as List<int>)};
      }
    }
    
    return {'events': ''};
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(5);
  }

  @override
  Future<void> dispose() async {
    await _storageSubscription?.cancel();
  }
}
