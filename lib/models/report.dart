import 'package:logging/logging.dart';

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
  final List<Map<String, dynamic>> remainingByTicket;   // <- List

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
  final DateTime startDateTime;
  final DateTime endDateTime;
  final Sales sales;
  final Remaining remaining;
  final List<Participant> participants;
  final Map<String, Map<String, int>> questions;

  Report({
    required this.eventName,
    required this.eventDescription,
    required this.startDateTime,
    required this.endDateTime,
    required this.sales,
    required this.remaining,
    required this.participants,
    required this.questions,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
     Report report = Report(
      eventName: json["eventName"],
      eventDescription: json["eventDescription"],
      startDateTime: DateTime.parse(json["start"]),
      endDateTime: DateTime.parse(json["end"]),
      sales: Sales(
        totalTickets: json["sales"]["totalTickets"],
        revenue: json["sales"]["revenue"],
        ticketTypes: List<Map<String, dynamic>>.from(json["sales"]["soldByTickets"]),
        revenueByTicket: List<Map<String, dynamic>>.from(json["sales"]["revenueByTickets"]),
      ),
      remaining: Remaining(
        remainingTickets: json["remaining"]["remainingTickets"],
        remainingByTicket: List<Map<String, dynamic>>
            .from(json["remaining"]["remainingByTicket"]),
      ),
      participants: List<Participant>.from(
        json["participants"].map((p) => Participant(
          name: p["name"],
          email: p["email"],
          ticketType: p["ticket"],
          questionResponses: List<Map<String, dynamic>>.from(
            p["questionnaireResponses"] ?? p["questionnairreResponses"] ?? []
          ),
        )),
      ),
      questions: (json["questions"] as Map<String, dynamic>?)
        ?.map((q, v) => MapEntry(q, Map<String, int>.from(v as Map)))
        ?? {},
    );
    report.prettyPrint();
    return report;
  }

  void prettyPrint() {
    _logger.info("Event Report:");
    _logger.info("Event Name: $eventName");
    _logger.info("Description: $eventDescription");
    _logger.info("Start Time: $startDateTime");
    _logger.info("End Time: $endDateTime");
    _logger.info("Total Tickets Sold: ${sales.totalTickets}");
    _logger.info("Total Revenue: \$${sales.revenue}");
    _logger.info("Remaining Tickets: ${remaining.remainingTickets}");
    // Questions summary log
    _logger.info("Questions Summary:");
    questions.forEach((q, opts) {
      _logger.info("Question: $q");
      opts.forEach((opt, count) {
        _logger.info("  $opt: $count");
      });
    });
    _logger.info("Participants Count: ${participants.length}");
  }
}

final Logger _logger = Logger('EventModel');
