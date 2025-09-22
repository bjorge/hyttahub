import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/common_widgets/layout.dart';
import 'package:hyttahub/l10n/intl_localizations.dart';

void main() {
  group('CommonListViewLayout', () {
    testWidgets('renders children correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CommonListViewLayout(
            children: [Text('child')],
          ),
        ),
      );

      expect(find.text('child'), findsOneWidget);
    });

    testWidgets('renders children with spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CommonListViewLayout(
            spacing: 10,
            children: [Text('child1'), Text('child2')],
          ),
        ),
      );

      final text1 = tester.getCenter(find.text('child1'));
      final text2 = tester.getCenter(find.text('child2'));
      expect(text2.dy - text1.dy, greaterThan(10));
    });
  });

  group('commonAlertDialog', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            HyttaHubLocalizations.delegate,
          ],
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => commonAlertDialog(
                      context,
                      'Test Title',
                      const Text('Test Content'),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pump();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
    });
  });
}
