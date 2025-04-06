import 'package:first_app/models/event.dart';
import 'package:first_app/network/event.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/events_slideshow.dart';


class OrganiserDashboard extends StatefulWidget
{
  final int organiserId;
  // Constructor to initialize the organiserId.
  const OrganiserDashboard({super.key, required this.organiserId});

  @override State<OrganiserDashboard> createState() => _OrganiserDashboardState();  

}

Future<Events> _getEventsByOrganizerId(int id) async {
  return await getEventsByOrganizerId(id);
}

Widget _buildEventSlideshow(Future<Events> futureEvents) {
  return FutureBuilder<Events>(
    future: futureEvents,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData) {
        return const Text('No events found.');
      } else {
        final eventsData = snapshot.data!;

        return EventSlideshow(events: eventsData, context: context,);
      }
    },
  );
}


class _OrganiserDashboardState extends State<OrganiserDashboard> {
 
  late Future<Events> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = _getEventsByOrganizerId(widget.organiserId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEventSlideshow(futureEvents),
            const SizedBox(height: 16),
          ],
        ),
      );
  }
}
