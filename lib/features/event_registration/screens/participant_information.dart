import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/features/event_registration/screens/new_registration_form_generator.dart';
import 'package:logging/logging.dart';

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
  /// Logger for debugging participant form state
  final Logger _logger = Logger('ParticipantInfo');
  // Controllers for participant fields to retain input
  late final List<Map<String, TextEditingController>> _controllers;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _logger.info('Initializing ParticipantInformationScreen');
    // Sum the 'quantity' field from each ticket map
    totalParticipants = widget.tickets.fold<int>(
      0,
      (sum, ticket) => sum + (ticket['quantity'] ?? 0),
    );
    _logger.info('Total participants: $totalParticipants');
    // Initialize controllers per participant
    _controllers = List.generate(totalParticipants, (_) => {
      'firstname': TextEditingController(),
      'lastname': TextEditingController(),
      'email': TextEditingController(),
      'phone': TextEditingController(),
    });
    // Attach listeners to log field changes
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].forEach((field, controller) {
        controller.addListener(() {
          _logger.fine('Participant $i $field changed to: ${controller.text}');
        });
      });
    }
  }
  
  @override
  void dispose() {
    for (var map in _controllers) {
      map.values.forEach((c) => c.dispose());
    }
    super.dispose();
  }

String _getTicketNameForParticipant(int index) {
  int runningTotal = 0;
  for (int i = 0; i < widget.tickets.length; i++) {
    final int quantity = widget.tickets[i]['quantity'] ?? 0;
    runningTotal += quantity;
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
      key: ValueKey('participant_form_$index'),
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
              key: ValueKey('firstname_field_$index'),
              controller: _controllers[index]['firstname'],
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: ValueKey('lastname_field_$index'),
              controller: _controllers[index]['lastname'],
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: ValueKey('email_field_$index'),
              controller: _controllers[index]['email'],
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) return 'Invalid email';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: ValueKey('phone_field_$index'),
              controller: _controllers[index]['phone'],
              decoration: const InputDecoration(labelText: 'Phone Number'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
                if (!phoneRegex.hasMatch(value)) return 'Invalid phone number';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _goToQuestionnairePage() {
    // Collect responses from controllers and log them
    final participantData = _controllers.map((map) {
      return {
        'firstname': map['firstname']!.text,
        'lastname': map['lastname']!.text,
        'email': map['email']!.text,
        'phone': map['phone']!.text,
      };
    }).toList();
    _logger.info('Collected participant data: $participantData');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationForm(
          eventId: widget.eventId,
          tickets: widget.tickets,
          ticketNames: widget.ticketNames,
          participantData: participantData,
        ),
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