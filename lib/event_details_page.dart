import 'package:flutter/material.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Your Events',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Melbourne Italian\nFesta 2024',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '30/90 Filled Capacity',
              style: TextStyle(color: Color(0xFF4A55FF)),
            ),
            const SizedBox(height: 30),

            // Date Section
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8ECFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.calendar_today, color: Color(0xFF4A55FF)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Saturday 5th October 2024',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '3pm to 11.30pm',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Location Section
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8ECFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.location_on, color: Color(0xFF4A55FF)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Royal Exhibition Building',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '9 Nicholson St, Carlton VIC 3053',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Carousel indicator
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(true),
                  const SizedBox(width: 8),
                  _buildDot(false),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Buttons
            _buildButton('MORE DETAILS'),
            const SizedBox(height: 16),
            _buildButton('CREATE NEW EVENT'),
            const SizedBox(height: 16),
            _buildButton('TICKET GENERATE'),
          ],
        ),
      ),
    );
  }

  // Dot Indicator
  static Widget _buildDot(bool isActive) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }

  // Reusable Button
  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () {},
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
}
