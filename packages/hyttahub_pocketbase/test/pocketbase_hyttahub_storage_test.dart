// Copyright (c) 2026 bjorge

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub/storage/base_hyttahub_storage.dart';
import 'package:hyttahub_pocketbase/pocketbase_hyttahub_storage.dart';

void main() {
  _versionFilterTests();

  group('PocketbaseHyttaHubStorage Batch Support', () {
    test('runBatch sends queued setDocument and updateDocument requests to /api/batch', () async {
      String? capturedPath;
      String? capturedMethod;
      Map<String, dynamic>? capturedBody;

      final mockClient = MockClient((request) async {
        capturedPath = request.url.path;
        capturedMethod = request.method;

        if (request.url.path == '/api/collections/hyttahub_site_users/records') {
          // Response for _findRecord lookup during updateDocument
          return http.Response(
            jsonEncode({
              'page': 1,
              'perPage': 30,
              'totalItems': 1,
              'totalPages': 1,
              'items': [
                {
                  'id': 'rec123456789012',
                  'doc_id': 'user@example.com',
                  'app': 'testapp',
                  'siteId': 'site1',
                }
              ]
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        if (request.url.path == '/api/batch') {
          capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode([
              {
                'status': 200,
                'body': {'id': 'rec111111111111', 'doc_id': 'newuser@example.com'}
              },
              {
                'status': 200,
                'body': {'id': 'rec123456789012', 'doc_id': 'user@example.com'}
              }
            ]),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        return http.Response('{}', 404);
      });

      final pb = PocketBase(
        'http://127.0.0.1:8090',
        httpClientFactory: () => mockClient,
      );

      final storage = PocketbaseHyttaHubStorage(client: pb);

      await storage.runBatch((batch) async {
        batch.setDocument(
          'hyttahub/testapp/sites/site1/site_users',
          'newuser@example.com',
          {'role': 'admin'},
        );
        batch.updateDocument(
          'hyttahub/testapp/sites/site1/site_users',
          'user@example.com',
          {'role': 'editor'},
        );
      });

      expect(capturedPath, equals('/api/batch'));
      expect(capturedMethod, equals('POST'));
      expect(capturedBody, isNotNull);

      final requests = capturedBody!['requests'] as List<dynamic>;
      expect(requests.length, equals(2));

      expect(requests[0]['method'], equals('POST'));
      expect(requests[0]['url'], contains('/api/collections/hyttahub_site_users/records'));
      expect(requests[0]['body']['doc_id'], equals('newuser@example.com'));
      expect(requests[0]['body']['role'], equals('admin'));

      expect(requests[1]['method'], equals('PATCH'));
      expect(requests[1]['url'], contains('/api/collections/hyttahub_site_users/records/rec123456789012'));
      expect(requests[1]['body']['role'], equals('editor'));
    });

    test('runBatch does nothing if no operations are queued', () async {
      var called = false;
      final mockClient = MockClient((request) async {
        called = true;
        return http.Response('[]', 200);
      });

      final pb = PocketBase(
        'http://127.0.0.1:8090',
        httpClientFactory: () => mockClient,
      );

      final storage = PocketbaseHyttaHubStorage(client: pb);

      await storage.runBatch((batch) async {});

      expect(called, isFalse);
    });
  });
}

void _versionFilterTests() {
  group('PocketbaseHyttaHubStorage version filter', () {
    test('narrows the read server-side alongside the path filter', () async {
      String? capturedFilter;
      final mockClient = MockClient((request) async {
        capturedFilter = request.url.queryParameters['filter'];
        return http.Response(
          jsonEncode({
            'page': 1,
            'perPage': 500,
            'totalItems': 0,
            'totalPages': 1,
            'items': <dynamic>[],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final storage = PocketbaseHyttaHubStorage(
        client: PocketBase('http://127.0.0.1:8090',
            httpClientFactory: () => mockClient),
      );

      await storage.getCollection(
        'hyttahub/testapp/sites/site1/site_events',
        newerThan: const VersionFilter(field: 'v', version: 42),
      );

      expect(capturedFilter, contains('app = "testapp"'));
      expect(capturedFilter, contains('siteId = "site1"'));
      expect(capturedFilter, contains('v > 42'));
    });

    test('rejects a field name that is not a plain identifier', () async {
      final storage = PocketbaseHyttaHubStorage(
        client: PocketBase(
          'http://127.0.0.1:8090',
          httpClientFactory: () => MockClient(
            (request) async => fail('request should never be sent'),
          ),
        ),
      );

      // The field is a bare identifier in the filter expression, so it cannot
      // be quoted the way values are.
      expect(
        () => storage.getCollection(
          'hyttahub/testapp/sites/site1/site_events',
          newerThan: const VersionFilter(field: 'v || 1=1', version: 0),
        ),
        throwsArgumentError,
      );
    });
  });
}
