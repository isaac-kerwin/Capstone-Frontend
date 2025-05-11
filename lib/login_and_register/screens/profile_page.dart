import 'package:app_mobile_frontend/network/users.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/event_exploration/screens/explore.dart';
import 'package:app_mobile_frontend/event_management/screens/organiser_dashboard_home.dart';
import 'package:app_mobile_frontend/login_and_register/screens/login.dart';
import 'package:app_mobile_frontend/get_user.dart';
import 'package:app_mobile_frontend/models/user.dart';
import 'package:app_mobile_frontend/main_screen.dart';
import 'package:app_mobile_frontend/network/auth.dart';
import 'package:app_mobile_frontend/login_and_register/screens/change_password.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Account')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,   // vertical centring
          crossAxisAlignment: CrossAxisAlignment.stretch, // ← makes children fill width
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              onPressed: () async {
                await logoutUser();           // clear token / cookies
                if (context.mounted) {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
                }
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.password),
              label: const Text('Change password'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}