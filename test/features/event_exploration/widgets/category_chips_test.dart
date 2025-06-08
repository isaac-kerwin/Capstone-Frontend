import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/category_chips.dart';

void main() {
  group('CategoryChips Widget Tests', () {
    late String selectedCategory;

    setUp(() {
      selectedCategory = '';
    });

    Widget buildTest({String? active}) {
      return MaterialApp(
        home: Scaffold(
          body: CategoryChips(
            activeCategory: active,
            onSelect: (cat) => selectedCategory = cat,
          ),
        ),
      );
    }

    testWidgets('renders all category chips', (WidgetTester tester) async {
      await tester.pumpWidget(buildTest(active: null));
      expect(find.byType(Chip), findsNWidgets(4));
      expect(find.text('Sports'), findsOneWidget);
      expect(find.text('Music'), findsOneWidget);
      expect(find.text('Social'), findsOneWidget);
      expect(find.text('Volunteering'), findsOneWidget);
    });

    testWidgets('tap on chip calls onSelect', (WidgetTester tester) async {
      await tester.pumpWidget(buildTest(active: null));
      await tester.tap(find.text('Music'));
      expect(selectedCategory, 'Music');
    });

    testWidgets('activeCategory chip shows different color', (WidgetTester tester) async {
      await tester.pumpWidget(buildTest(active: 'Social'));
      final chip = tester.widget<Chip>(find.widgetWithText(Chip, 'Social'));
      expect(chip.backgroundColor, const Color(0xFF5E55FF));
    });
  });
}
