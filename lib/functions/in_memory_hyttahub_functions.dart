// Copyright (c) 2025 bjorge

import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:hyttahub/auth_bloc/auth_bloc.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/functions/base_hyttahub_functions.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';

class InMemoryHyttaHubFunctions implements BaseHyttaHubFunctions {
  final StorageEnum _type;

  InMemoryHyttaHubFunctions(this._type);
  @override
  Future<Map<String, dynamic>> copySite({
    required String siteId,
    required String appName,
    int? upToVersion,
  }) async {
    final storage = HyttaHubStorageFactory.getStorage(_type);
    final newSiteId = _generateId();
    final email = GetIt.instance<AuthBloc>().state.email;
    
    if (email.isEmpty) throw Exception('User not authenticated');

    // 1. Verify user is in old site's site_users
    final oldUserDoc = await storage.getDocument(
      'hyttahub/$appName/sites/$siteId/site_users',
      email,
    );
    if (oldUserDoc == null) {
      throw Exception('User is not a member of the site to copy');
    }
    final userId = oldUserDoc[fbUserId] as int;

    // 2. Copy events
    final oldSitePath = 'hyttahub/$appName/sites/$siteId/site_events';
    final newSitePath = 'hyttahub/$appName/sites/$newSiteId/site_events';
    final oldEvents = await storage.getCollection(oldSitePath, orderBy: fbVersion);

    int lastVersion = 0;
    await storage.runBatch((batch) async {
      for (final event in oldEvents) {
        final version = event[fbVersion] as int;
        
        // Skip events after upToVersion if specified
        if (upToVersion != null && version > upToVersion) {
          continue;
        }

        if (version > lastVersion) lastVersion = version;
        
        batch.setDocument(
          newSitePath,
          version.toString(),
          event,
        );
      }

      // 3. Add ImportEvent (Copy Event) to new site
      final newSiteEventVersion = lastVersion + 1;
      final importSiteEvent = SiteEvent(
        importEvent: SiteEvent_ImportEvent(),
        version: newSiteEventVersion,
        author: userId,
      );

      batch.setDocument(
        newSitePath,
        newSiteEventVersion.toString(),
        {
          fbPayload: base64Encode(importSiteEvent.writeToBuffer()),
          fbTimeStamp: storage.serverTimestamp,
          fbVersion: newSiteEventVersion,
        },
      );

      // 4. Add current user to new site_users
      batch.setDocument(
        'hyttahub/$appName/sites/$newSiteId/site_users',
        email,
        {
          fbUserId: userId,
          fbTimeStamp: storage.serverTimestamp,
        },
      );

      // 5. Add joinSite event to account events
      // Handle account events 
    });


    final accountPath = 'hyttahub/$appName/accounts/$email/account_events';
    final accountEvents = await storage.getCollection(accountPath, orderBy: fbVersion, descending: true);
    final nextAccountVersion = accountEvents.isEmpty ? 1 : (accountEvents.first[fbVersion] as int) + 1;
    
    final joinSiteEvent = AccountEvent(
      joinSite: newSiteId,
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

    // 6. Copy storage items
    final filesPrefix = firebaseFilesPath(siteId, '');
    final filePaths = await storage.listFiles(filesPrefix);

    for (final path in filePaths) {
      final fileName = path.split('/').last;
      final data = await storage.getFileBytes(
        appName: appName,
        siteId: siteId,
        fileName: fileName,
      );
      
      await storage.uploadFile(
        appName: appName,
        siteId: newSiteId,
        fileName: fileName,
        base64Data: base64Encode(data),
      );
    }

    return {
      'siteId': newSiteId,
    };
  }

  @override
  Future<Map<String, dynamic>> listSiteFiles({
    required String siteId,
    required String appName,
  }) async {
    final storage = HyttaHubStorageFactory.getStorage(_type);
    final prefix = firebaseFilesPath(siteId, '');
    final files = await storage.listFiles(prefix);
    
    final result = <Map<String, dynamic>>[];
    for (final filePath in files) {
      final bytes = await storage.getFileBytes(
        appName: appName,
        siteId: siteId,
        fileName: filePath.split('/').last,
      );
      result.add({
        'name': filePath.split('/').last,
        'size': bytes.length,
      });
    }
    
    return {'files': result};
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(5);
  }

  @override
  Future<void> dispose() async {
  }
}
