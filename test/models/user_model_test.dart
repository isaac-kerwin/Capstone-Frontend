import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/user.dart'; // Update this path to your actual model file

void main() {
  group('User Model & DTO Tests', () {
    test('T1.7.1 - Test RegisterUserDTO.toJson with all fields', () {
      final dto = RegisterUserDTO(
        firstName: "Isaac",
        lastName: "Newton",
        email: "isaac@example.com",
        password: "securePass123",
        phoneNo: "1234567890",
      );

      final json = dto.toJson();
      expect(json["firstName"], "Isaac");
      expect(json["phoneNo"], "1234567890");
    });

    test('T1.7.2 - Test partial fields for UpdateUserProfileDTO.toJson', () {
      final dto = UpdateUserProfileDTO(
        firstName: "Marie",
        email: "marie@example.com",
      );

      final json = dto.toJson();
      expect(json.containsKey("firstName"), true);
      expect(json.containsKey("email"), true);
      expect(json.containsKey("lastName"), false);
    });

    test('T1.7.3 - Test UpdateUserProfileDTO with no fields', () {
      final dto = UpdateUserProfileDTO();
      final json = dto.toJson();
      expect(json, isEmpty);
    });

    test('T1.7.4 - Test create a valid User object from JSON', () {
      final json = {
        "id": 1,
        "firstName": "Alan",
        "lastName": "Turing",
        "email": "alan@code.com",
        "phoneNo": "123456789",
        "role": "admin",
        "createdAt": "2025-01-01T10:00:00Z",
        "updatedAt": "2025-01-01T10:30:00Z"
      };

      final user = User.fromJson(json);
      expect(user.email, "alan@code.com");
      expect(user.role, "admin");
    });

    test('T1.7.5 - Test User.fromJson with missing required field', () {
      final json = {
        // Missing "email"
        "id": 2,
        "firstName": "Ada",
        "lastName": "Lovelace",
        "phoneNo": "999999999",
        "role": "user",
        "createdAt": "2025-01-01T10:00:00Z",
        "updatedAt": "2025-01-01T10:30:00Z"
      };

      expect(() => User.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('T1.7.6 - Test ChangePasswordDTO.toJson', () {
      final dto = ChangePasswordDTO(
        oldPassword: "old123",
        newPassword: "new456",
      );

      final json = dto.toJson();
      expect(json["oldPassword"], "old123");
      expect(json["newPassword"], "new456");
    });

    test('T1.7.7 - Test CreateUserDTO with null phone number', () {
      final dto = CreateUserDTO(
        firstName: "Grace",
        lastName: "Hopper",
        email: "grace@navy.com",
        password: "password123",
        role: "admin",
        phoneNo: null,
      );

      final json = dto.toJson();
      expect(json["phoneNo"], ""); // should default to empty string
    });
  });
}
