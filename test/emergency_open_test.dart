import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_key/emergency_open.dart';

void main() {
  Widget widgetUnderTest = const MediaQuery(
      data: MediaQueryData(), child: MaterialApp(home: EmergencyOpen()));

  group('Generate backup QR code widget test', () {
    testWidgets('Test valid code', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(widgetUnderTest);
        var textField = find.byType(TextField);
        expect(textField, findsOneWidget);
        await tester.enterText(
            textField, '987test1-123c-456e-9ad8-4cd65398a8a7');
        var button = find.text('Generate');
        expect(button, findsOneWidget);
        await tester.tap(button);
        await tester.pump();
        expect(find.text('Code accepted'), findsOneWidget);
      });
    });

    testWidgets('Test invalid code', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(widgetUnderTest);
        var textField = find.byType(TextField);
        expect(textField, findsOneWidget);
        await tester.enterText(textField, 't-e-s-t-c0de');
        var button = find.text('Generate');
        expect(button, findsOneWidget);
        await tester.tap(button);
        await tester.pump();
        expect(find.text('This is not a valid code'), findsOneWidget);
      });
    });
  });
}
