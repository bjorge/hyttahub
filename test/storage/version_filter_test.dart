// Copyright (c) 2026 bjorge

import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/collection_paths.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub/storage/in_memory_hyttahub_storage.dart';

void main() {
  group('InMemoryHyttaHubStorage version filter', () {
    late InMemoryHyttaHubStorage storage;
    const path = 'test_events';

    setUp(() async {
      storage = InMemoryHyttaHubStorage();
      for (var v = 1; v <= 5; v++) {
        await storage.setDocument(path, '$v', {
          docVersion: v,
          docPayload: 'event$v',
        });
      }
    });

    test('returns only records above the bound', () async {
      final docs = await storage.getCollection(
        path,
        newerThan: const VersionFilter(field: docVersion, version: 3),
      );

      expect(
        docs.map((d) => d[docVersion]).toList()..sort(),
        [4, 5],
      );
    });

    test('returns everything when no bound is given', () async {
      final docs = await storage.getCollection(path);
      expect(docs, hasLength(5));
    });

    test('an out-of-range bound yields nothing rather than everything',
        () async {
      final docs = await storage.getCollection(
        path,
        newerThan: const VersionFilter(field: docVersion, version: 99),
      );
      expect(docs, isEmpty);
    });

    test('records missing the field are excluded, not treated as version 0',
        () async {
      await storage.setDocument(path, 'junk', {docPayload: 'no version'});

      final docs = await storage.getCollection(
        path,
        newerThan: const VersionFilter(field: docVersion, version: 0),
      );

      expect(docs, hasLength(5));
      expect(docs.every((d) => d[docVersion] is num), isTrue);
    });

    test('composes with ordering and limit', () async {
      final docs = await storage.getCollection(
        path,
        newerThan: const VersionFilter(field: docVersion, version: 1),
        orderBy: docVersion,
        descending: true,
        limit: 2,
      );

      expect(docs.map((d) => d[docVersion]).toList(), [5, 4]);
    });
  });
}
