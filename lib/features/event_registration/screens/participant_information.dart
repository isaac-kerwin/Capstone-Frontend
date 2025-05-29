import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/features/event_registration/screens/new_registration_form_generator.dart';

class ParticipantInformationScreen extends StatefulWidget {
  final int eventId;
  final List<Map<String, int>>  tickets; 
  final List<String> ticketNames;
  final List<dynamic> questions;

  const ParticipantInformationScreen({
    Key? key,
    required this.eventId,
    required this.tickets,
    required this.ticketNames,
    required this.questions,
  }) : super(key: key);

  @override
  State<ParticipantInformationScreen> createState() => _ParticipantInformationScreenState();
}

class _ParticipantInformationScreenState extends State<ParticipantInformationScreen> {
  late final int totalParticipants;
  late final List<Map<String, String>> participantData;
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> participantResponses = [];

  @override
  void initState() {
    super.initState();
    // Sum the 'quantity' field from each ticket map
    totalParticipants = widget.tickets.fold<int>(
      0,
      (sum, ticket) {
        final int q = ticket['quantity']!;
        if (q is int) return sum + q;
        if (q is String) return sum + q ?? 0;
        return sum;
      },
    );
    participantData = List.generate(
      totalParticipants,
      (_) => {'firstname': '', 'lastname': '', 'email': '', 'phone': ''},
    );
    participantResponses = List.generate(totalParticipants, (_) => {});
  }

String _getTicketNameForParticipant(int index) {
  int runningTotal = 0;
  for (int i = 0; i < widget.tickets.length; i++) {
    final quantity = widget.tickets[i]['quantity'] ?? 0;
    runningTotal += quantity is int ? quantity : int.tryParse(quantity.toString()) ?? 0;
    if (index < runningTotal) {
      // Defensive: ticketNames and tickets should be in the same order
      if (i < widget.ticketNames.length) {
        return widget.ticketNames[i];
      } else {
        return '';
      }
    }
  }
  return '';
}

  Widget _buildParticipantForm(int index) {
    final ticketName = _getTicketNameForParticipant(index);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticketName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'First Name'),
              initialValue: participantData[index]['firstname'],
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              onChanged: (value) => participantData[index]['firstname'] = value,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Last Name'),
              initialValue: participantData[index]['lastname'],
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              onChanged: (value) => participantData[index]['lastname'] = value,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              initialValue: participantData[index]['email'],
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) return 'Invalid email';
                return null;
              },
              onChanged: (value) => participantData[index]['email'] = value,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
              initialValue: participantData[index]['phone'],
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
                if (!phoneRegex.hasMatch(value)) return 'Invalid phone number';
                return null;
              },
              onChanged: (value) => participantData[index]['phone'] = value,
            ),
          ],
        ),
      ),
    );
  }

  void _goToQuestionnairePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationForm(eventId: widget.eventId, tickets: widget.tickets, ticketNames: widget.ticketNames, participantData: participantData,),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Participant Information')),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            ...List.generate(totalParticipants, _buildParticipantForm),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _goToQuestionnairePage();
                  }
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}