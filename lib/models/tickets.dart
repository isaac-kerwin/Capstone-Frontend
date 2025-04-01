class Ticket {
  final int id;
  final int eventId;
  final String name;
  final String description;
  final String price;
  final int quantityTotal;
  final int quantitySold;
  final DateTime salesStart;
  final DateTime salesEnd;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

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
}

class TicketInformation{
  final String? name;
  final String? description;
  final String? price;
  final int? quantityTotal;
  final DateTime? salesStart;
  final DateTime? salesEnd;

  TicketInformation(
      {this.name,
      this.description,
      this.price,
      this.quantityTotal,
      this.salesStart,
      this.salesEnd});
}

class TicketDTO {
  final String name;
  final String description;
  final double price;
  final int quantityTotal;
  final DateTime salesStart;
  final DateTime salesEnd;

  TicketDTO(
      {required this.name,
      required this.description,
      required this.price,
      required this.quantityTotal,
      required this.salesStart,
      required this.salesEnd});

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
