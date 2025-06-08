import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_editing/screens/edit_details.dart';
import 'package:app_mobile_frontend/core/models/event.dart';
import 'package:app_mobile_frontend/core/models/organizer.dart';

void main() {
  group('EditEventPage Widget Tests', () {
    late EventDetails testEvent;

    setUp(() {
      testEvent = EventDetails(
        id: 1,
        organiserId: 10,
        name: 'Test Event',
        description: 'This is a test event description.',
        location: 'Test Location',
        eventType: 'Conference',
        capacity: 50,
        startDateTime: DateTime(2025, 1, 1, 9, 0),
        endDateTime: DateTime(2025, 1, 1, 17, 0),
        status: 'Scheduled',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        organizer: Organizer(id: 10, firstName: 'John', lastName: 'Doe'),
        tickets: [],
        registrationsCount: 0,
      );
    });

    testWidgets('initial values are displayed in text fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditEventPage(event: testEvent),
        ),
      );

      // Ensure text fields show the initial event details
      final editableTexts = find.byType(EditableText);
      expect(editableTexts, findsNWidgets(4));

      final nameField = tester.widget<EditableText>(editableTexts.at(0));
      expect(nameField.controller.text, equals('Test Event'));

      final locationField = tester.widget<EditableText>(editableTexts.at(1));
      expect(locationField.controller.text, equals('Test Location'));

      final capacityField = tester.widget<EditableText>(editableTexts.at(2));
      expect(capacityField.controller.text, equals('50'));

      final descriptionField = tester.widget<EditableText>(editableTexts.at(3));
      expect(descriptionField.controller.text, equals('This is a test event description.'));
    });

    testWidgets('renders Save and Cancel buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditEventPage(event: testEvent),
        ),
      );

      expect(find.widgetWithText(ElevatedButton, 'Save Changes'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Cancel Changes'), findsOneWidget);
    });
  });
}
