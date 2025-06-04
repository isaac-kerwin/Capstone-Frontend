import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/network/event_registration.dart';
import 'package:app_mobile_frontend/network/event.dart';
import 'package:app_mobile_frontend/features/event_management/widgets/registration_tile.dart';

class EditRegistrationsScreen extends StatefulWidget {
  final int eventId;

  const EditRegistrationsScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _EditRegistrationsScreenState createState() => _EditRegistrationsScreenState();
}

class _EditRegistrationsScreenState extends State<EditRegistrationsScreen> {
  late Future<List<dynamic>> registrationsFuture;
  bool showPendingOnly = false;

  @override
  void initState() {
    super.initState();
    registrationsFuture = getEventRegistrations(widget.eventId.toString(), showPendingOnly);
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
              );
            },
          );
        },
      ),
    );
  }
}