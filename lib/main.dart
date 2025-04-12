import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const EventDiscoveryApp());

class EventDiscoveryApp extends StatelessWidget {
  const EventDiscoveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Discovery',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurpleAccent,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
