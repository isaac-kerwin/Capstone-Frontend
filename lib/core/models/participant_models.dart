/// Represents a participant's registration record for listings and attendance tracking.
class Participant {
  /// Unique identifier for the participant.
  final String id;
  /// Full name of the participant.
  final String name;
  /// Email address of the participant.
  final String email;
  /// Phone number of the participant.
  final String phone;
  /// Type of ticket purchased by the participant.
  final String ticketType;
  /// Date and time when the participant registered.
  final DateTime registrationDate;
  /// Whether the participant has checked in.
  final bool checkedIn;

  /// Constructs a [Participant] record with contact and status info.
  Participant({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.ticketType,
    required this.registrationDate,
    required this.checkedIn,
  });
}

/// Data Transfer Object for creating or updating participant information.
class ParticipantDTO {
  /// Participant's email address.
  final String email;
  /// Participant's first name.
  final String firstName;
  /// Participant's last name.
  final String lastName;
  /// Optional phone number.
  String? phone;
  /// Optional date of birth string.
  String? dateOfBirth;
  /// Optional street address.
  String? adress;
  /// Optional city name.
  String? city;
  /// Optional state or region.
  String? state;
  /// Optional ZIP or postal code.
  String? zipCode;
  /// Optional country name.
  String? country;

  /// Constructs a [ParticipantDTO] with contact and optional demographic fields.
  ParticipantDTO({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.dateOfBirth,
    this.adress,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  /// Serializes this DTO to JSON for API requests.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'adress': adress,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }
}