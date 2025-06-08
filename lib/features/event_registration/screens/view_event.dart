import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/core/widgets/action_button.dart';
import 'package:app_mobile_frontend/core/models/event.dart';
import 'package:app_mobile_frontend/features/event_registration/screens/ticket_select.dart';
import 'package:app_mobile_frontend/api/event_services.dart';
import 'package:app_mobile_frontend/features/event_management/services/date_and_time_parser.dart';

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
            appBar: _buildSmallAppBar(context),
            body: Center(child: Text('Error: \\${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Event not found.')),
          );
        }

        final event = snapshot.data!;
        return Scaffold(
          appBar: _buildSmallAppBar(context),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1) Full‐width yellow banner
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.amber[200],
                  ),

                  // 2) Gap between banner and title
                  const SizedBox(height: 16),

                  // 3) Event title (“Melbourne Italian Festa 2024”)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 24,          // slightly larger than before
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // 4) Very small gap between title and “Spots Filled”
                  const SizedBox(height: 4),

                  // 5) Spots Filled (e.g. “40/100 Spots Filled”)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${event.registrationsCount}/${event.capacity} Spots Filled',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // 6) Gap before date row
                  const SizedBox(height: 12),

                  // 7) Date + Time row (two lines)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Use shared parser for date range and times
                            Text(
                              formatDateRangeAsWords(event.startDateTime, event.endDateTime),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${formatTimeAmPm(event.startDateTime)} – ${formatTimeAmPm(event.endDateTime)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 8) Gap between date and location
                  const SizedBox(height: 12),

                  // 9) Location row (two lines: name + address)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Venue name (bold-ish)
                              Text(
                                event.location,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 10) Gap before “About Event” heading
                  const SizedBox(height: 16),

                  // 11) “About Event” heading
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'About Event',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // 12) Tiny gap between heading and body text
                  const SizedBox(height: 4),

                  // 13) Event description/body
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // 14) Gap before “View Tickets”
                  const SizedBox(height: 12),

                  // 15) View Tickets (collapse/expand)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _TicketsReadMoreSection(event: event),
                  ),

                  // 16) Gap before Register button
                  const SizedBox(height: 16),

                  // 17) REGISTER FOR EVENT button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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

                  // 18) Extra bottom padding so content doesn’t feel “stuck”
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// A slim AppBar (40px tall) with only a back arrow.
  PreferredSizeWidget _buildSmallAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 40,
        leading: IconButton(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
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
          onPressed: () => setState(() => showTickets = !showTickets),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          child: Text(
            showTickets ? 'Hide Tickets' : 'View Tickets',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ),
        if (showTickets) ...[
          const SizedBox(height: 8),
          const Text(
            'Tickets',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ...widget.event.tickets.map(
            (ticket) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                '${ticket.name} : \$${ticket.price}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
