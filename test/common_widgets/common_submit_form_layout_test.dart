import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_widgets/common_submit_form_layout.dart';
import 'package:hyttahub/common_blocs/base_submit_bloc.dart';
import 'package:hyttahub/proto/common_blocs.pb.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';

void main() {
  group('CommonSubmitFormLayout', () {
    testWidgets('renders children correctly', (WidgetTester tester) async {
      final state = BaseSubmitState<CommonSubmitBlocState>(
        payload: CommonSubmitBlocState(),
        submissionState: CommonSubmitBlocState(
          state: CommonSubmitBlocState_State.ready,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: CommonSubmitFormLayout(
            submitState: state,
            children: const [Text('child')],
          ),
        ),
      );

      expect(find.text('child'), findsOneWidget);
    });

    testWidgets('renders progress indicator when submitting',
        (WidgetTester tester) async {
      final state = BaseSubmitState<CommonSubmitBlocState>(
        payload: CommonSubmitBlocState(),
        submissionState: CommonSubmitBlocState(
          state: CommonSubmitBlocState_State.submitting,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: CommonSubmitFormLayout(
            submitState: state,
            children: const [Text('child')],
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error message on error', (WidgetTester tester) async {
      final state = BaseSubmitState<CommonSubmitBlocState>(
        payload: CommonSubmitBlocState(),
        submissionState: CommonSubmitBlocState(
          state: CommonSubmitBlocState_State.error,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: Scaffold(
            body: CommonSubmitFormLayout(
              submitState: state,
              children: const [Text('child')],
            ),
          ),
        ),
      );

      expect(find.text('Form submission error'), findsOneWidget);
    });

    testWidgets('renders permission denied message on permission denied error',
        (WidgetTester tester) async {
      final state = BaseSubmitState<CommonSubmitBlocState>(
        payload: CommonSubmitBlocState(),
        submissionState: CommonSubmitBlocState(
          state: CommonSubmitBlocState_State.error,
          errorCode: CommonSubmitBlocState_ErrorCode.permissionDenied,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: Scaffold(
            body: CommonSubmitFormLayout(
              submitState: state,
              children: const [Text('child')],
            ),
          ),
        ),
      );

      expect(find.text('Permission Denied'), findsOneWidget);
    });
  });
}
