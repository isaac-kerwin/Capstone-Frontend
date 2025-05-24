
class EmailDTO{
  final String email;
  final String registrationID; 
  final String eventName;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String location;
  final String type;

  EmailDTO({
    required this.email, required this.registrationID, required this.eventName, 
    required this.startDateTime, required this.endDateTime,
    required this.location, required this.type
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'registrationID': registrationID,
      'eventName': eventName,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'location': location,
      'type': type,
    };
  }
}