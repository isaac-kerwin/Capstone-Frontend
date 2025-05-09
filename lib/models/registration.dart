
class EventRegistrationDTO{
  final int eventId;
  final List<RegistrationTicketDTO> tickets;
  final List<ParticipantDTO> participants;

  EventRegistrationDTO({
    required this.eventId,
    required this.tickets,
    required this.participants,
  });
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

class ParticipantDTO {
  final String firstName;
  final String lastName;
  final String email;
  String? phoneNumber;
  Map<String, dynamic>? responses;

  ParticipantDTO({
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