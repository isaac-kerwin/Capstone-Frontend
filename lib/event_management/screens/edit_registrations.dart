import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/network/event_registration.dart';
import 'package:app_mobile_frontend/network/event.dart';

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

  Widget _buildRegistrationTile(Map<String, dynamic> reg) {
    final registrationId = reg['registrationId'].toString();
    final primaryParticipantName = reg['primaryParticipantName'] ?? 'N/A';
    final numberOfAttendees = reg['numberOfAttendees']?.toString() ?? '1';
    final totalAmountPaid = reg['totalAmountPaid']?.toString() ?? '0';
    final status = reg['registrationStatus'] ?? 'UNKNOWN';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text('Registration #$registrationId'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Primary: $primaryParticipantName'),
            Text('Attendees: $numberOfAttendees'),
            Text('Total Paid: \$${totalAmountPaid}'),
            Text('Status: $status'),
          ],
        ),
        trailing: status == "PENDING"
            ? ElevatedButton(
                onPressed: () => _confirmRegistration(registrationId),
                child: const Text('Confirm'),
              )
            : null,
      ),
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
            itemBuilder: (context, index) =>
                _buildRegistrationTile(registrations[index] as Map<String, dynamic>),
          );
        },
      ),
    );
  }
}