import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/core/fundamental_widgets/action_button.dart';
import 'package:app_mobile_frontend/models/event.dart';
import 'package:app_mobile_frontend/features/event_registration/screens/ticket_select.dart'; // Import the correct TicketSelectPage
import 'package:app_mobile_frontend/network/event.dart';

class EventDetailsPage extends StatelessWidget {
  final int eventId;
  const EventDetailsPage({required this.eventId, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EventWithQuestions>(
      future: getEventById(eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: \\${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Event not found.')),
          );
        }
        final event = snapshot.data!;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: AppBar(
              toolbarHeight: 40,
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: false,
              titleSpacing: 0,
              leadingWidth: 40,
              leading: IconButton(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black87),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full-width yellow banner (placeholder for event image)
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.amber[200],
                    // If you add an image field to EventDetails, replace this with:
                    // child: event.imageUrl != null && event.imageUrl.isNotEmpty
                    //     ? Image.network(event.imageUrl, fit: BoxFit.cover)
                    //     : null,
                  ),
                  const SizedBox(height: 16),
                  // Event title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Going count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      '${event.registrationsCount} / ${event.capacity} going',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  // Date and time
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatEventDateTime(event),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Location
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.location,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // About Event
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'About Event',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      event.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // Read More link (shows tickets)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: _TicketsReadMoreSection(event: event),
                  ),
                  const SizedBox(height: 24),
                  // Buy Ticket Button using ActionButton
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: ActionButton(
                      text: 'REGISTER FOR EVENT',
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketSelectPage(eventId: event.id),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String _formatEventDateTime(EventWithQuestions event) {
  final s = event.startDateTime;
  final e = event.endDateTime;
  return '${s.day}/${s.month}/${s.year} ${_formatTime(s)} - ${e.day}/${e.month}/${e.year} ${_formatTime(e)}';
}

String _formatTime(DateTime dt) {
  final hour = dt.hour.toString().padLeft(2, '0');
  final min = dt.minute.toString().padLeft(2, '0');
  return '$hour:$min';
}

class _TicketsReadMoreSection extends StatefulWidget {
  final EventWithQuestions event;
  const _TicketsReadMoreSection({required this.event});

  @override
  State<_TicketsReadMoreSection> createState() => _TicketsReadMoreSectionState();
}

class _TicketsReadMoreSectionState extends State<_TicketsReadMoreSection> {
  bool showTickets = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              showTickets = !showTickets;
            });
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          child: Text(showTickets ? 'Hide Tickets' : 'View Tickets'),
        ),
        if (showTickets)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Tickets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ...widget.event.tickets.map((ticket) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  '${ticket.name} : ${ticket.price}',
                  style: const TextStyle(fontSize: 14),
                ),
              )),
            ],
          ),
      ],
    );
  }
}