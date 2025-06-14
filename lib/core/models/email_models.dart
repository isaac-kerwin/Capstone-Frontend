/// Data transfer object representing an email payload for event-related operations.
/// Includes recipient address, registration details, event metadata, and message type.
class EmailDTO {
  /// The recipient's email address.
  final String email;
  /// Unique identifier for the user's registration.
  final String registrationID;
  /// The name of the associated event.
  final String eventName;
  /// Event start date and time.
  final DateTime startDateTime;
  /// Event end date and time.
  final DateTime endDateTime;
  /// Location where the event will take place.
  final String location;
  /// Type of email being sent (e.g., confirmation, reminder).
  final String type;

  /// Constructs an EmailDTO with all required fields.
  EmailDTO({
    required this.email,
    required this.registrationID,
    required this.eventName,
    required this.startDateTime,
    required this.endDateTime,
    required this.location,
    required this.type,
  });

  /// Serializes this object to a JSON-compatible map.
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

/// Payload for confirmation email when user registers for an event.
/// Contains user address, registration reference, and event details.
class ConfirmationEmailDTO {
  /// The email address of the user to confirm.
  final String userEmail;
  /// Registration identifier associated with the confirmation.
  final String registrationId;
  /// Name of the event for which confirmation is sent.
  final String eventName;
  /// Event start date and time to include in confirmation.
  final DateTime startDateTime;
  /// Event end date and time to include in confirmation.
  final DateTime endDateTime;
  /// Event location included in the confirmation.
  final String location;

  /// Constructs a ConfirmationEmailDTO with all required event details.
  ConfirmationEmailDTO({
    required this.userEmail,
    required this.registrationId,
    required this.eventName,
    required this.startDateTime,
    required this.endDateTime,
    required this.location,
  });

  /// Converts this object into a JSON-compatible map for API calls.
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