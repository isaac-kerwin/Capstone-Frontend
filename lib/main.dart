import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/network/auth.dart';
import 'main_screen.dart';
import 'package:app_mobile_frontend/themes/app_themes.dart';
import 'package:app_mobile_frontend/network/dio_client.dart';

Future<void> main() async {
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