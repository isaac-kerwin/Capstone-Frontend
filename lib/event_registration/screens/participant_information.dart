import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/models/registration.dart';
import 'package:app_mobile_frontend/models/tickets.dart';
import 'package:app_mobile_frontend/network/event.dart';

class ParticipantInformationScreen extends StatefulWidget {
  final int eventId;
  final List<RegistrationTicketDTO> tickets; // Now takes DTOs
  final List<int> quantities;

  const ParticipantInformationScreen({
    Key? key,
    required this.eventId,
    required this.tickets,
    required this.quantities,
  }) : super(key: key);

  @override
  State<ParticipantInformationScreen> createState() => _ParticipantInformationScreenState();
}

class _ParticipantInformationScreenState extends State<ParticipantInformationScreen> {
  late final int totalParticipants;
  late final List<Map<String, String>> participantData;
  final _formKey = GlobalKey<FormState>();
  List<String> ticketNames = [];

  @override
  void initState() {
    super.initState();
    totalParticipants = widget.quantities.fold(0, (a, b) => a + b);
    participantData = List.generate(
      totalParticipants,
      (_) => {'firstname': '', 'lastname': '', 'email': '', 'phone': ''},
    );
    _fetchTicketNames();
  }

  Future<void> _fetchTicketNames() async { 
    List<String> names = [];
    for (var ticket in widget.tickets) {
      try {
        final Ticket ticketObj = await getTicketById(widget.eventId, ticket.ticketId);
        names.add(ticketObj.name);
      } catch (e) {
        names.add('Unknown');
      }
    }
    setState(() {
      ticketNames = names;
    });
  }

  String _getTicketNameForParticipant(int index) {
    int runningTotal = 0;
    for (int i = 0; i < widget.tickets.length; i++) {
      runningTotal += widget.tickets[i].quantity;
      if (index < runningTotal) {
        if (i < ticketNames.length) {
          return ticketNames[i];
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

  void _continue() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All participant information is valid!')),
      );
    }
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
                onPressed: _continue,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}