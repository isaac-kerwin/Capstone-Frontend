import 'package:flutter/material.dart';
import 'package:first_app/network/auth.dart';
import 'main_screen.dart';

Future<void> main() async {
  await loginUser("ORGANIZER@example.com", "Organizer123");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}