
class EventRegistrationDTO{
  final int eventId;
  final List<RegistrationTicketDTO> tickets;
  final List<RegistrationParticipantDTO> participants;

  EventRegistrationDTO({
    required this.eventId,
    required this.tickets,
    required this.participants,
  });

  Map<String, dynamic> toJson() {
    return {
      "eventId": eventId,
      "tickets": tickets.map((ticket) => ticket.toJson()).toList(),
      "participants": participants.map((participant) => participant.toJson()).toList(),
    };
  }
}

class RegistrationTicketDTO {
  final int ticketId;
  final int quantity;

  RegistrationTicketDTO({
    required this.ticketId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      "ticketId": ticketId,
      "quantity": quantity,
    };
  }
}

class ParticipantInformation {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  ParticipantInformation({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });
}

class RegistrationParticipantDTO {
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final Map<String, dynamic>? responses;

  RegistrationParticipantDTO({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.responses,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "responses": responses,
    };
  }
}