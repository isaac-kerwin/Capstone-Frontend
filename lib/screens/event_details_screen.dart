import 'package:flutter/material.dart';
import 'payment_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("Event Details"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: "Tickets"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 200, width: double.infinity, color: Colors.amber),
            const SizedBox(height: 20),
            const Text("Melbourne Italian Festa 2024", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("40/100 Spots Filled", style: TextStyle(color: Colors.blueAccent)),
            const SizedBox(height: 16),
            const Row(children: [Icon(Icons.calendar_month), SizedBox(width: 8), Text("Saturday 5th October 2024\n3pm to 11.30pm")]),
            const SizedBox(height: 12),
            const Row(children: [Icon(Icons.location_on), SizedBox(width: 8), Expanded(child: Text("Royal Exhibition Building\n9 Nicholson St, Carlton VIC 3053"))]),
            const SizedBox(height: 20),
            const Text("About Event", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text("Enjoy your favorite food, and a lovely day with your friends and family. Food from local food trucks will be available for purchase."),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaymentScreen()),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text("BUY TICKET \$15"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
