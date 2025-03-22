import 'package:flutter/material.dart';
import 'package:first_app/screens/new_registration_form_generator.dart';
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
  void initState(){
    super.initState();
    eventsFuture = getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: FutureBuilder<Events>(
        future: eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.events.isEmpty) {
            return const Center(child: Text('No events available'));
          }

          final events = snapshot.data!.events;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(event.name),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Navigate to the RegistrationForm and pass the event id.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegistrationForm(eventId: event.id),
                      ),
                    );
                  },
                  child: const Text('Register'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}