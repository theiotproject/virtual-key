import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_key/emergency_open.dart';

void main() {
  Widget createWidgetUnderTest = const MediaQuery(
      data: MediaQueryData(), child: MaterialApp(home: EmergencyOpen()));

  testWidgets('Generate backup QR code widget test',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(createWidgetUnderTest);
      var textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, '987test1-123c-456e-9ad8-4cd65398a8a7');
      var button = find.text('Generate');
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pump();
      expect(find.text('Code accepted'), findsOneWidget);
    });
  });
}
