import 'package:app_mobile_frontend/network/users.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/features/event_exploration/screens/explore.dart';
import 'package:app_mobile_frontend/features/event_management/screens/organiser_dashboard_home.dart';
import 'package:app_mobile_frontend/features/login_and_register/screens/login.dart';
import 'package:app_mobile_frontend/features/login_and_register/screens/profile_page.dart';

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
  bool _isLoggedIn  = false;
  int _userId = 0;


  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;  // pick up initialIndex from login.dart
    _loadUserRole();
  }

             
  Future<void> _loadUserRole() async {
    final profile = await getUserProfile();
    if (profile != null) {
      _isLoggedIn  = true;
      _isOrganizer = profile.role == 'ORGANIZER';
      _userId = profile.id;
    }
    setState(() => _isLoading = false);
  }

  void _onItemTapped(int index) {
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

    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.explore),  label: 'Explore'),
      if (_isOrganizer)
        const BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      _isLoggedIn
          ? const BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account')
          : const BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
    ];

    final screens = <Widget>[
      const Explore(),
      if (_isOrganizer)
        OrganiserDashboard(key: Key('organiser_dashboard_home')),
      _isLoggedIn ? const ProfileScreen() : const LoginScreen(),
    ];


    return Scaffold(
      appBar: AppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
