import 'package:flutter/material.dart';
import 'details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Events'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Melbourne Italian\nFesta 2024',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('30/90 Filled Capacity', style: TextStyle(color: Color(0xFF4A55FF))),
            const SizedBox(height: 40),
            _buildButton(context, 'MORE DETAILS', () {
              Navigator.of(context).push(_createSlideRoute());
            }),
            const SizedBox(height: 16),
            _buildButton(context, 'CREATE NEW EVENT', () {
              // TODO: Navigate to Create Event Page
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A55FF),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(color: Colors.white)),
          const Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }

  Route _createSlideRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const DetailsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, -1); // Slide down
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
