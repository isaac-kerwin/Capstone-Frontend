import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/core/models/ticket_models.dart'; // Adjust the import path to match your structure

void main() {
  group('Ticket Models', () {
    test('T1.6.1 - Test Ticket.fromJson with valid data', () {
      final json = {
        "id": 1,
        "eventId": 100,
        "name": "Standard Ticket",
        "description": "Access to all sessions",
        "price": "49.99",
        "quantityTotal": 100,
        "quantitySold": 20,
        "salesStart": "2025-05-01T09:00:00Z",
        "salesEnd": "2025-05-10T17:00:00Z",
        "status": "available",
        "createdAt": "2025-04-01T12:00:00Z",
        "updatedAt": "2025-04-02T12:00:00Z"
      };

      final ticket = Ticket.fromJson(json);
      expect(ticket.name, "Standard Ticket");
      expect(ticket.quantityTotal, 100);
      expect(ticket.status, "available");
    });

    test('T1.6.2 - Test missing field in Ticket.fromJson', () {
      final json = {
        "id": 1,
        "eventId": 100,
        // Missing "name"
        "description": "Access",
        "price": "20.00",
        "quantityTotal": 100,
        "quantitySold": 20,
        "salesStart": "2025-05-01T09:00:00Z",
        "salesEnd": "2025-05-10T17:00:00Z",
        "status": "active",
        "createdAt": "2025-04-01T12:00:00Z",
        "updatedAt": "2025-04-02T12:00:00Z"
      };

      expect(() => Ticket.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('T1.6.3 - Test creation of TicketInformation with all fields set', () {
      final ticketInfo = TicketInformation(
        name: "VIP",
        description: "Front row seats",
        price: "150.00",
        quantityTotal: 10,
        salesStart: DateTime.parse("2025-05-01T09:00:00Z"),
        salesEnd: DateTime.parse("2025-05-10T17:00:00Z"),
      );

      expect(ticketInfo.name, "VIP");
      expect(ticketInfo.price, "150.00");
      expect(ticketInfo.quantityTotal, 10);
    });

    test('T1.6.4 - Test TicketDTO.toJson', () {
      final dto = TicketDTO(
        name: "Early Bird",
        description: "Discounted ticket",
        price: 20.0,
        quantityTotal: 50,
        salesStart: DateTime.parse("2025-05-01T09:00:00Z"),
        salesEnd: DateTime.parse("2025-05-05T17:00:00Z"),
      );

      final json = dto.toJson();
      expect(json["name"], "Early Bird");
      expect(json["price"], 20.0);
      expect(json["quantityTotal"], 50);
      expect(json["salesStart"], "2025-05-01T09:00:00.000Z");
    });

    test('T1.6.5 - Test TicketDTO.toJson accepts decimal', () {
      final dto = TicketDTO(
        name: "Premium",
        description: "Best seats",
        price: 49.99,
        quantityTotal: 30,
        salesStart: DateTime.parse("2025-05-01T09:00:00Z"),
        salesEnd: DateTime.parse("2025-05-10T17:00:00Z"),
      );

      final json = dto.toJson();
      expect(json["price"], 49.99);
    });

    test('T1.6.6 - Test field type validation (invalid type for quantityTotal)', () {
      final json = {
        "id": 1,
        "eventId": 100,
        "name": "Standard Ticket",
        "description": "Description",
        "price": "20.00",
        "quantityTotal": "hundred", // Invalid type
        "quantitySold": 10,
        "salesStart": "2025-05-01T09:00:00Z",
        "salesEnd": "2025-05-10T17:00:00Z",
        "status": "active",
        "createdAt": "2025-04-01T12:00:00Z",
        "updatedAt": "2025-04-02T12:00:00Z"
      };

      expect(() => Ticket.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}