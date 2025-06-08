import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/core/models/organizer.dart'; // Update path as needed

void main() {
  group('Organizer Models', () {
    test('T1.2.1 - Test creation of Organizer object', () {
      final organizer = Organizer(id: 1, firstName: "Firstname", lastName: "Lastname");

      expect(organizer.id, 1);
      expect(organizer.firstName, "Firstname");
      expect(organizer.lastName, "Lastname");
    });

    test('T1.2.2 - Test creation of OrganizerName object', () {
      final organizerName = OrganizerName(firstName: "firstname", lastName: "lastname");

      expect(organizerName.firstName, "firstname");
      expect(organizerName.lastName, "lastname");
    });

    test('T1.2.3 - Test OrganizerName.fromJson with valid JSON', () {
      final json = {
        "firstName": "firstname",
        "lastName": "lastname"
      };

      final organizerName = OrganizerName.fromJson(json);
      expect(organizerName.firstName, "firstname");
      expect(organizerName.lastName, "lastname");
    });

    test('T1.2.4 - Test OrganizerName.fromJson with missing field', () {
      final json = {
        "firstName": "OnlyFirst"
      };

      expect(() => OrganizerName.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('T1.2.5 - Test OrganizerName.fromJson with null values', () {
      final json = {
        "firstName": null,
        "lastName": null,
      };

      expect(() => OrganizerName.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}