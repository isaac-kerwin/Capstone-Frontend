
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
  final String phone;
  final String ticketType;
  final List<Map<String, dynamic>> questionResponses;

  Participant({
    required this.name,
    required this.email,
    required this.phone,
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
}