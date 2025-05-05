import 'dart:ffi';
import 'package:first_app/network/dio_client.dart';
import 'package:first_app/models/user.dart';
import 'package:dio/dio.dart';
import 'package:first_app/network/auth.dart';


Future<void> updateUserProfile(int id, UpdateUserProfileDTO updatedProfile) async {
  try {
    final response = await dioClient.dio.put(
      "/users/profile",
      data: updatedProfile.toJson(),
      options: Options(
        headers
          : {
            'Authorization': 'Bearer ${accessToken}',
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
    final response = await dioClient.dio.get("user/profile"
      , options: Options(
        headers:{
          'Authorization': 'Bearer ${accessToken}',
        },
    ));
    if (response.data["success"]){
      final UserProfile userProfile = UserProfile.fromJson(response.data["data"]);
      return userProfile;
    }
    else {
      return null;
    }
  }
  catch (error) {
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
