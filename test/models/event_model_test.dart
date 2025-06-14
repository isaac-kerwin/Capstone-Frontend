import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/core/models/event_models.dart';
import 'dart:convert';



void main() {
  group('Event Models JSON Parsing', () {
    test('T1.1.1 - Test parsing of Events.fromJson with valid JSON', () {
      final jsonData = {
        "events": [
          {
            "id": 1,
            "organiserId": 100,
            "name": "Event 1",
            "description": "Description",
            "location": "Location",
            "capacity": 100,
            "eventType": "Conference",
            "startDateTime": "2025-05-01T10:00:00Z",
            "endDateTime": "2025-05-01T12:00:00Z",
            "status": "active",
            "createdAt": "2025-04-01T10:00:00Z",
            "updatedAt": "2025-04-01T10:00:00Z",
            "organizer": {
              "id": 100,
              "firstName": "Alice",
              "lastName": "Smith"
            },
            "tickets": [],
            "_count": {
              "registrations": 20
            }
          }
        ],
        "pagination": {
          "total": 1,
          "pages": 1,
          "page": 1,
          "limit": 10
        }
      };

      final events = Events.fromJson(jsonData);
      expect(events.events.length, 1);
      expect(events.pagination.total, 1);
    });

    test('T1.1.2 - Test parsing of EventDetails.fromJson with full event data', () {
      final json = {
        "id": 1,
        "organiserId": 100,
        "name": "Event",
        "description": "Description",
        "location": "Venue",
        "capacity": 100,
        "eventType": "Seminar",
        "startDateTime": "2025-05-01T10:00:00Z",
        "endDateTime": "2025-05-01T12:00:00Z",
        "status": "active",
        "createdAt": "2025-04-01T10:00:00Z",
        "updatedAt": "2025-04-01T10:00:00Z",
        "organizer": {
          "id": 100,
          "firstName": "John",
          "lastName": "Doe"
        },
        "tickets": [],
        "_count": {"registrations": 5}
      };

      final event = EventDetails.fromJson(json);
      expect(event.name, "Event");
      expect(event.organizer.firstName, "John");
      expect(event.registrationsCount, 5);
    });

    test('T1.1.3 - Test parsing of Pagination.fromJson', () {
      final json = {
        "total": 50,
        "pages": 5,
        "page": 1,
        "limit": 10
      };

      final pagination = Pagination.fromJson(json);
      expect(pagination.total, 50);
      expect(pagination.page, 1);
    });

    test('T1.1.4 - Test EventWithQuestions.fromJson', () {
      final json = {
        "id": 1,
        "organiserId": 10,
        "name": "QEvent",
        "description": "Desc",
        "location": "Place",
        "capacity": 50,
        "eventType": "Workshop",
        "startDateTime": "2025-06-01T08:00:00Z",
        "endDateTime": "2025-06-01T10:00:00Z",
        "status": "active",
        "createdAt": "2025-04-01T10:00:00Z",
        "updatedAt": "2025-04-01T10:00:00Z",
        "organizer": {
          "firstName": "Jane",
          "lastName": "Smith"
        },
        "tickets": [],
        "eventQuestions": [],
        "_count": {"registrations": 12}
      };

      final event = EventWithQuestions.fromJson(json);
      expect(event.organizer.firstName, "Jane");
      expect(event.questions.length, 0);
    });

    test('T1.1.5 - Test CreateEventDTO.toJson output', () {
      final dto = CreateEventDTO(
        name: "Test Event",
        description: "Details",
        location: "Online",
        eventType: "Webinar",
        startDateTime: DateTime.parse("2025-06-10T09:00:00Z"),
        endDateTime: DateTime.parse("2025-06-10T10:00:00Z"),
        capacity: 100,
        tickets: [],
        questions: [],
      );

      final json = dto.toJson();
      expect(json["name"], "Test Event");
      expect(json["tickets"], []);
      expect(json["questions"], []);
    });

    test('T1.1.6 - Test UpdateEventDTO.toJson output', () {
      final dto = UpdateEventDTO(
        name: "Updated Event",
        description: "Updated Desc",
        location: "Updated Location",
        eventType: "Meetup",
        startDateTime: DateTime.parse("2025-06-10T09:00:00Z"),
        endDateTime: DateTime.parse("2025-06-10T11:00:00Z"),
        capacity: 120,
      );

      final json = dto.toJson();
      expect(json["name"], "Updated Event");
      expect(json["capacity"], 120);
    });

    test('T1.1.7 - Test empty list of tickets/questions in CreateEventDTO', () {
      final dto = CreateEventDTO(
        name: "Empty Event",
        description: "Empty Fields",
        location: "N/A",
        eventType: "Empty",
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(Duration(hours: 1)),
        capacity: 0,
        tickets: [],
        questions: [],
      );

      final json = dto.toJson();
      expect(json["tickets"], isEmpty);
      expect(json["questions"], isEmpty);
    });

    test('T1.1.8 - Test missing field handling in EventDetails.fromJson', () {
      final json = {
        // Missing required fields like "id", "name"
        "organiserId": 100,
        "description": "Oops",
        "location": "Nowhere",
        "capacity": 0,
        "eventType": "Error",
        "startDateTime": "2025-06-01T08:00:00Z",
        "endDateTime": "2025-06-01T10:00:00Z",
        "status": "inactive",
        "createdAt": "2025-04-01T10:00:00Z",
        "updatedAt": "2025-04-01T10:00:00Z",
        "organizer": {"id": 1, "firstName": "No", "lastName": "Name"},
        "tickets": [],
        "_count": {"registrations": 0}
      };

      expect(() => EventDetails.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('T1.1.9 - Duplicate of T1.1.8: Ensure exception on missing fields', () {
      final json = {
        // Same as above
        "organiserId": 100,
        "description": "Oops",
        "location": "Nowhere",
        "capacity": 0,
        "eventType": "Error",
        "startDateTime": "2025-06-01T08:00:00Z",
        "endDateTime": "2025-06-01T10:00:00Z",
        "status": "inactive",
        "createdAt": "2025-04-01T10:00:00Z",
        "updatedAt": "2025-04-01T10:00:00Z",
        "organizer": {"id": 1, "firstName": "No", "lastName": "Name"},
        "tickets": [],
        "_count": {"registrations": 0}
      };

      expect(() => EventDetails.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}