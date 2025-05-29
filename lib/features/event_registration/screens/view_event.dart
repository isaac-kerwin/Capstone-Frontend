import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/core/fundamental_widgets/action_button.dart';
import 'package:app_mobile_frontend/models/event.dart';


class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          toolbarHeight: 40,
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          titleSpacing: 0,
          leadingWidth: 40,
          leading: IconButton(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full-width yellow banner
              Container(
                height: 250,
                width: double.infinity,
                color: Colors.amber[200],
              ),
              const SizedBox(height: 16),

              // Event title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Melbourne Italian Festa 2024',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Going count
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  '+20 Going',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ),

              // Date and time
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Saturday 5th October 2024\n3pm to 11:30pm',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              // Location
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 20, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Royal Exhibition Building\n9 Nicholson St, Carlton VIC 3053',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              // About Event
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'About Event',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Enjoy your favorite food, and a lovely day with your friends and family. Food from local food trucks will be available for purchase.',
                  style: TextStyle(fontSize: 14),
                ),
              ),

              // Read More link
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  child: const Text('Read More...'),
                ),
              ),

              const SizedBox(height: 24),

              // Buy Ticket Button using ActionButton
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: ActionButton(
                  text: 'REGISTER FOR EVENT',
                  icon: Icons.arrow_forward,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}