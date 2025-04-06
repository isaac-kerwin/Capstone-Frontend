import 'package:first_app/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/event.dart';
import 'package:first_app/screens/organiser_dashboard/create_event/screen1_details.dart';
import 'package:first_app/screens/organiser_dashboard/details_page.dart';
import 'package:first_app/widgets/event_info_tile.dart';


class EventSlideshow extends StatelessWidget {
  final Events events;
  final BuildContext context;


  const EventSlideshow({Key? key, required this.events,  required this.context}) : super(key: key);

  _createEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEventPage(),
      ),
    );
  }

  _moreDetails(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(),
      ),
    );  
  }
  @override
  Widget build(BuildContext context) {
    final List<EventDetails> eventsList = events.events;
    // PageView lets you swipe (slide) between pages
    return Expanded(
      child: PageView.builder(
        itemCount: eventsList.length,
        itemBuilder: (context, index) {
          final event = eventsList[index];
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EventInfoTile(event: event,),
                const SizedBox(height: 24),
                ActionButton(text: "Create Event", icon: Icons.arrow_forward, onPressed: _createEvent),
                const SizedBox(height: 16),
                ActionButton(text: "Event Details", icon: Icons.arrow_forward, onPressed: _moreDetails),
              ],
            ),
          );
        },
      ),
    );
  }
}