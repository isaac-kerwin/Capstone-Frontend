import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_exploration/screens/explore.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/category_chips.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/filter_indicator.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/search_bar.dart';

void main() {
  group('Explore Screen Tests', () {
    testWidgets('renders search bar, category chips, and filter indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Explore()),
      );

      // SearchBar uses a TextField
      expect(find.byType(TextField), findsWidgets);
      // CategoryChips present
      expect(find.byType(CategoryChips), findsOneWidget);
      // FilterIndicator present, even if empty
      expect(find.byType(FilterIndicator), findsOneWidget);
    });
  });
}
