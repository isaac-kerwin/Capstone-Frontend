class Participant {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String ticketType;
  final DateTime registrationDate;
  final bool checkedIn;

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

class ParticipantDTO {
  final String email;
  final String firstName;
  final String lastName;
  String? phone;
  String? dateOfBirth;
  String? adress;
  String? city;
  String? state;
  String? zipCode;
  String? country;

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