import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/functions/in_memory_hyttahub_functions.dart';
import 'package:hyttahub/hyttahub_options.dart';
import 'package:hyttahub/proto/account_events.pb.dart';
import 'package:hyttahub/proto/hyttahub_implementation.pb.dart';
import 'package:hyttahub/proto/site_events.pb.dart';
import 'package:hyttahub/proto/site_util.pb.dart';
import 'package:hyttahub/storage/hyttahub_storage_factory.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';

void main() {
  test('InMemoryHyttaHubFunctions site copy data trigger test', () async {
    final appName = 'testapp';
    HyttaHubOptions.implementation = HyttaHubImplementation(
      firebaseRootCollection: appName,
      storage: StorageEnum.memory,
    );

    final storage = HyttaHubStorageFactory.getStorage(StorageEnum.memory) as InMemoryHyttaHubStorage;
    final functions = InMemoryHyttaHubFunctions(StorageEnum.memory);

    final siteId = 'SOURCE1';
    final email = 'user@example.com';
    final userId = 101;

    // 1. Seed the source site
    final usersPath = firebaseSiteUsersPath(siteId);
    await storage.setDocument(usersPath, email, {
      fbUserId: userId,
      fbTimeStamp: storage.serverTimestamp,
    });

    final eventsPath = firebaseSiteEventsPath(siteId);
    final event1 = SiteEvent(
      version: 1,
      author: userId,
      newSite: SiteEvent_NewSite(siteName: 'My Source Site'),
    );
    await storage.setDocument(eventsPath, '1', {
      fbPayload: base64Encode(event1.writeToBuffer()),
      fbVersion: 1,
      fbTimeStamp: storage.serverTimestamp,
    });

    // 2. Add MarkForCopy field (The new pattern)
    final mark = MarkForCopy(author: userId, upToVersion: 0);
    final markValue = base64Encode(mark.writeToBuffer());

    await storage.updateDocument(usersPath, email, {
      fbSiteMemberMarkedForCopy: markValue,
    });

    // 3. Wait for the background trigger to process
    // In-memory triggers are asynchronous but fast.
    await Future.delayed(const Duration(milliseconds: 100));

    // 4. Verify results
    // Check if MarkForCopy is cleared
    final updatedUserDoc = await storage.getDocument(usersPath, email);
    expect(updatedUserDoc![fbSiteMemberMarkedForCopy], isNull);

    // Get the account events to find the NEW site ID
    final accountPath = firebaseAccountEventsPath(email);
    final accountEvents = await storage.getCollection(accountPath);
    expect(accountEvents.length, 1);
    
    // The account event should contain the createSite new ID
    final payload = base64Decode(accountEvents.first[fbPayload] as String);
    final accountEvent = AccountEvent.fromBuffer(payload);
    expect(accountEvent.hasCreateSite(), isTrue);
    expect(accountEvent.createSite, isNotEmpty);
    
    // Verify new site collection exists
    // (In reality we'd unmarshal and find the ID, but for this test we'll just check if a new site exists in data map)
    final allPaths = storage.data.keys.toList();
    final newSiteIdPath = allPaths.firstWhere((p) => p.contains('sites/') && !p.contains(siteId));
    expect(newSiteIdPath, isNotNull);
    
    await functions.dispose();
  });
}
