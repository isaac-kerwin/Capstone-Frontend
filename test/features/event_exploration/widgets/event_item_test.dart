import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/event_item.dart';
import 'package:app_mobile_frontend/core/models/event_models.dart';
import 'package:app_mobile_frontend/core/models/organizer_models.dart';

void main() {
  group('EventItem Widget Tests', () {
    late EventDetails sampleEvent;
    late bool tapped;

    setUp(() {
      tapped = false;
      sampleEvent = EventDetails(
        id: 42,
        organiserId: 7,
        name: 'Test Event Name',
        description: 'Description',
        location: 'Test Location',
        eventType: 'TEST',
        capacity: 123,
        startDateTime: DateTime(2025, 1, 15, 10, 30),
        endDateTime: DateTime(2025, 1, 15, 12, 0),
        status: 'Active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        organizer: Organizer(id: 7, firstName: 'John', lastName: 'Doe'),
        tickets: [],
        registrationsCount: 0,
      );
    });

    testWidgets('displays event details correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventItem(
              event: sampleEvent,
              onTap: () {},
            ),
          ),
        ),
      );

      // Event name
      expect(find.text('Test Event Name'), findsOneWidget);
      // Capacity going
      expect(find.text('123 Going'), findsOneWidget);
      // Location text
      expect(find.text('Test Location'), findsOneWidget);
      // Calendar icon indicating date
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('invokes onTap when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventItem(
              event: sampleEvent,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });
  });
}
