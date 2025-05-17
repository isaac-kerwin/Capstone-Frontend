import 'package:app_mobile_frontend/network/dio_client.dart';
import 'package:app_mobile_frontend/models/user.dart';
import 'package:dio/dio.dart';
import 'package:app_mobile_frontend/network/auth.dart';


Future<void> updateUserProfile(int id, UpdateUserProfileDTO updatedProfile) async {
  try {
    final response = await dioClient.dio.put(
      "/users/profile",
      data: updatedProfile.toJson(),
      options: Options(
        headers
          : {
            'Authorization': 'Bearer ${await getToken()}',
          },
    ));
    if (response.data["success"]) {
      print("User profile updated successfully: ${response.data}");
    } else {
      print("Failed to update user profile: ${response.data}");
    }
  } catch (error) {
    print("Error updating user profile: $error");
  } 
}
Future<UserProfile?> getUserProfile() async {
  try {
    print("Access Token: ${ await getToken()}");
    final response = await dioClient.dio.get(
      "/user/profile",         
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
        },
      ),
    );

      print("Data: ${response.data["data"]}");
      print("Success: ${response.data["success"]}");


    if (response.data["success"] == true) {
      return UserProfile.fromJson(response.data["data"]);
    } else {
      return null;
    }
  } catch (error) {
    
    print("Error retrieving user profile: $error");
    return null;
  }
}

Future<void> createUser(CreateUserDTO user) async {
  try {
    final response = await dioClient.dio.post(
      "/user",
      data: user.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer ${accessToken}',
        },
      ),
    );
    if (response.data["success"]) {
      print("User created successfully: ${response.data}");
    } else {
      print("Failed to create user: ${response.data}");
    }
  } catch (error) {
    print("Error creating user: $error");
  }
}

Future<void> getAllUsers() async {
  try {
    print("Access Token: $accessToken");
    final response = await dioClient.dio.get(
      "/user",
      options: Options(
        headers: {
          'Authorization': 'Bearer ${accessToken}',
        },
      ),
    );
    if (response.data["success"]) {
      final List<User> users = (response.data["data"] as List)
          .map((user) => User.fromJson(user))
          .toList();
      print("Users retrieved successfully: $users");
    } else {
      print("Failed to retrieve users: ${response.data}");
    }
  } catch (error) {
    print("Error retrieving users: $error");
  }
}

Future<void> getUserById(int id) async {
  try {
    final response = await dioClient.dio.get(
      "/user/$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer ${accessToken}',
        },
      ),
    );
    if (response.data["success"]) {
      final User user = User.fromJson(response.data["data"]);
      print("User retrieved successfully: $user");
    } else {
      print("Failed to retrieve user: ${response.data}");
    }
  } catch (error) {
    print("Error retrieving user: $error");
  }
}

Future<void> updateUserRole(int id, String oldRole, String newRole) async {
  try {
    final response = await dioClient.dio.put(
      "/user/$id",
      data: {
        "oldRole": oldRole,
        "newRole": newRole,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${accessToken}',
        },
      ),
    );
    if (response.data["success"]) {
      print("User role updated successfully: ${response.data}");
    } else {
      print("Failed to update user role: ${response.data}");
    }
  } catch (error) {
    print("Error updating user role: $error");
  }
}

Future<void> deleteUser(int id) async {
  try {
    final response = await dioClient.dio.delete(
      "/user/$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer ${accessToken}',
        },
      ),
    );
    if (response.data["success"]) {
      print("User deleted successfully: ${response.data}");
    } else {
      print("Failed to delete user: ${response.data}");
    }
  } catch (error) {
    print("Error deleting user: $error");
  }
}
/// Returns the raw 'role' string, or null on any error.
Future<String?> getUserRole() async {
  try {
    final resp = await dioClient.dio.get("/user/profile");
    final data = resp.data["data"];
    final role = data["role"];
    if (role is String) return role;
    return null;
  } catch (e) {
    print("Error fetching role: $e");
    return null;
  }
}

Future<bool> changePassword(String oldPassword, String newPassword) async {
  try {
    final response = await dioClient.dio.post(
      "/user/change-password",
      data: {
        "currentPassword": oldPassword,
        "newPassword": newPassword,
      },
    );
    if (response.data["success"]) {
      print("Password changed successfully: ${response.data}");
      return true;
    } else {
      print("Failed to change password: ${response.data}");
      return false;
    }
  } catch (error) {
    print("Error changing password: $error");
    return false;
  }
}

