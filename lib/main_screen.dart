// lib/main_screen.dart

import 'package:first_app/network/users.dart';
import 'package:flutter/material.dart';
import 'package:first_app/event_exploration/screens/explore.dart';
import 'package:first_app/event_management/screens/organiser_dashboard_home.dart';
import 'package:first_app/login_and_register/screens/login.dart';
import 'package:first_app/get_user.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({ Key? key, this.initialIndex = 0 }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  bool _isOrganizer = false;
  bool _isLoading   = true;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;  // pick up initialIndex from login.dart
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final profile = await getUserProfile();
    if (profile?.role == 'ORGANIZER') {
      _isOrganizer = true;
    }
    setState(() => _isLoading = false);
  }

  void _onItemTapped(int index) {
    // Dashboard tab is at index 1
    if (index == 1 && !_isOrganizer) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Access denied: Organizer dashboard is for organizers only.'),
        ),

      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          Explore(),
          OrganiserDashboard(organiserId: 1, key: Key('organiser_dashboard_home')),
          LoginScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
