import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/api/event_registration_services.dart';
import 'package:app_mobile_frontend/api/event_services.dart';
import 'package:app_mobile_frontend/features/registration_management/widgets/registration_tile.dart';
import 'package:app_mobile_frontend/core/models/event.dart';
import 'package:app_mobile_frontend/api/email_services.dart';
import 'package:app_mobile_frontend/core/models/confirmation_email_dto.dart';

class EditRegistrationsScreen extends StatefulWidget {
  final int eventId;

  const EditRegistrationsScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _EditRegistrationsScreenState createState() => _EditRegistrationsScreenState();
}

class _EditRegistrationsScreenState extends State<EditRegistrationsScreen> {
  late Future<List<dynamic>> registrationsFuture;
  late Future<EventWithQuestions> eventFuture;
  bool showPendingOnly = false;

  @override
  void initState() {
    super.initState();
    registrationsFuture = getEventRegistrations(widget.eventId.toString(), showPendingOnly);
    eventFuture = getEventById(widget.eventId);
  }

  void _togglePendingOnly() {
    setState(() {
      showPendingOnly = !showPendingOnly;
      registrationsFuture = getEventRegistrations(widget.eventId.toString(), showPendingOnly);
    });
  }

  Future<void> _confirmRegistration(String registrationId) async {
    await updateRegistrationStatus(registrationId, "CONFIRMED");
    setState(() {
      registrationsFuture = getEventRegistrations(widget.eventId.toString(), showPendingOnly);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration confirmed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Registrations'),
        actions: [
          TextButton.icon(
            onPressed: _togglePendingOnly,
            icon: Icon(
              showPendingOnly ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            label: const Text(
              'Pending Only',
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: registrationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No registrations found.'));
          }
          final registrations = snapshot.data!;
          return FutureBuilder<EventWithQuestions>(
            future: eventFuture,
            builder: (context, eventSnap) {
              if (eventSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (eventSnap.hasError) {
                return Center(child: Text('Error loading event: ${eventSnap.error}'));
              }
              final event = eventSnap.data!;
              return ListView.builder(
                itemCount: registrations.length,
                itemBuilder: (context, index) {
                  final reg = registrations[index] as Map<String, dynamic>;
                  final id = reg['registrationId'].toString();
                  final attendees = (reg['numberOfAttendees'] as int?) ?? 1;
                  final paid = double.tryParse(reg['totalAmountPaid']?.toString() ?? '0') ?? 0;
                  final status = reg['registrationStatus'] ?? 'UNKNOWN';
                  return RegistrationTile(
                    registrationId: id,
                    primaryParticipantName: reg['primaryParticipantName'] ?? 'N/A',
                    numberOfAttendees: attendees,
                    totalAmountPaid: paid,
                    status: status,
                    onConfirm: status == 'PENDING' ? () => _confirmRegistration(id) : null,
                    onSendEmail: status == 'CONFIRMED'
                        ? () async {
                            try {
                              await sendConfirmationEmail(ConfirmationEmailDTO(
                                userEmail: reg['primaryParticipantEmail'],
                                registrationId: id,
                                eventName: event.name,
                                startDateTime: event.startDateTime,
                                endDateTime: event.endDateTime,
                                location: event.location,
                              ));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Confirmation email sent!')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to send email: $e')),
                              );
                            }
                          }
                        : null,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}