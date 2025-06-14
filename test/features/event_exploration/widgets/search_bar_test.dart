import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/search_bar.dart';

void main() {
  group('SearchBar Widget Tests', () {
    late TextEditingController controller;
    late bool cleared;
    late bool filtered;
    late String submitted;

    setUp(() {
      controller = TextEditingController(text: '');
      cleared = false;
      filtered = false;
      submitted = '';
    });

    Widget buildTest() {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Test'),
          ),
          body: SearchBar(
            controller: controller,
            onSubmitted: (q) => submitted = q,
            onClear: () => cleared = true,
            onFilter: () => filtered = true,
          ),
        ),
      );
    }

    testWidgets('renders input and filter icon', (tester) async {
      await tester.pumpWidget(buildTest());
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.filter_alt), findsOneWidget);
    });

    testWidgets('onSubmitted callback works', (tester) async {
      await tester.pumpWidget(buildTest());
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(submitted, 'hello');
    });

    testWidgets('onClear appears and clears when text present', (tester) async {
      controller.text = 'abc';
      await tester.pumpWidget(buildTest());
      // suffixIcon row has clear icon
      expect(find.byIcon(Icons.clear), findsOneWidget);
      await tester.tap(find.byIcon(Icons.clear));
      expect(cleared, isTrue);
    });

    testWidgets('onFilter callback works', (tester) async {
      await tester.pumpWidget(buildTest());
      await tester.tap(find.byIcon(Icons.filter_alt));
      expect(filtered, isTrue);
    });
  });
}
