import 'package:logging/logging.dart';

/// Sales data summary for an event report.
class Sales {
  /// Total number of tickets sold.
  final int totalTickets;
  /// Total revenue generated.
  final num revenue;
  /// Breakdown of tickets sold by type.
  final List<Map<String, dynamic>> ticketTypes;
  /// Revenue generated per ticket type.
  final List<Map<String, dynamic>> revenueByTicket;

  /// Constructs a [Sales] summary.
  Sales({
    required this.totalTickets,
    required this.revenue,
    required this.ticketTypes,
    required this.revenueByTicket,
  });
}

/// Remaining ticket data for an event report.
class Remaining {
  /// Number of tickets still available.
  final int remainingTickets;
  /// Breakdown of remaining tickets by type.
  final List<Map<String, dynamic>> remainingByTicket;

  /// Constructs a [Remaining] summary.
  Remaining({
    required this.remainingTickets,
    required this.remainingByTicket,
  });
}

/// Participant information included in event reports.
class Participant {
  /// Participant's full name.
  final String name;
  /// Participant's email address.
  final String email;
  /// Type of ticket purchased.
  final String ticketType;
  /// Responses to event questions.
  final List<Map<String, dynamic>> questionResponses;

  /// Constructs a [Participant] record.
  Participant({
    required this.name,
    required this.email,
    required this.ticketType,
    required this.questionResponses,
  });
}

/// Comprehensive report model aggregating sales, participant, and question data.
class Report {
  /// Event name.
  final String eventName;
  /// Event description.
  final String eventDescription;
  /// Event start timestamp.
  final DateTime startDateTime;
  /// Event end timestamp.
  final DateTime endDateTime;
  /// Sales summary data.
  final Sales sales;
  /// Remaining ticket summary.
  final Remaining remaining;
  /// List of participants.
  final List<Participant> participants;
  /// Summary of questions and response counts.
  final Map<String, Map<String, int>> questions;

  /// Constructs a [Report] with all relevant details.
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

  /// Parses JSON into a [Report] instance and logs summary.
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

  /// Logs a human-readable summary of the report.
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

/// Logger for report models.
final Logger _logger = Logger('EventModel');
