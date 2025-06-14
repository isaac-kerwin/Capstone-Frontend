/// Represents basic organizer contact information.
class Organizer {
  /// Unique organizer identifier.
  final int id;
  /// Organizer's first name.
  final String firstName;
  /// Organizer's last name.
  final String lastName;

  /// Constructs an [Organizer] record.
  Organizer(
      {required this.id, required this.firstName, required this.lastName});
}

/// Represents only the name fields for an organizer, used in nested event responses.
class OrganizerName {
  /// Organizer's first name.
  final String firstName;
  /// Organizer's last name.
  final String lastName;

  /// Constructs an [OrganizerName].
  OrganizerName({required this.firstName, required this.lastName});

  /// Creates an [OrganizerName] from JSON.
  factory OrganizerName.fromJson(Map<String, dynamic> json) {
    return OrganizerName(
      firstName: json["firstName"],
      lastName: json["lastName"],
    );
  }
}
