import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:app_mobile_frontend/core/models/event.dart';
import 'package:app_mobile_frontend/network/dio_client.dart';
import 'package:app_mobile_frontend/network/event_services.dart';
import 'event_network_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dioClient = DioClient(customDio: mockDio);
  });

  group('Event API Tests', () {
    test('T2.3.1 - createEvent success', () async {
      final dto = CreateEventDTO(
        name: 'Test Event',
        description: 'Description',
        location: 'Online',
        eventType: 'Webinar',
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(Duration(hours: 1)),
        capacity: 100,
        tickets: [],
        questions: [],
      );

      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              data: {"success": true}));

      await createEvent(dto);
      verify(mockDio.post("/events", data: dto.toJson(), options: anyNamed('options'))).called(1);
    });

    test('T2.3.2 - createEvent failure', () async {
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              data: {"success": false}));

      await createEvent(CreateEventDTO(
        name: '',
        description: '',
        location: '',
        eventType: '',
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now(),
        capacity: 0,
        tickets: [],
        questions: [],
      ));
    });

    test('T2.3.3 - createEvent error', () async {
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
              requestOptions: RequestOptions(path: ''), error: 'network error'));

      await createEvent(CreateEventDTO(
        name: '',
        description: '',
        location: '',
        eventType: '',
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now(),
        capacity: 0,
        tickets: [],
        questions: [],
      ));
    });

    test('T2.3.10 - getAllEvents success', () async {
      final responseData = {
        "success": true,
        "data": {
          "events": [],
          "pagination": {"total": 0, "pages": 0, "page": 1, "limit": 10}
        }
      };

      when(mockDio.get("/events")).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''), data: responseData));

      final result = await getAllEvents();
      expect(result, isA<Events>());
    });

    test('T2.3.11 - getAllEvents failure', () async {
      when(mockDio.get("/events")).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {"success": false, "message": "fail"}));

      expect(() async => await getAllEvents(), throwsException);
    });

    test('T2.3.12 - getAllEvents error', () async {
      when(mockDio.get("/events"))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(() async => await getAllEvents(), throwsException);
    });

    test('T2.3.13 - getEventById success', () async {
      when(mockDio.get("/events/1")).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {
              "success": true,
              "data": {
                "id": 1,
                "organiserId": 10,
                "name": "Event",
                "description": "Desc",
                "location": "Loc",
                "capacity": 10,
                "eventType": "webinar",
                "startDateTime": DateTime.now().toIso8601String(),
                "endDateTime": DateTime.now().toIso8601String(),
                "status": "active",
                "createdAt": DateTime.now().toIso8601String(),
                "updatedAt": DateTime.now().toIso8601String(),
                "organizer": {"firstName": "F", "lastName": "L"},
                "tickets": [],
                "eventQuestions": [],
                "_count": {"registrations": 0}
              }
            },
          ));

      final result = await getEventById(1);
      expect(result, isA<EventWithQuestions>());
    });

    test('T2.3.14 - getEventById failure', () async {
      when(mockDio.get("/events/1")).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {"success": false}));

      expect(() async => await getEventById(1), throwsException);
    });

    test('T2.3.15 - getEventById error', () async {
      when(mockDio.get("/events/1"))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(() async => await getEventById(1), throwsException);
    });

    test('T2.3.16 - getEventsByOrganizerId success', () async {
      when(mockDio.get("/events?1")).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            "success": true,
            "data": {
              "events": [],
              "pagination": {"total": 0, "pages": 0, "page": 1, "limit": 10}
            }
          }));

      final events = await getEventsByOrganizerId(1);
      expect(events, isA<Events>());
    });

    test('T2.3.17 - getEventsByOrganizerId failure', () async {
      when(mockDio.get("/events?1")).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {"success": false}));

      expect(() async => await getEventsByOrganizerId(1), throwsException);
    });

    test('T2.3.18 - getEventsByOrganizerId error', () async {
      when(mockDio.get("/events?1"))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(() async => await getEventsByOrganizerId(1), throwsException);
    });
  });
}
