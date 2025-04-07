import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/network/auth.dart';
import 'package:flutter/material.dart';// Needed to initialize Flutter bindings
import 'package:first_app/models/user.dart';

void main() {
  // Ensure Flutter is initialized before running tests
  WidgetsFlutterBinding.ensureInitialized(); 

  test('Login function should return success', () async {
    await loginUser("isaac1@gmail.com", "Isaac123");
    expect(true, true); // Placeholder
  });

  test('Refresh Token Test', () async {
    await refreshToken();
    expect(true, true);
  });

  test('register event test', () async {
    RegisterUserDTO user = RegisterUserDTO
    (
      email:"test125@gmail.com",
      password: "Isaac123",
      lastName: "Kerwin",
      firstName: "Isaac",
    );

    await registerUser(user);
    expect(true, true);
  });
}