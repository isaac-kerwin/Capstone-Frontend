import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_editing/widgets/date_time_row.dart';

void main() {
  group('DateTimeRow Widget Tests', () {
    late bool tapped;
    const labelText = 'Start Date: 01/01/2025';

    setUp(() {
      tapped = false;
    });

    testWidgets('displays label and icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateTimeRow(
              label: labelText,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text(labelText), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateTimeRow(
              label: labelText,
              onTap: () { tapped = true; },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });
  });
}
