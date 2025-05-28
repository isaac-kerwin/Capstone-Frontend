import 'package:app_mobile_frontend/models/question.dart';
import 'package:app_mobile_frontend/models/tickets.dart';
import 'package:app_mobile_frontend/models/organizer.dart';

//For Get all Events
class Events {
  final List<EventDetails> events;
  final Pagination pagination;

  Events({required this.events, required this.pagination});
  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
        events: json["events"]
            .map<EventDetails>((event) => EventDetails.fromJson(event))
            .toList(),
        pagination: Pagination.fromJson(json["pagination"]));
  }
}

class EventDetails {
  final int id;
  final int organiserId;
  final String name;
  final String description;
  final String location;
  final String eventType;
  final int capacity;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Organizer organizer;
  final List<Ticket> tickets;
  final int registrationsCount;

// For Get Event Details
  EventDetails({
    required this.id, required this.organiserId, required this.name,
    required this.description, required this.location, required this.eventType,
    required this.capacity, required this.startDateTime, required this.endDateTime,
    required this.status, required this.createdAt, required this.updatedAt,
    required this.organizer, required this.tickets, required this.registrationsCount
  });

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
        registrationsCount: json["_count"]["registrations"]);
  }
}

class Pagination {
  final int total;
  final int pages;
  final int page;
  final int limit;

  Pagination(
      {required this.total,
      required this.pages,
      required this.page,
      required this.limit});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json["total"],
      pages: json["pages"],
      page: json["page"],
      limit: json["limit"]);
  }
}

// For Get Event By ID
class EventWithQuestions {
  final int id;
  final int organiserId;
  final String name;
  final String description;
  final String location;
  final int capacity;
  final String eventType;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OrganizerName organizer;
  final List<Ticket> tickets;
  final List<Question> questions;
  final int registrationsCount;

  EventWithQuestions({
    required this.id, required this.organiserId, required this.name,
    required this.description, required this.location, required this.capacity,
    required this.eventType, required this.startDateTime, required this.endDateTime,
    required this.status, required this.createdAt, required this.updatedAt,
    required this.organizer, required this.tickets, required this.questions,
    required this.registrationsCount
  });

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
        questions: json["eventQuestions"]
            .map<Question>((question) => Question.fromJson(question))
            .toList(),
        registrationsCount: json["_count"]["registrations"],);
  }
}

// For Create new Event
class CreateEventDTO {
  final String name;
  final String description;
  final String location;
  final String eventType;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int capacity;
  final List<TicketDTO> tickets;
  final List<CreateQuestionDTO> questions;

  CreateEventDTO({
    required this.name, required this.description, required this.location,
    required this.eventType, required this.startDateTime, required this.endDateTime,
    required this.capacity, required this.tickets, required this.questions
  });

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

class UpdateEventDTO {
  final String? name;
  final String? description;
  final String? location;
  final int? capacity;
  final String? eventType;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final List<TicketDTO>? tickets;
  final List<QuestionDTO>? questions;

  UpdateEventDTO({
    this.name, this.description, this.location,
    this.capacity, this.eventType, this.startDateTime,
    this.endDateTime, this.tickets, this.questions,
  });

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


// For Update Event
