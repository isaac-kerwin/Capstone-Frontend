/// Data for registering a new user.
class RegisterUserDTO {
  /// User's first name.
  final String firstName;
  /// User's last name.
  final String lastName;
  /// User's email address.
  final String email;
  /// User's chosen password.
  final String password;
  /// Optional phone number.
  final String? phoneNo;

  /// Constructs a new [RegisterUserDTO].
  RegisterUserDTO(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      this.phoneNo
      });

  /// Converts registration data into JSON for API requests.
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
      if (phoneNo == null) "phoneNo": "123456789" else "phoneNo": phoneNo
    };
  }
}

/// Data for updating user profile information.
class UpdateUserProfileDTO {
  /// Optional new first name.
  final String? firstName;
  /// Optional new last name.
  final String? lastName;
  /// Optional new email address.
  final String? email;
  /// Optional new phone number.
  final String? phoneNo;

  /// Constructs an [UpdateUserProfileDTO] with optional fields.
  UpdateUserProfileDTO(
      {this.firstName,
      this.lastName,
      this.email,
      this.phoneNo});

  /// Serializes only non-null fields to JSON for patch requests.
  Map<String, dynamic> toJson() {   return {
      if (firstName != null) "firstName": firstName,
      if (lastName != null) "lastName": lastName,
      if (email != null) "email": email,
      if (phoneNo != null) "phoneNo": phoneNo
    };
  }
}

/// Represents a paginated list of users. (Placeholder class)
class Users{
  // No implementation needed currently.
}

/// Detailed user information returned from the server.
class User{
  /// Unique user identifier.
  final int id;
  /// User's first name.
  final String firstName;
  /// User's last name.
  final String lastName;
  /// User's email.
  final String email;
  /// User's phone number.
  final String phoneNo;
  /// User role (e.g., admin, attendee).
  final String role;
  /// Account creation timestamp.
  final DateTime createdAt;
  /// Last update timestamp.
  final DateTime updatedAt;

  /// Constructs a [User] instance.
  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNo,
      required this.role,
      required this.createdAt,
      required this.updatedAt});

  /// Creates a [User] from JSON data.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneNo: json["phoneNo"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]));
  }
}

/// Profile information for the current user.
class UserProfile{
  /// Unique profile identifier.
  final int id;
  /// User's first name.
  final String firstName;
  /// User's last name.
  final String lastName;
  /// User's email.
  final String email;
  /// Optional phone number.
  final String? phoneNo;
  /// Role of the user.
  final String role;

  /// Constructs a [UserProfile].
  UserProfile(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.phoneNo,
      required this.role}
    );

    /// Creates a [UserProfile] from JSON data.
    factory UserProfile.fromJson(Map<String, dynamic> json) {

      return UserProfile(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneNo: json["phoneNo"],
        role: json["role"]
      );
    }

}

/// DTO for changing a user's password.
class ChangePasswordDTO{
  /// Current password.
  final String oldPassword;
  /// New desired password.
  final String newPassword;

  /// Constructs a [ChangePasswordDTO].
  ChangePasswordDTO(
      {required this.oldPassword,
      required this.newPassword});

  /// Converts the password change data to JSON.
  Map<String, dynamic> toJson() {
    return {
      "oldPassword": oldPassword,
      "newPassword": newPassword
    };
  } 
}

/// Data for creating a new user by an admin.
class CreateUserDTO{
  /// User's first name.
  final String firstName;
  /// User's last name.
  final String lastName;
  /// User's email address.
  final String email;
  /// Temporary password for the user.
  final String password;
  /// Optional phone number.
  final String? phoneNo;
  /// Role assigned to the new user.
  final String role;

  /// Constructs a [CreateUserDTO].
  CreateUserDTO(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      this.phoneNo,
      required this.role});

  /// Serializes the user data to JSON for API calls.
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
      if (phoneNo == null) "phoneNo": "" else "phoneNo": phoneNo,
      "role": role 
    };
  }
}