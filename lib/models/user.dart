class RegisterUserDTO {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? phoneNo;

  RegisterUserDTO(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      this.phoneNo
      });

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

class UpdateUserProfileDTO{
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNo;

  UpdateUserProfileDTO(
      {this.firstName,
      this.lastName,
      this.email,
      this.phoneNo});

  Map<String, dynamic> toJson() {   return {
      if (firstName != null) "firstName": firstName,
      if (lastName != null) "lastName": lastName,
      if (email != null) "email": email,
      if (phoneNo != null) "phoneNo": phoneNo
    };
  }
}

class Users{
}
class User{
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNo,
      required this.role,
      required this.createdAt,
      required this.updatedAt});

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
class UserProfile{
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;
  final String role;

  UserProfile(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNo,
      required this.role}
    );
    
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
class ChangePasswordDTO{
  final String oldPassword;
  final String newPassword;

  ChangePasswordDTO(
      {required this.oldPassword,
      required this.newPassword});

  Map<String, dynamic> toJson() {
    return {
      "oldPassword": oldPassword,
      "newPassword": newPassword
    };
  } 
}

class CreateUserDTO{
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? phoneNo;
  final String role;

  CreateUserDTO(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      this.phoneNo,
      required this.role});

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