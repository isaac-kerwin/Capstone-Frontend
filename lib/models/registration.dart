import 'package:first_app/models/participant.dart';

class EventRegistrationDTO{
  final int eventId;
  final ParticipantDTO participant;
  int? ticketId;
  int? quantity;
  final List<dynamic> responses; 

  EventRegistrationDTO({
    required this.eventId,
    required this.participant,
    this.ticketId,
    this.quantity,
    required this.responses,
  });
}