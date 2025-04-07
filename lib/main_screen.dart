import 'package:flutter/material.dart';
import 'package:first_app/event_exploration/screens/explore.dart';
import 'package:first_app/event_management/screens/organiser_dashboard_home.dart';
import 'package:first_app/login_and_register/screens/login.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens that correspond to the bottom navigation items.
  final List<Widget> _screens = [
    Explore(),
    OrganiserDashboard(organiserId: 1), // Example organiserId  
    LoginScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // IndexedStack maintains the state of each screen.
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.align_horizontal_left_sharp ),
            label: 'In Progress',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black, 
  
        onTap: _onItemTapped,
      ),
    );
  }
}