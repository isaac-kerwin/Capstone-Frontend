import 'package:flutter/material.dart';
import 'package:first_app/network/auth.dart';
import 'main_screen.dart';
import 'package:first_app/themes/app_themes.dart';
import 'package:first_app/network/dio_client.dart';

Future<void> main() async {
 // For production
  await loginUser("admin@example.com", "Admin123!");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();  
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      home: const MainScreen(),
    );
  }
} 