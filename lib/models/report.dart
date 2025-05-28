
class Sales {
  final int totalTickets;
  final num revenue;
  final List<Map<String, dynamic>> ticketTypes;
  final List<Map<String, dynamic>> revenueByTicket;

  Sales({
    required this.totalTickets,
    required this.revenue,
    required this.ticketTypes,
    required this.revenueByTicket,
  });
}

class Remaining {
  final int remainingTickets;
  final Map<String, dynamic> remainingByTicket;

  Remaining({
    required this.remainingTickets,
    required this.remainingByTicket,
  });
}

class Participant{
  final String name;
  final String email;
  final String ticketType;
  final List<Map<String, dynamic>> questionResponses;

  Participant({
    required this.name,
    required this.email,
    required this.ticketType,
    required this.questionResponses,
  });
}

class Report{
  final String eventName;
  final String eventDescription;
  final String eventLocation;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final Sales sales;
  final Remaining remaining;
  final List<Participant> participants;

  Report({
    required this.eventName,
    required this.eventDescription,
    required this.eventLocation,
    required this.startDateTime,
    required this.endDateTime,
    required this.sales,
    required this.remaining,
    required this.participants,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      eventName: json["eventName"],
      eventDescription: json["eventDescription"],
      eventLocation: json["eventLocation"],
      startDateTime: DateTime.parse(json["startDateTime"]),
      endDateTime: DateTime.parse(json["endDateTime"]),
      sales: Sales(
        totalTickets: json["sales"]["totalTickets"],
        revenue: json["sales"]["revenue"],
        ticketTypes: List<Map<String, dynamic>>.from(json["sales"]["soldByTickets"]),
        revenueByTicket: List<Map<String, dynamic>>.from(json["sales"]["revenueByTicket"]),
      ),
      remaining: Remaining(
        remainingTickets: json["remaining"]["remainingTickets"],
        remainingByTicket: Map<String, dynamic>.from(json["remaining"]["remainingByTicket"]),
      ),
      participants: List<Participant>.from(
        json["participants"].map((p) => Participant(
          name: p["name"],
          email: p["email"],
          ticketType: p["ticket"],
          questionResponses: List<Map<String, dynamic>>.from(p["questionairreResponses"]),
        )),
      ),
    );
  }
}