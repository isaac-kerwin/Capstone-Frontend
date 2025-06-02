import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/models/event.dart';

class EventItem extends StatelessWidget {
  final EventDetails event;
  final VoidCallback onTap;
  final bool usePurpleIcon;

  const EventItem({Key? key, required this.event, required this.onTap, this.usePurpleIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = event.startDateTime;
    String month = _getMonthAbbreviation(date.month);
    String day = date.day.toString();
    final int colorIndex = event.id.hashCode % _getCardColors().length;
    final Color backgroundColor = _getCardColors()[colorIndex];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(day, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(month, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              event.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '${event.capacity} Going',
              style: TextStyle(fontSize: 12, color: Colors.grey[800]),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getCardColors() => [
        const Color(0xFFFFC371),
        const Color(0xFFFF9A8B),
        const Color(0xFF90CAF9),
        const Color(0xFFA5D6A7),
        const Color(0xFFB39DDB),
      ];

  String _getMonthAbbreviation(int month) {
    const months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
    return months[month - 1];
  }
}
