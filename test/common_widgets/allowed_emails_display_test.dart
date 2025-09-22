import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_widgets/allowed_emails_display.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyttahub/common_blocs/allowed_emails_bloc.dart';
import 'package:hyttahub/proto/allowed_emails_bloc.pb.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAllowedEmailsBloc
    extends MockBloc<AllowedEmailsBlocEvent, AllowedEmailsBlocState>
    implements AllowedEmailsBloc {}

class MockAllowedEmailsDisplayConfig extends Mock
    implements AllowedEmailsDisplayConfig {}

void main() {
  group('AllowedEmailsDisplay', () {
    late MockAllowedEmailsBloc mockAllowedEmailsBloc;
    late MockAllowedEmailsDisplayConfig mockConfig;

    setUp(() {
      mockAllowedEmailsBloc = MockAllowedEmailsBloc();
      mockConfig = MockAllowedEmailsDisplayConfig();
      when(mockConfig.collectionPath).thenReturn('test_path');
      when(mockConfig.screenTitle).thenReturn('Test Title');
    });

    testWidgets('renders loading indicator when fetching',
        (WidgetTester tester) async {
      whenListen(
        mockAllowedEmailsBloc,
        Stream.value(
            AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.fetching)),
        initialState:
            AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.fetching),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: BlocProvider<AllowedEmailsBloc>.value(
            value: mockAllowedEmailsBloc,
            child: AllowedEmailsDisplay(config: mockConfig),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders list of emails on success',
        (WidgetTester tester) async {
      final emails = {
        'test1@example.com': AllowedEmailsBlocState_UserInfo(userId: 1),
        'test2@example.com': AllowedEmailsBlocState_UserInfo(userId: 2),
      };
      whenListen(
        mockAllowedEmailsBloc,
        Stream.value(
          AllowedEmailsBlocState(
            state: AllowedEmailsBlocState_State.success,
            emails: emails,
          ),
        ),
        initialState: AllowedEmailsBlocState(
          state: AllowedEmailsBlocState_State.success,
          emails: emails,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: BlocProvider<AllowedEmailsBloc>.value(
            value: mockAllowedEmailsBloc,
            child: AllowedEmailsDisplay(config: mockConfig),
          ),
        ),
      );

      expect(find.text('test1@example.com'), findsOneWidget);
      expect(find.text('test2@example.com'), findsOneWidget);
    });

    testWidgets('renders error message on error', (WidgetTester tester) async {
      whenListen(
        mockAllowedEmailsBloc,
        Stream.value(
            AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.error)),
        initialState:
            AllowedEmailsBlocState(state: AllowedEmailsBlocState_State.error),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: BlocProvider<AllowedEmailsBloc>.value(
            value: mockAllowedEmailsBloc,
            child: AllowedEmailsDisplay(config: mockConfig),
          ),
        ),
      );

      expect(find.text('Failed to load emails'), findsOneWidget);
    });
  });
}
