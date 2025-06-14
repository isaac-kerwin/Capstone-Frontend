import 'dart:convert';
import 'package:logging/logging.dart';

/// Models for event registration payloads, ticket and participant selection, and responses.

/// Data Transfer Object for submitting event registration, including tickets and participants.
class EventRegistrationDTO {
  /// Identifier of the event being registered.
  final int eventId;
  /// List of selected tickets with quantities.
  final List<Map<String, dynamic>> tickets;
  /// List of participant details and responses.
  final List<Map<String, dynamic>> participants;

  /// Constructs an [EventRegistrationDTO] with required eventId, tickets, and participants.
  EventRegistrationDTO({
    required this.eventId,
    required this.tickets,
    required this.participants,
  });

  /// Serializes registration data to JSON for API submission.
  Map<String, dynamic> toJson() {
    return {
      "eventId": eventId,
      "tickets": tickets,
      "participants": participants,
    };
  }
}

/// Represents a response to a single question in the registration process.
class QuestionResponse {
  /// Identifier of the question.
  final int questionId;
  /// User's response data for the question.
  final String responseData;

  /// Constructs a [QuestionResponse].
  QuestionResponse({required this.questionId, required this.responseData});

  /// Serializes the question response to JSON.
  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'responseData': responseData,
  };
}

/// Represents a selected ticket type and quantity in registration.
class TicketSelection {
  /// Identifier of the ticket.
  final int ticketId;
  /// Quantity of tickets selected.
  final int quantity;

  /// Constructs a [TicketSelection].
  TicketSelection({required this.ticketId, required this.quantity});

  /// Serializes the ticket selection to JSON.
  Map<String, dynamic> toJson() => {
    'ticketId': ticketId,
    'quantity': quantity,
  };
}

/// Represents a participant's response to an event-specific question.
class ParticipantResponse {
  /// Identifier of the event question.
  final int eventQuestionId;
  /// Text of the participant's response.
  final String responseText;

  /// Constructs a [ParticipantResponse].
  ParticipantResponse({required this.eventQuestionId, required this.responseText});

  /// Serializes the participant response to JSON.
  Map<String, dynamic> toJson() => {
    'eventQuestionId': eventQuestionId,
    'responseText': responseText,
  };
}

/// Represents a participant's registration details and question responses.
class Participant {
  /// Identifier of the ticket chosen.
  final int ticketId;
  /// Participant's email address.
  final String email;
  /// Participant's first name.
  final String firstName;
  /// Participant's last name.
  final String lastName;
  /// Participant's phone number.
  final String phoneNumber;
  /// List of responses provided by the participant.
  final List<ParticipantResponse> responses;

  /// Constructs a [Participant] with contact info, ticketId, and responses.
  Participant({
    required this.ticketId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.responses,
  });

  /// Serializes participant data to JSON, including responses.
  Map<String, dynamic> toJson() => {
    'ticketId': ticketId,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'responses': responses.map((r) => r.toJson()).toList(),
  };
}

/// Logs for debugging registration DTOs.
final Logger _logger = Logger('RegistrationModel');

/// Prints a formatted JSON representation of [EventRegistrationDTO] for debugging.
void prettyPrintEventRegistrationDTO(EventRegistrationDTO dto) {
  const encoder = JsonEncoder.withIndent('  ');
  final prettyJson = encoder.convert(dto.toJson());
  _logger.info(prettyJson);
}