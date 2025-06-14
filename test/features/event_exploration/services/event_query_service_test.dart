import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_exploration/services/event_query_service.dart';
import 'package:app_mobile_frontend/core/models/event_models.dart';
import 'package:app_mobile_frontend/core/models/organizer_models.dart';

void main() {
  group('EventQueryService.fetchEvents', () {
    final sampleEvents = [
      EventDetails(
        id: 1,
        organiserId: 1,
        name: 'Sports Gala',
        description: 'Annual sports event',
        location: 'Stadium',
        eventType: 'SPORTS',
        capacity: 100,
        startDateTime: DateTime(2025, 6, 10, 10, 0),
        endDateTime: DateTime(2025, 6, 10, 18, 0),
        status: 'Scheduled',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        organizer: Organizer(id:1, firstName: 'A', lastName: 'B'),
        tickets: [],
        registrationsCount: 0,
      ),
      EventDetails(
        id: 2,
        organiserId: 2,
        name: 'Music Fest',
        description: 'Live music',
        location: 'Park',
        eventType: 'MUSICAL',
        capacity: 200,
        startDateTime: DateTime(2025, 7, 1, 12, 0),
        endDateTime: DateTime(2025, 7, 1, 22, 0),
        status: 'Scheduled',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        organizer: Organizer(id:2, firstName: 'C', lastName: 'D'),
        tickets: [],
        registrationsCount: 0,
      ),
    ];

    test('filters by searchQuery in name', () async {
      final result = await EventQueryService.fetchEvents(
        allEvents: sampleEvents,
        searchQuery: 'sports',
        activeFilter: null,
        activeCategory: null,
        categoryMap: {},
      );
      expect(result.events.length, 1);
      expect(result.events.first.name, 'Sports Gala');
    });

    test('filters by searchQuery in description or location', () async {
      final result = await EventQueryService.fetchEvents(
        allEvents: sampleEvents,
        searchQuery: 'park',
        activeFilter: null,
        activeCategory: null,
        categoryMap: {},
      );
      expect(result.events.length, 1);
      expect(result.events.first.location, 'Park');
    });
  });
}
