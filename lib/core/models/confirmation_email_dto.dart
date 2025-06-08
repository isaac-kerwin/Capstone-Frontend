// File for confirmation email payload
class ConfirmationEmailDTO {
  final String userEmail;
  final String registrationId;
  final String eventName;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String location;

  ConfirmationEmailDTO({
    required this.userEmail,
    required this.registrationId,
    required this.eventName,
    required this.startDateTime,
    required this.endDateTime,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': userEmail,
      'registrationId': registrationId,
      'eventName': eventName,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'location': location,
    };
  }
}