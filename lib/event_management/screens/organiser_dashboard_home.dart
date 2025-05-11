import 'package:app_mobile_frontend/models/event.dart';
import 'package:app_mobile_frontend/network/event.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/event_management/widgets/events_slideshow.dart';


class OrganiserDashboard extends StatefulWidget
{
  // Constructor to initialize the organiserId.
  OrganiserDashboard({super.key});


  @override State<OrganiserDashboard> createState() => _OrganiserDashboardState();  

}

Future<Events> _getOrganizersEvents() async {
  return await getFilteredEvents("myEvents=true");
}

Widget _buildEventSlideshow(Future<Events> futureEvents, {Key? key}) {
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
        eventsData.events.forEach((event) {
          print('Event Name: ${event.name}');
        });
        return EventSlideshow(events: eventsData, context: context, key: key,);
      }
    },
  );
}


class _OrganiserDashboardState extends State<OrganiserDashboard> {
 
  late Future<Events> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = _getOrganizersEvents();
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEventSlideshow(futureEvents, key: Key('event_slideshow')),
            const SizedBox(height: 16),
          ],
        ),
      );
  }
}
