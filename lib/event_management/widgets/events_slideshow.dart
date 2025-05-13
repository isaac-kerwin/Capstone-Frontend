import 'package:first_app/fundamental_widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/event.dart';
import 'package:first_app/event_creation/screens/event_details.dart';
import 'package:first_app/event_management/screens/details_page.dart';
import 'package:first_app/event_management/widgets/event_info_tile.dart';


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
                ActionButton(text: "Event Details", 
                            icon: Icons.arrow_forward, 
                            onPressed: () => _moreDetails(event), 
                            key: Key('event_details_button')),
              ],
            ),
          );
        },
      ),
    );
  }
}