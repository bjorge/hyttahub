// Copyright (c) 2026 bjorge

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub_pocketbase/pocketbase_hyttahub_storage.dart';

void main() {
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
