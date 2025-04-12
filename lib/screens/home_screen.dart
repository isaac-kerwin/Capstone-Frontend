import 'package:flutter/material.dart';
import '../widgets/category_chip.dart';
import '../widgets/event_card.dart';
import 'filter_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "All";

  final List<Map<String, String>> allEvents = [
    {
      'date': '9 OCT',
      'title': 'International Band Music',
      'location': '24 Wakefield Street, Hawthorn',
      'category': 'Music',
    },
    {
      'date': '30 SEP',
      'title': 'Jo Malone Experience',
      'location': '18 Brunswick St, Fitzroy',
      'category': 'Art',
    },
    {
      'date': '12 NOV',
      'title': 'Burger Festival 2024',
      'location': 'Main Square, Richmond',
      'category': 'Food',
    },
    {
      'date': '5 DEC',
      'title': 'FIFA Fan Meet',
      'location': 'MCG Stadium, Melbourne',
      'category': 'Sports',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredEvents = selectedCategory == "All"
        ? allEvents
        : allEvents.where((e) => e['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search + Filter
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FilterScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.filter_list, color: Colors.white),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Category Chips
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryChip(
                      label: 'All',
                      color: Colors.grey,
                      isSelected: selectedCategory == 'All',
                      onTap: () => setState(() => selectedCategory = 'All'),
                    ),
                    const SizedBox(width: 8),
                    CategoryChip(
                      label: 'Sports',
                      color: Colors.redAccent,
                      isSelected: selectedCategory == 'Sports',
                      onTap: () => setState(() => selectedCategory = 'Sports'),
                    ),
                    const SizedBox(width: 8),
                    CategoryChip(
                      label: 'Music',
                      color: Colors.orangeAccent,
                      isSelected: selectedCategory == 'Music',
                      onTap: () => setState(() => selectedCategory = 'Music'),
                    ),
                    const SizedBox(width: 8),
                    CategoryChip(
                      label: 'Food',
                      color: Colors.green,
                      isSelected: selectedCategory == 'Food',
                      onTap: () => setState(() => selectedCategory = 'Food'),
                    ),
                    const SizedBox(width: 8),
                    CategoryChip(
                      label: 'Art',
                      color: Colors.blueAccent,
                      isSelected: selectedCategory == 'Art',
                      onTap: () => setState(() => selectedCategory = 'Art'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Upcoming Events
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Upcoming Events', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  GestureDetector(
                    onTap: () {
                      // future: Navigator.push to full events screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Navigate to All Upcoming Events")),
                      );
                    },
                    child: const Text('See All >', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: filteredEvents
                      .map((event) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: EventCard(
                              date: event['date']!,
                              title: event['title']!,
                              location: event['location']!,
                            ),
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 20),

              // All Events
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('All Events', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  GestureDetector(
                    onTap: () {
                      // future: Navigator.push to full events screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Navigate to All Events")),
                      );
                    },
                    child: const Text('See All >', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    );
  }
}
