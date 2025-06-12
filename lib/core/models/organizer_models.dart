class Organizer {
  final int id;
  final String firstName;
  final String lastName;

  Organizer(
    {required this.id, required this.firstName, required this.lastName});
}

class OrganizerName {
  final String firstName;
  final String lastName;

  OrganizerName({required this.firstName, required this.lastName});

  factory OrganizerName.fromJson(Map<String, dynamic> json) {
    return OrganizerName(
        firstName: json["firstName"], lastName: json["lastName"]);
  }
}
