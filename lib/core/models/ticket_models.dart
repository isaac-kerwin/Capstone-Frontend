/// Represents a ticket available for an event with sales and status metadata.
class Ticket {
  /// Unique ticket identifier.
  final int id;
  /// Associated event identifier.
  final int eventId;
  /// Ticket name or title.
  final String name;
  /// Description of the ticket.
  final String description;
  /// Price of the ticket as a string (e.g., "10.00").
  final String price;
  /// Total quantity available.
  final int quantityTotal;
  /// Quantity already sold.
  final int quantitySold;
  /// Sales start date and time.
  final DateTime salesStart;
  /// Sales end date and time.
  final DateTime salesEnd;
  /// Current ticket status (e.g., "active").
  final String status;
  /// Timestamp when created.
  final DateTime createdAt;
  /// Timestamp when last updated.
  final DateTime updatedAt;

  /// Constructs a [Ticket] instance.
  Ticket(
      {required this.id,
      required this.eventId,
      required this.name,
      required this.description,
      required this.price,
      required this.quantityTotal,
      required this.quantitySold,
      required this.salesStart,
      required this.salesEnd,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  /// Creates a [Ticket] from JSON data.
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
        id: json["id"],
        eventId: json["eventId"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        quantityTotal: json["quantityTotal"],
        quantitySold: json["quantitySold"],
        salesStart: DateTime.parse(json["salesStart"]),
        salesEnd: DateTime.parse(json["salesEnd"]),
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]));
  }

  /// Serializes this [Ticket] to JSON.
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "eventId": eventId,
      "name": name,
      "description": description,
      "price": price,
      "quantityTotal": quantityTotal,
      "quantitySold": quantitySold,
      "salesStart": salesStart.toIso8601String(),
      "salesEnd": salesEnd.toIso8601String(),
      "status": status,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

/// Basic ticket configuration details without ID for payloads.
class TicketInformation {
  /// Ticket name.
  final String? name;
  /// Ticket description.
  final String? description;
  /// Ticket price.
  final String? price;
  /// Total quantity available.
  final int? quantityTotal;
  /// Sales start time.
  final DateTime? salesStart;
  /// Sales end time.
  final DateTime? salesEnd;

  /// Constructs a [TicketInformation] with optional fields.
  TicketInformation(
      {this.name,
      this.description,
      this.price,
      this.quantityTotal,
      this.salesStart,
      this.salesEnd});
}

/// Data transfer object for creating or updating tickets in API requests.
class TicketDTO {
  /// Ticket name.
  final String name;
  /// Ticket description.
  final String description;
  /// Ticket price as a double.
  final double price;
  /// Total quantity available.
  final int quantityTotal;
  /// Sales start date and time.
  final DateTime salesStart;
  /// Sales end date and time.
  final DateTime salesEnd;

  /// Constructs a [TicketDTO] with required fields.
  TicketDTO(
      {required this.name,
      required this.description,
      required this.price,
      required this.quantityTotal,
      required this.salesStart,
      required this.salesEnd});

  /// Converts this [TicketDTO] to JSON for API submission.
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "price": price,
      "quantityTotal": quantityTotal,
      "salesStart": salesStart.toIso8601String(),
      "salesEnd": salesEnd.toIso8601String()
    };
  }
}
