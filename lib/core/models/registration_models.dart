import 'dart:convert';
import 'package:logging/logging.dart';

class EventRegistrationDTO{
  final int eventId;
  final List<Map<String, dynamic>>  tickets;
  final List<Map<String, dynamic>>  participants;

  EventRegistrationDTO({
    required this.eventId,
    required this.tickets,
    required this.participants,
  });
  

  Map<String, dynamic> toJson() {
    return {
      "eventId": eventId,
      "tickets": tickets,
      "participants": participants,
    };
  }
}


class QuestionResponse {
  final int questionId;
  final String responseData;

  QuestionResponse({required this.questionId, required this.responseData});

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'responseData': responseData,
  };
}

class TicketSelection {
  final int ticketId;
  final int quantity;

  TicketSelection({required this.ticketId, required this.quantity});

  Map<String, dynamic> toJson() => {
    'ticketId': ticketId,
    'quantity': quantity,
  };
}

class ParticipantResponse {
  final int eventQuestionId;
  final String responseText;

  ParticipantResponse({required this.eventQuestionId, required this.responseText});

  Map<String, dynamic> toJson() => {
    'eventQuestionId': eventQuestionId,
    'responseText': responseText,
  };
}

class Participant {
  final int ticketId;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final List<ParticipantResponse> responses;

  Participant({
    required this.ticketId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.responses,
  });

  Map<String, dynamic> toJson() => {
    'ticketId': ticketId,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'responses': responses.map((r) => r.toJson()).toList(),
  };
}

final Logger _logger = Logger('RegistrationModel');

void prettyPrintEventRegistrationDTO(EventRegistrationDTO dto) {
  const encoder = JsonEncoder.withIndent('  ');
  final prettyJson = encoder.convert(dto.toJson());
  _logger.info(prettyJson);
}