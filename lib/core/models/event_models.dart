import 'package:app_mobile_frontend/core/models/question_models.dart';
import 'package:app_mobile_frontend/core/models/ticket_models.dart';
import 'package:app_mobile_frontend/core/models/organizer_models.dart';

/// Models for event data, including listing, details, pagination, and DTOs for creation and updates.

/// Represents a paginated response of events from the server.
class Events {
  /// The list of event details returned.
  final List<EventDetails> events;
  /// Metadata about pagination (total pages, current page, etc.).
  final Pagination pagination;

  /// Creates an [Events] instance with events and pagination info.
  Events({required this.events, required this.pagination});

  /// Creates an [Events] object from JSON.
  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
      events: json["events"]
          .map<EventDetails>((event) => EventDetails.fromJson(event))
          .toList(),
      pagination: Pagination.fromJson(json["pagination"]),
    );
  }
}

/// Detailed information about a single event.
class EventDetails {
  /// Unique event identifier.
  final int id;
  /// Identifier of the organizer for this event.
  final int organiserId;
  /// Title of the event.
  final String name;
  /// Description of the event.
  final String description;
  /// Location where the event will occur.
  final String location;
  /// Category or type of the event.
  final String eventType;
  /// Maximum number of attendees allowed.
  final int capacity;
  /// Start date and time of the event.
  final DateTime startDateTime;
  /// End date and time of the event.
  final DateTime endDateTime;
  /// Current status (e.g., active, cancelled).
  final String status;
  /// Timestamp when the event was created.
  final DateTime createdAt;
  /// Timestamp when the event was last updated.
  final DateTime updatedAt;
  /// Organizer details for this event.
  final Organizer organizer;
  /// Tickets available for this event.
  final List<Ticket> tickets;
  /// Number of registrations for this event.
  final int registrationsCount;

  /// Constructs an [EventDetails] object.
  EventDetails({
    required this.id,
    required this.organiserId,
    required this.name,
    required this.description,
    required this.location,
    required this.eventType,
    required this.capacity,
    required this.startDateTime,
    required this.endDateTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.organizer,
    required this.tickets,
    required this.registrationsCount,
  });

  /// Creates an [EventDetails] object from JSON.
  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      id: json["id"],
      organiserId: json["organiserId"],
      name: json["name"],
      description: json["description"],
      location: json["location"],
      capacity: json["capacity"],
      eventType: json["eventType"],
      startDateTime: DateTime.parse(json["startDateTime"]),
      endDateTime: DateTime.parse(json["endDateTime"]),
      status: json["status"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      organizer: Organizer(
          id: json["organizer"]["id"],
          firstName: json["organizer"]["firstName"],
          lastName: json["organizer"]["lastName"]),
      tickets: json["tickets"]
          .map<Ticket>((ticket) => Ticket.fromJson(ticket))
          .toList(),
      registrationsCount: json["_count"]["registrations"],
    );
  }
}

/// Metadata for paginated API responses.
class Pagination {
  /// Total number of items available.
  final int total;
  /// Total number of pages.
  final int pages;
  /// Current page index (starting at 1).
  final int page;
  /// Maximum items per page.
  final int limit;

  /// Constructs pagination metadata.
  Pagination({
    required this.total,
    required this.pages,
    required this.page,
    required this.limit,
  });

  /// Creates [Pagination] from JSON.
  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json["total"],
      pages: json["pages"],
      page: json["page"],
      limit: json["limit"],
    );
  }
}

/// Detailed event model that includes associated questions.
class EventWithQuestions {
  /// Unique event identifier.
  final int id;
  /// Identifier of the organizer.
  final int organiserId;
  /// Event title.
  final String name;
  /// Event description.
  final String description;
  /// Location of the event.
  final String location;
  /// Maximum capacity of the event.
  final int capacity;
  /// Type or category of the event.
  final String eventType;
  /// Event start date and time.
  final DateTime startDateTime;
  /// Event end date and time.
  final DateTime endDateTime;
  /// Current event status.
  final String status;
  /// Creation timestamp.
  final DateTime createdAt;
  /// Last update timestamp.
  final DateTime updatedAt;
  /// Organizer name details.
  final OrganizerName organizer;
  /// Tickets associated with the event.
  final List<Ticket> tickets;
  /// Questions configured for this event.
  final List<Question> questions;
  /// Count of current registrations.
  final int registrationsCount;

  /// Constructs an [EventWithQuestions] instance.
  EventWithQuestions({
    required this.id,
    required this.organiserId,
    required this.name,
    required this.description,
    required this.location,
    required this.capacity,
    required this.eventType,
    required this.startDateTime,
    required this.endDateTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.organizer,
    required this.tickets,
    required this.questions,
    required this.registrationsCount,
  });

  /// Creates an [EventWithQuestions] object from JSON.
  factory EventWithQuestions.fromJson(Map<String, dynamic> json) {
    return EventWithQuestions(
      id: json["id"],
      organiserId: json["organiserId"],
      name: json["name"],
      description: json["description"],
      location: json["location"],
      capacity: json["capacity"],
      eventType: json["eventType"].toString(),
      startDateTime: DateTime.parse(json["startDateTime"]),
      endDateTime: DateTime.parse(json["endDateTime"]),
      status: json["status"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      organizer: OrganizerName(
          firstName: json["organizer"]["firstName"],
          lastName: json["organizer"]["lastName"]),
      tickets: json["tickets"]
          .map<Ticket>((ticket) => Ticket.fromJson(ticket))
          .toList(),
      questions: (json["eventQuestions"] as List)
          .map<Question>((qJson) => Question.fromJson(qJson as Map<String, dynamic>))
          .toList(),
      registrationsCount: json["_count"]["registrations"],);
  }
}

/// DTO for creating a new event with associated tickets and questions.
class CreateEventDTO {
  /// Event title.
  final String name;
  /// Event description.
  final String description;
  /// Event venue/location.
  final String location;
  /// Category or type of the event.
  final String eventType;
  /// Start date and time of the event.
  final DateTime startDateTime;
  /// End date and time of the event.
  final DateTime endDateTime;
  /// Maximum capacity for attendees.
  final int capacity;
  /// List of tickets to configure for the event.
  final List<TicketDTO> tickets;
  /// List of questions to associate with the event.
  final List<CreateQuestionDTO> questions;

  /// Constructs a [CreateEventDTO] with required event properties.
  CreateEventDTO({
    required this.name,
    required this.description,
    required this.location,
    required this.eventType,
    required this.startDateTime,
    required this.endDateTime,
    required this.capacity,
    required this.tickets,
    required this.questions,
  });

  /// Converts this DTO into a JSON map for API submission.
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "location": location,
      "eventType": eventType,
      "startDateTime": startDateTime.toIso8601String(),
      "endDateTime": endDateTime.toIso8601String(),
      "capacity": capacity,
      "tickets": tickets.map((ticket) => ticket.toJson()).toList(),
      "questions": questions.map((question) => question.toJson()).toList()
    };
  }
}

/// DTO for updating existing event details. Fields are nullable.
class UpdateEventDTO {
  /// Optional new event title.
  final String? name;
  /// Optional new description.
  final String? description;
  /// Optional new location.
  final String? location;
  /// Optional new maximum capacity.
  final int? capacity;
  /// Optional new event type.
  final String? eventType;
  /// Optional new start date and time.
  final DateTime? startDateTime;
  /// Optional new end date and time.
  final DateTime? endDateTime;
  /// Optional new ticket configurations.
  final List<TicketDTO>? tickets;
  /// Optional new question configurations.
  final List<QuestionDTO>? questions;

  /// Constructs an [UpdateEventDTO] where fields may be null if unchanged.
  UpdateEventDTO({
    this.name,
    this.description,
    this.location,
    this.capacity,
    this.eventType,
    this.startDateTime,
    this.endDateTime,
    this.tickets,
    this.questions,
  });

  /// Serializes only non-null fields to JSON for partial updates.
  Map<String, dynamic> toJson() {
    return {
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (location != null) "location": location,
      if (capacity != null) "capacity": capacity,
      if (eventType != null) "eventType": eventType,
      if (startDateTime != null) "startDateTime": startDateTime!.toIso8601String(),
      if (endDateTime != null) "endDateTime": endDateTime!.toIso8601String(),
      if (tickets != null) "tickets": tickets!.map((ticket) => ticket.toJson()).toList(),
      if (questions != null) "questions": questions!.map((question) => question.toJson()).toList(),
    };
  }
}
