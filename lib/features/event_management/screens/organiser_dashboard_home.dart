import 'package:app_mobile_frontend/core/models/event_models.dart';
import 'package:app_mobile_frontend/api/event_services.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/features/event_management/widgets/events_slideshow.dart';
import 'package:logging/logging.dart';

class OrganiserDashboard extends StatefulWidget {
  // Constructor to initialize the organiserId.
  OrganiserDashboard({super.key});
  @override
  State<OrganiserDashboard> createState() => _OrganiserDashboardState();
}

Future<Events> _getOrganizersEvents() async {
  // Show all statuses for organizer's own events
  final events = await getFilteredEvents("myEvents=true");
  return events;
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
        return EventSlideshow(
          events: eventsData,
          context: context,
          key: key,
        );
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
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

final Logger _logger = Logger('OrgDashboard');
