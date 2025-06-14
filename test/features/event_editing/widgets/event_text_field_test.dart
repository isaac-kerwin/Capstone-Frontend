import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_editing/widgets/event_text_field.dart';

void main() {
  group('EventTextField Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController(text: 'Initial');
    });

    testWidgets('displays initial text and label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventTextField(
              label: 'Test Label',
              controller: controller,
            ),
          ),
        ),
      );

      // verify text field shows initial value
      expect(find.text('Initial'), findsOneWidget);
      // verify label text
      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('updates controller on user input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventTextField(
              label: 'Label',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'New Value');
      expect(controller.text, equals('New Value'));
    });
  });
}
