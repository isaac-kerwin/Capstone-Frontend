import 'package:first_app/models/event.dart';
import 'package:first_app/network/event.dart';
import 'package:flutter/material.dart';
import 'package:first_app/event_management/widgets/events_slideshow.dart';


class OrganiserDashboard extends StatefulWidget
{
  final int organiserId;
  // Constructor to initialize the organiserId.
  OrganiserDashboard({super.key, required this.organiserId});


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
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      futureEvents = _getOrganizersEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildEventSlideshow(futureEvents, key: Key('event_slideshow')),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
