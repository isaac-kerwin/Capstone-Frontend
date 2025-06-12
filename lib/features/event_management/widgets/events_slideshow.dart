import 'package:app_mobile_frontend/core/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/core/models/event_models.dart';
import 'package:app_mobile_frontend/features/event_creation/screens/event_details.dart';
import 'package:app_mobile_frontend/features/event_management/screens/manage_event.dart';
import 'package:app_mobile_frontend/features/event_management/widgets/event_info_tile.dart';
import 'package:app_mobile_frontend/api/event_services.dart';


class EventSlideshow extends StatelessWidget {
  final Events events;
  final BuildContext context;


  const EventSlideshow({Key? key, required this.events,  required this.context}) : super(key: key);

  _createEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEventPage(key: Key('create_event_screen'),),
      ),
    );
  }

  _moreDetails(event){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(event: event),
      ),
    );  
  }

  Future<void> _publish(EventDetails event) async {
    try {
      await publishEvent(event.id);                 // ← implement in network layer
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event published!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not publish: $e')),
      );
    }
  } 

  @override
  Widget build(BuildContext context) {
    final List<EventDetails> eventsList = List.from(events.events)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // PageView lets you swipe (slide) between pages
    return Expanded(
      child: PageView.builder(
        itemCount: eventsList.length,
        itemBuilder: (context, index) {
          final event = eventsList[index];
          return Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                EventInfoTile(event: event),
                const SizedBox(height: 4),
                ActionButton(text: "Create Event", icon: Icons.arrow_forward, 
                              onPressed: _createEvent,
                              key: Key('create_event_button')),
                const SizedBox(height: 16),
                event.status == "PUBLISHED"
                    ? ActionButton(
                        key: const Key('event_details_button'),
                        text: 'Event Details',
                        icon: Icons.arrow_forward,
                        onPressed: () => _moreDetails(event),
                      )
                    : ActionButton(
                        key: const Key('publish_event_button'),
                        text: 'Publish',
                        icon: Icons.upload,
                        onPressed: () => _publish(event),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}