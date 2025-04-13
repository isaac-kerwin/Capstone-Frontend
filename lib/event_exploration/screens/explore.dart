import 'package:flutter/material.dart';
import 'package:first_app/event_registration/screens/new_registration_form_generator.dart';
import 'package:first_app/models/event.dart';
import 'package:first_app/network/event.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late Future<Events> eventsFuture;

  @override
  void initState() {
    super.initState();
    eventsFuture = getAllEvents();
  }

  void _register(EventDetails event) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegistrationForm(eventId: event.id),
        ),
      );
    });
  }

  Widget _buildEventItem(EventDetails event) {
    DateTime date = event.startDateTime;
    String month = _getMonthAbbreviation(date.month);
    String day = date.day.toString();

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date box
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(day, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(month, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            event.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text('+20 Going', style: TextStyle(fontSize: 12, color: Colors.grey[800])),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.location,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': 'Sports', 'icon': Icons.sports_basketball, 'color': Colors.orange},
      {'label': 'Music', 'icon': Icons.music_note, 'color': Colors.redAccent},
      {'label': 'Food', 'icon': Icons.fastfood, 'color': Colors.green},
      {'label': 'Art', 'icon': Icons.palette, 'color': Colors.blue},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location and filter row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.location_on, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(
                        'Melbourne, Vic',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_alt, color: Colors.blue),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Category chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        avatar: Icon(cat['icon'] as IconData, size: 16, color: Colors.white),
                        label: Text(cat['label'] as String),
                        backgroundColor: cat['color'] as Color,
                        labelStyle: const TextStyle(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Upcoming Events section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Text('See All'),
                        Icon(Icons.chevron_right, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Horizontal Event List
              FutureBuilder<Events>(
                future: eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.events.isEmpty) {
                    return const Center(child: Text('No events available'));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!.events.map(_buildEventItem).toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Near You section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Near You',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Text('See All'),
                        Icon(Icons.chevron_right, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Vertical Event List (same data)
              FutureBuilder<Events>(
                future: eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.events.isEmpty) {
                    return const Center(child: Text('No events available'));
                  }

                  return Column(
                    children: snapshot.data!.events.map((event) {
                      return GestureDetector(
                        onTap: () => _register(event),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.event, color: Colors.blue),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(event.location, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _register(event),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                                child: const Text('Register'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
