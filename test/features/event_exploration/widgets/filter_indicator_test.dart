import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/filter_indicator.dart';

void main() {
  group('FilterIndicator Widget Tests', () {
    late bool cleared;

    setUp(() => cleared = false);

    testWidgets('does not render when label is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FilterIndicator(label: '', onClear: () {})),
        ),
      );
      expect(find.byType(FilterIndicator), findsOneWidget);
      // Should render nothing inside
      expect(find.byIcon(Icons.filter_list), findsNothing);
    });

    testWidgets('renders label and clear button when label is non-empty', (WidgetTester tester) async {
      const testLabel = 'Filtered by: Test';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FilterIndicator(label: testLabel, onClear: () => cleared = true)),
        ),
      );
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      expect(find.text(testLabel), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);

      await tester.tap(find.text('Clear'));
      expect(cleared, isTrue);
    });
  });
}
