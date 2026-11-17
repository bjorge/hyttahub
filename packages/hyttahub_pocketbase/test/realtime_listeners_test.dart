// Copyright (c) 2026 bjorge

import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub_pocketbase/pocketbase_hyttahub_storage.dart';

/// A minimal stand-in for a PocketBase server: records the order of requests,
/// serves collection reads, and speaks just enough SSE for the SDK's realtime
/// service to consider itself connected.
class _FakeBackend {
  final List<String> requests = [];
  final Map<String, List<Map<String, dynamic>>> collections = {};
  final List<StreamController<List<int>>> _sseStreams = [];
  int sseConnections = 0;

  List<String> get recordReads => requests
      .where((r) => r.contains('/api/collections/'))
      .toList(growable: false);

  void clearRequests() => requests.clear();

  http.Client get client => MockClient.streaming((request, _) async {
        final path = request.url.path;
        requests.add('${request.method} $path');

        if (path == '/api/realtime') {
          if (request.method == 'GET') {
            return _openSseStream();
          }
          // Subscription submission.
          return http.StreamedResponse(const Stream.empty(), 204);
        }

        final match =
            RegExp(r'^/api/collections/([^/]+)/records$').firstMatch(path);
        if (match != null) {
          final items = collections[match.group(1)] ?? const [];
          return _json({
            'page': 1,
            'perPage': 500,
            'totalItems': items.length,
            'totalPages': 1,
            'items': items,
          });
        }

        return http.StreamedResponse(const Stream.empty(), 404);
      });

  http.StreamedResponse _openSseStream() {
    sseConnections++;
    final controller = StreamController<List<int>>();
    _sseStreams.add(controller);
    // The SDK only considers itself connected once PB_CONNECT arrives, and
    // only submits subscriptions after that.
    scheduleMicrotask(() {
      if (controller.isClosed) return;
      controller.add(
        utf8.encode('id:fakeclient$sseConnections\n'
            'event:PB_CONNECT\n'
            'data:{"clientId":"fakeclient$sseConnections"}\n'
            '\n'),
      );
    });
    return http.StreamedResponse(
      controller.stream,
      200,
      headers: {'content-type': 'text/event-stream'},
    );
  }

  http.StreamedResponse _json(Object body) => http.StreamedResponse(
        Stream.value(utf8.encode(jsonEncode(body))),
        200,
        headers: {'content-type': 'application/json'},
      );

  Future<void> dispose() async {
    for (final controller in _sseStreams) {
      if (!controller.isClosed) await controller.close();
    }
    _sseStreams.clear();
  }
}

Map<String, dynamic> _eventRecord({
  required String id,
  required int version,
  required String payload,
  String app = 'testapp',
  String siteId = 'site1',
}) =>
    {
      'id': id,
      'doc_id': '$version',
      'app': app,
      'siteId': siteId,
      'v': version,
      'p': payload,
    };

void main() {
  late _FakeBackend backend;
  late PocketBase pb;

  const sitePath = 'hyttahub/testapp/sites/site1/site_events';
  const siteCollection = 'hyttahub_site_events';
  const accountPath = 'hyttahub/testapp/accounts/acc1/account_events';
  const accountCollection = 'hyttahub_account_events';

  setUp(() {
    backend = _FakeBackend();
    pb = PocketBase('http://127.0.0.1:8090', httpClientFactory: () => backend.client);
  });

  tearDown(() async {
    await backend.dispose();
  });

  test('listenEvents subscribes before seeding', () async {
    // An event written while the seed fetch is in flight is in neither the
    // snapshot nor the stream. Subscribing first closes that window — seeding
    // first leaves the event unrecoverable, because every later refetch
    // filters on a watermark that subsequent events push past the hole.
    backend.collections[siteCollection] = [
      _eventRecord(id: 'rec000000000001', version: 1, payload: 'one'),
    ];

    final storage = PocketbaseHyttaHubStorage(client: pb);
    final events = <Map<int, String>>[];
    final sub = storage
        .listenEvents(
          sitePath,
          lastVersion: 0,
          versionField: 'v',
          payloadField: 'p',
        )
        .listen(events.add);

    await _until(() => events.isNotEmpty);

    expect(events.first, {1: 'one'});
    expect(
      backend.requests,
      containsAllInOrder([
        'GET /api/realtime',
        'GET /api/collections/$siteCollection/records',
      ]),
      reason: 'the SSE subscription must be established before the seed fetch',
    );

    await sub.cancel();
  });

  test('listenEvents does not re-seed already delivered versions', () async {
    backend.collections[siteCollection] = [
      _eventRecord(id: 'rec000000000001', version: 1, payload: 'one'),
      _eventRecord(id: 'rec000000000002', version: 2, payload: 'two'),
    ];

    final storage = PocketbaseHyttaHubStorage(client: pb);
    final events = <Map<int, String>>[];
    final sub = storage
        .listenEvents(
          sitePath,
          lastVersion: 1,
          versionField: 'v',
          payloadField: 'p',
        )
        .listen(events.add);

    await _until(() => events.isNotEmpty);

    expect(events.first, {2: 'two'},
        reason: 'v1 is at or below the caller-supplied lastVersion');

    await sub.cancel();
  });

  test('forceReconnect re-seeds listeners across storages sharing a client',
      () async {
    // storageBuilder hands every bloc its own storage object wrapping one
    // shared `pb`, so reconnect state has to be keyed on the client rather
    // than held per storage instance.
    backend.collections[siteCollection] = [
      _eventRecord(id: 'rec000000000001', version: 1, payload: 'one'),
    ];
    backend.collections[accountCollection] = [
      _eventRecord(id: 'rec000000000003', version: 1, payload: 'acct'),
    ];

    final siteStorage = PocketbaseHyttaHubStorage(client: pb);
    final accountStorage = PocketbaseHyttaHubStorage(client: pb);

    final siteEvents = <Map<int, String>>[];
    final accountEvents = <Map<int, String>>[];

    final siteSub = siteStorage
        .listenEvents(sitePath,
            lastVersion: 0, versionField: 'v', payloadField: 'p')
        .listen(siteEvents.add);
    final accountSub = accountStorage
        .listenEvents(accountPath,
            lastVersion: 0, versionField: 'v', payloadField: 'p')
        .listen(accountEvents.add);

    await _until(() => siteEvents.isNotEmpty && accountEvents.isNotEmpty);

    final connectionsBefore = backend.sseConnections;
    backend.clearRequests();

    // Reconnecting through one storage must restart the other's listener too.
    await siteStorage.forceReconnect();
    await _until(() => backend.recordReads.length >= 2);

    expect(
      backend.recordReads,
      containsAll([
        'GET /api/collections/$siteCollection/records',
        'GET /api/collections/$accountCollection/records',
      ]),
      reason: 'both listeners on the shared client should have re-seeded',
    );
    expect(
      backend.sseConnections,
      greaterThan(connectionsBefore),
      reason: 'the shared SSE connection should have been torn down and '
          'reopened rather than reused',
    );

    await siteSub.cancel();
    await accountSub.cancel();
  });

  test('a cancelled listener is not restarted by a later reconnect', () async {
    backend.collections[siteCollection] = [
      _eventRecord(id: 'rec000000000001', version: 1, payload: 'one'),
    ];
    backend.collections[accountCollection] = [
      _eventRecord(id: 'rec000000000003', version: 1, payload: 'acct'),
    ];

    final siteStorage = PocketbaseHyttaHubStorage(client: pb);
    final accountStorage = PocketbaseHyttaHubStorage(client: pb);

    final siteEvents = <Map<int, String>>[];
    final accountEvents = <Map<int, String>>[];

    final siteSub = siteStorage
        .listenEvents(sitePath,
            lastVersion: 0, versionField: 'v', payloadField: 'p')
        .listen(siteEvents.add);
    final accountSub = accountStorage
        .listenEvents(accountPath,
            lastVersion: 0, versionField: 'v', payloadField: 'p')
        .listen(accountEvents.add);

    await _until(() => siteEvents.isNotEmpty && accountEvents.isNotEmpty);
    await accountSub.cancel();

    backend.clearRequests();
    await siteStorage.forceReconnect();
    await _until(() => backend.recordReads.isNotEmpty);

    expect(
      backend.recordReads,
      isNot(contains('GET /api/collections/$accountCollection/records')),
      reason: 'an unregistered listener should not be re-seeded',
    );

    await siteSub.cancel();
  });
}

/// Pumps the event loop until [condition] holds, failing rather than hanging.
Future<void> _until(
  bool Function() condition, {
  int maxPumps = 2000,
}) async {
  for (var i = 0; i < maxPumps; i++) {
    if (condition()) return;
    await Future<void>.delayed(Duration.zero);
  }
  fail('condition was never met after $maxPumps pumps');
}
