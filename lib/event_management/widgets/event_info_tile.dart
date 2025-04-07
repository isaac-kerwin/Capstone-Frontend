import 'package:flutter/material.dart';
import 'package:first_app/models/event.dart';
import 'package:first_app/event_management/widgets/event_info_item.dart';
import 'package:first_app/event_management/services/date_and_time_parser.dart';
  
class EventInfoTile extends StatefulWidget {
  final EventDetails event;
  const EventInfoTile({super.key, required this.event});  
  @override
  State<EventInfoTile> createState() => _EventInfoTileState();
}  

class _EventInfoTileState extends State<EventInfoTile> {

  @override
  void initState() {
    super.initState();
    EventDetails event = widget.event;
  }
  
  Widget build(BuildContext context) {
    EventDetails event = widget.event;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              event.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              softWrap: true,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${event.registrationsCount} / ${event.capacity} Filled Capacity",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            EventInfoItem(
              icon: Icons.calendar_today,
              iconColor: Colors.blue,
              title: formatDateRangeAsWords(event.startDateTime, event.endDateTime),
              subtitle: "${formatTimeAmPm(event.startDateTime)} - ${formatTimeAmPm(event.endDateTime)}",
            ),
            const SizedBox(height: 16),
            EventInfoItem(
              icon: Icons.location_on,
              iconColor: Colors.blue,
              title: 'Royal Exhibition Building',

            ),
            const SizedBox(height: 32),
          ],
        ),
      );
  }
}