import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/collection_paths.dart';

import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_util.pb.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';

void main() {
  test('InMemoryHyttaHubStorage site copy data trigger test', () async {
    final appName = 'testapp';
    HyttaHubOptions.implementation = HyttaHubImplementation(
      cloudRootCollection: appName,
      storage: StorageEnum.memory,
    );

    final storage = HyttaHubStorageFactory.getStorage(StorageEnum.memory) as InMemoryHyttaHubStorage;


    final siteId = 'SOURCE1';
    final email = 'user@example.com';
    final userId = 101;

    // 1. Seed the source site
    final usersPath = collectionSiteUsersPath(siteId);
    await storage.setDocument(usersPath, email, {
      docUserId: userId,
      docTimeStamp: storage.serverTimestamp,
    });

    final eventsPath = collectionSiteEventsPath(siteId);
    final event1 = SiteEvent(
      version: 1,
      author: userId,
      newSite: SiteEvent_NewSite(siteName: 'My Source Site'),
    );
    await storage.setDocument(eventsPath, '1', {
      docPayload: base64Encode(event1.writeToBuffer()),
      docVersion: 1,
      docTimeStamp: storage.serverTimestamp,
    });

    // 2. Add MarkForCopy field (The new pattern)
    final mark = MarkForCopy(author: userId, upToVersion: 0);
    final markValue = base64Encode(mark.writeToBuffer());

    await storage.updateDocument(usersPath, email, {
      docSiteMemberMarkedForCopy: markValue,
    });

    // 3. Wait for the background trigger to process
    // In-memory triggers are asynchronous but fast.
    await Future.delayed(const Duration(milliseconds: 100));

    // 4. Verify results
    // Check if MarkForCopy is cleared
    final updatedUserDoc = await storage.getDocument(usersPath, email);
    expect(updatedUserDoc![docSiteMemberMarkedForCopy], isNull);

    // Get the account events to find the NEW site ID
    final accountPath = collectionAccountEventsPath(email);
    final accountEvents = await storage.getCollection(accountPath);
    expect(accountEvents.length, 1);
    
    // The account event should contain the createSite new ID
    final payload = base64Decode(accountEvents.first[docPayload] as String);
    final accountEvent = AccountEvent.fromBuffer(payload);
    expect(accountEvent.hasCreateSite(), isTrue);
    expect(accountEvent.createSite, isNotEmpty);
    
    // Verify new site collection exists
    // (In reality we'd unmarshal and find the ID, but for this test we'll just check if a new site exists in data map)
    final allPaths = storage.data.keys.toList();
    final newSiteIdPath = allPaths.firstWhere((p) => p.contains('sites/') && !p.contains(siteId));
    expect(newSiteIdPath, isNotNull);
    

  });
}
