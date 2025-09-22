import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_widgets/events_display.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:hyttahub/proto/site_replay_bloc.pb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyttahub/firebase_paths.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';

class MockEventsDisplayConfig extends Mock
    implements EventsDisplayConfig<SiteReplayBlocState, SiteReplayBlocState> {}

void main() {
  group('EventsDisplay', () {
    late MockEventsDisplayConfig mockConfig;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      mockConfig = MockEventsDisplayConfig();
      fakeFirestore = FakeFirebaseFirestore();
      when(mockConfig.collectionPath).thenReturn('test_path');
      when(mockConfig.screenTitle).thenReturn('Test Title');
      when(mockConfig.replayTitle).thenReturn('Replay Title');
      when(mockConfig.parseRecord(any, any, any))
          .thenReturn(SiteReplayBlocState());
      when(mockConfig.getVersion(any)).thenReturn(1);
      when(mockConfig.getIsoDate(any)).thenReturn('2025-01-01');
      when(mockConfig.replay(any)).thenReturn(SiteReplayBlocState());
    });

    testWidgets('renders loading indicator when fetching',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: EventsDisplay<SiteReplayBlocState, SiteReplayBlocState>(
            config: mockConfig,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders list of events on success',
        (WidgetTester tester) async {
      await fakeFirestore.collection('test_path').add({
        fbPayload: 'test_payload',
        fbTimeStamp: Timestamp.now(),
        fbVersion: 1,
      });

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: EventsDisplay<SiteReplayBlocState, SiteReplayBlocState>(
            config: mockConfig,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Event Version: 1'), findsOneWidget);
    });

    testWidgets('toggles between list and replay view',
        (WidgetTester tester) async {
      await fakeFirestore.collection('test_path').add({
        fbPayload: 'test_payload',
        fbTimeStamp: Timestamp.now(),
        fbVersion: 1,
      });
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: EventsDisplay<SiteReplayBlocState, SiteReplayBlocState>(
            config: mockConfig,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Event Version: 1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.replay));
      await tester.pumpAndSettle();

      expect(find.text('Event Version: 1'), findsNothing);
      expect(find.byType(SelectableText), findsOneWidget);
    });
  });
}
