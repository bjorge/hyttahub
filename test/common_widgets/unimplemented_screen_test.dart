import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_widgets/unimplemented_screen.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';

void main() {
  group('UnimplementedScreen', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            HyttaHubLocalizations.delegate,
          ],
          home: UnimplementedScreen(),
        ),
      );

      expect(find.text('Unimplemented'), findsOneWidget);
      expect(find.text('To be implemented...'), findsOneWidget);
    });
  });
}
