import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/network/auth.dart';
import 'package:flutter/material.dart' ;// Needed to initialize Flutter bindings
import 'package:first_app/models/user.dart';
import 'package:first_app/network/users.dart';

void main() {
  // Ensure Flutter is initialized before running tests
  WidgetsFlutterBinding.ensureInitialized(); 

/*   test('Test get user profile', () async {
    loginUser("admin@example.com", "Admin123");
    await getUserProfile(5);
    expect(true, true);
  }); */

  test('Test get all users', () async {
    await loginUser("ADMIN2@example.com", "Admin123");
    await getAllUsers();
    expect(true, true);
  });

  test('Update user role', () async {
    await loginUser("ADMIN2@example.com", "Admin123");
    await updateUserRole(1, "PARTICIPANT", "ORGANIZER");
    expect(true, true);
  });

  test('Update user profile', () async {
    await loginUser("ADMIN2@example.com", "Admin123");
    UpdateUserProfileDTO updatedProfile = UpdateUserProfileDTO(
      firstName: "Garry",
    );
    await updateUserProfile(5, updatedProfile);
    expect(true, true);
  });

  test('Delete user', () async {
    await loginUser("ADMIN2@example.com", "Admin123");
    await deleteUser(5);
    expect(true, true);
  });
}

