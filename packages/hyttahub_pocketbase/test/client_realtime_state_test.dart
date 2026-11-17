// Copyright (c) 2026 bjorge

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:hyttahub_pocketbase/pocketbase_hyttahub_storage.dart';

/// A PocketBase client whose HTTP layer fails loudly.
///
/// None of these tests should reach the network: with no active subscriptions
/// `realtime.unsubscribe()` short-circuits before sending anything, and the
/// restart/refresh callbacks are supplied by the test.
PocketBase _offlineClient() => PocketBase(
      'http://127.0.0.1:8090',
      httpClientFactory: () => MockClient(
        (request) async => fail('unexpected HTTP call to ${request.url}'),
      ),
    );

/// Fires the SDK's disconnect callback the way `SseClient` does on an
/// unexpected drop: with the still-active subscriptions.
void _simulateUnexpectedDisconnect(PocketBase pb) {
  pb.realtime.onDisconnect?.call({
    'hyttahub_site_events': <SubscriptionFunc>[],
  });
}

void main() {
  group('ClientRealtimeState listener registry', () {
    test('forceReconnect restarts every registered listener', () async {
      final state = ClientRealtimeState(_offlineClient());
      final restarted = <String>[];

      Future<void> restartA() async => restarted.add('a');
      Future<void> restartB() async => restarted.add('b');
      Future<bool> refresh() async => true;

      state.registerListener(restart: restartA, refresh: refresh);
      state.registerListener(restart: restartB, refresh: refresh);

      await state.forceReconnect();

      expect(restarted, unorderedEquals(['a', 'b']));
    });

    test('unregistered listeners are not restarted', () async {
      final state = ClientRealtimeState(_offlineClient());
      var restarts = 0;

      Future<void> restart() async => restarts++;
      Future<bool> refresh() async => true;

      state.registerListener(restart: restart, refresh: refresh);
      state.unregisterListener(restart: restart, refresh: refresh);

      await state.forceReconnect();

      expect(restarts, 0);
      expect(state.activeListeners, isEmpty);
      expect(state.activeRefreshers, isEmpty);
    });
  });

  group('ClientRealtimeState.forceReconnect', () {
    test('spans the restarts, not just the teardown', () async {
      // The whole point of awaiting the restarts: a second forceReconnect
      // arriving mid-restart must not tear down subscriptions that are still
      // being established.
      final state = ClientRealtimeState(_offlineClient());
      final restartGate = Completer<void>();

      state.registerListener(
        restart: () => restartGate.future,
        refresh: () async => true,
      );

      final reconnect = state.forceReconnect();
      var done = false;
      unawaited(reconnect.then((_) => done = true));

      // Let the teardown complete; the restart is still pending.
      await Future<void>.delayed(Duration.zero);
      expect(done, isFalse, reason: 'reconnect completed before the restart');
      expect(state.reconnectingFuture, isNotNull);

      restartGate.complete();
      await reconnect;

      expect(done, isTrue);
      expect(state.reconnectingFuture, isNull);
    });

    test('concurrent calls share one teardown and one restart pass', () async {
      final state = ClientRealtimeState(_offlineClient());
      final restartGate = Completer<void>();
      var restarts = 0;

      state.registerListener(
        restart: () {
          restarts++;
          return restartGate.future;
        },
        refresh: () async => true,
      );

      final first = state.forceReconnect();
      final second = state.forceReconnect();
      final third = state.forceReconnect();

      expect(identical(first, second), isTrue);
      expect(identical(first, third), isTrue);

      restartGate.complete();
      await first;

      expect(restarts, 1);
    });

    test('a restart that never finishes does not pin the state forever', () {
      // A listener parked in its retry loop must not block every later
      // reconnect and gap refresh.
      fakeAsync((async) {
        final state = ClientRealtimeState(_offlineClient());

        state.registerListener(
          restart: () => Completer<void>().future, // never completes
          refresh: () async => true,
        );

        var done = false;
        unawaited(state.forceReconnect().then((_) => done = true));

        async.elapse(const Duration(seconds: 29));
        expect(done, isFalse);
        expect(state.reconnectingFuture, isNotNull);

        async.elapse(const Duration(seconds: 2));
        expect(done, isTrue, reason: 'restart timeout did not fire');
        expect(state.reconnectingFuture, isNull);
      });
    });

    test('a failing restart does not block the others', () async {
      final state = ClientRealtimeState(_offlineClient());
      var restartedOther = false;

      state.registerListener(
        restart: () async => throw StateError('boom'),
        refresh: () async => true,
      );
      state.registerListener(
        restart: () async => restartedOther = true,
        refresh: () async => true,
      );

      await state.forceReconnect();

      expect(restartedOther, isTrue);
      expect(state.reconnectingFuture, isNull);
    });
  });

  group('ClientRealtimeState refresh after auto-reconnect', () {
    test('retries on backoff until every listener is caught up', () {
      fakeAsync((async) {
        final pb = _offlineClient();
        final state = ClientRealtimeState(pb);

        var attempts = 0;
        state.registerListener(
          restart: () async {},
          // Offline for the first two attempts, then succeeds.
          refresh: () async => ++attempts >= 3,
        );

        _simulateUnexpectedDisconnect(pb);

        async.elapse(ClientRealtimeState.refreshBackoff[0]);
        expect(attempts, 1, reason: 'first attempt should fire on backoff[0]');

        async.elapse(ClientRealtimeState.refreshBackoff[1]);
        expect(attempts, 2);

        async.elapse(ClientRealtimeState.refreshBackoff[2]);
        expect(attempts, 3);

        // Succeeded — the chain stops rather than running out the backoff.
        async.elapse(const Duration(minutes: 1));
        expect(attempts, 3);
      });
    });

    test('gives up after the backoff list is exhausted', () {
      fakeAsync((async) {
        final pb = _offlineClient();
        final state = ClientRealtimeState(pb);

        var attempts = 0;
        state.registerListener(
          restart: () async {},
          refresh: () async {
            attempts++;
            return false; // never recovers
          },
        );

        _simulateUnexpectedDisconnect(pb);
        async.elapse(const Duration(minutes: 5));

        expect(attempts, ClientRealtimeState.refreshBackoff.length);
      });
    });

    test('a throwing refresher counts as a failure, not an escaped error', () {
      fakeAsync((async) {
        final pb = _offlineClient();
        final state = ClientRealtimeState(pb);

        var attempts = 0;
        state.registerListener(
          restart: () async {},
          refresh: () async {
            attempts++;
            throw StateError('offline');
          },
        );

        _simulateUnexpectedDisconnect(pb);
        async.elapse(const Duration(minutes: 5));

        // Retried like any other failure; the rejection never escaped the
        // Timer's zone (fakeAsync would surface it as a test failure).
        expect(attempts, ClientRealtimeState.refreshBackoff.length);
      });
    });

    test('a clean unsubscribe-all disconnect does not trigger a refresh', () {
      fakeAsync((async) {
        final pb = _offlineClient();
        final state = ClientRealtimeState(pb);

        var attempts = 0;
        state.registerListener(
          restart: () async {},
          refresh: () async {
            attempts++;
            return true;
          },
        );

        // Empty subscriptions means we closed the connection ourselves.
        pb.realtime.onDisconnect?.call({});
        async.elapse(const Duration(minutes: 5));

        expect(attempts, 0);
      });
    });

    test('forceReconnect supersedes a pending refresh', () {
      fakeAsync((async) {
        final pb = _offlineClient();
        final state = ClientRealtimeState(pb);

        var refreshes = 0;
        var restarts = 0;
        state.registerListener(
          restart: () async => restarts++,
          refresh: () async {
            refreshes++;
            return true;
          },
        );

        _simulateUnexpectedDisconnect(pb);
        // Reconnect before the first backoff delay elapses.
        unawaited(state.forceReconnect());
        async.elapse(const Duration(minutes: 5));

        expect(restarts, 1);
        expect(refreshes, 0, reason: 'the restart already re-seeds');
      });
    });

    test('chains to a previously installed onDisconnect handler', () {
      final pb = _offlineClient();
      var previousCalled = false;
      pb.realtime.onDisconnect = (_) => previousCalled = true;

      ClientRealtimeState(pb);
      _simulateUnexpectedDisconnect(pb);

      expect(previousCalled, isTrue);
    });
  });
}
