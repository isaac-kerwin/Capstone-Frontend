import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/models/event.dart';
import 'package:app_mobile_frontend/network/event_registration.dart';
import 'package:app_mobile_frontend/models/registration.dart';
import 'package:app_mobile_frontend/models/email.dart';
import 'package:app_mobile_frontend/network/email.dart';
import 'package:app_mobile_frontend/main_screen.dart';
import 'package:logging/logging.dart';

class RegistrationSummaryScreen extends StatefulWidget {
  final int eventId;
  final List<Map<String, String>> participantData;
  final List<Map<String, int>> tickets;
  final List<String> ticketNames;
  final List<Map<String, dynamic>> answers;
  final EventWithQuestions event;

  const RegistrationSummaryScreen({
    Key? key,
    required this.eventId,
    required this.participantData,
    required this.tickets,
    required this.ticketNames,
    required this.answers,
    required this.event,
  }) : super(key: key);

  @override
  State<RegistrationSummaryScreen> createState() => _RegistrationSummaryScreenState();
}

class _RegistrationSummaryScreenState extends State<RegistrationSummaryScreen> {
  final Logger _logger = Logger('RegistrationSummary');
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _logger.info('RegistrationSummaryScreen initialized for eventId: ${widget.eventId}');
    _logger.fine('Participant data: ${widget.participantData}');
    _logger.fine('Answers: ${widget.answers}');
  }

  int _parseQuantity(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> _buildRegistrationPayload() {
    _logger.info('Building registration payload');
    final ticketsPayload = <Map<String, dynamic>>[];
    final participantsPayload = <Map<String, dynamic>>[];

    // Build a map from question text to question id for this event
    final Map<String, dynamic> questionTextToId = {
      for (final q in widget.event.questions)
        q.question.questionText: q.question.id
    };

    for (var tIndex = 0; tIndex < widget.tickets.length; tIndex++) {
      final ticket = widget.tickets[tIndex];
      final qty = _parseQuantity(ticket['quantity']);
      _logger.fine('Ticket payload - id: ${ticket['ticketId']}, quantity: $qty');
      ticketsPayload.add({
        'ticketId': ticket['ticketId'],
        'quantity': qty,
      });

      for (var copy = 0; copy < qty; copy++) {
        final responses = <Map<String, dynamic>>[];
        if (widget.answers.length > participantsPayload.length) {
          final answerMap = widget.answers[participantsPayload.length];
          for (final entry in answerMap.entries) {
            final questionId = questionTextToId[entry.key];
            if (questionId != null) {
              responses.add({
                'eventQuestionId': questionId,
                'responseText': entry.value,
              });
            }
          }
        }
        final pData = widget.participantData[participantsPayload.length];
        participantsPayload.add({
          'email': pData['email'] ?? '',
          'firstName': pData['firstname'] ?? '',
          'lastName': pData['lastname'] ?? '',
          'phoneNumber': pData['phone'] ?? '',
          'responses': responses,
        });
      }
    }

    final payload = {
      'eventId': widget.eventId,
      'tickets': ticketsPayload,
      'participants': participantsPayload,
    };
    _logger.fine('Registration payload: $payload');
    return {
      'eventId': widget.eventId,
      'tickets': ticketsPayload,
      'participants': participantsPayload,
    };
  }

  Future<void> _submitRegistration() async {
    _logger.info('Submitting registration');
    setState(() => _isSubmitting = true);
    try {
      final payload = _buildRegistrationPayload();
      final dto = EventRegistrationDTO(
        eventId: payload['eventId'],
        tickets: payload['tickets'],
        participants: payload['participants'],
      );
      _logger.fine('Calling createRegistration API');
      final regId = await createRegistration(dto);
      _logger.info('Registration created with ID: $regId');
      if (regId != null) {
        final first = widget.participantData.first;
        final emailDto = EmailDTO(
          email: first['email'] ?? '',
          registrationID: regId,
          eventName: widget.event.name,
          startDateTime: widget.event.startDateTime,
          endDateTime: widget.event.endDateTime,
          location: widget.event.location,
          type: 'confirmation',
        );
        _logger.fine('Sending confirmation email');
        await sendRegistrationEmail(emailDto);
        _logger.info('Confirmation email sent to ${emailDto.email}');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration submitted!')),
      );
      _logger.info('Navigating to MainScreen');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (r) => false,
      );
    } catch (e, stack) {
      _logger.severe('Error during submission: $e', e, stack);
      debugPrint('Error during submission: $e');
      debugPrintStack(stackTrace: stack);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      _logger.info('Submission complete, resetting submitting state');
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Building RegistrationSummary UI');
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Participants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...widget.participantData.asMap().entries.map((entry) {
              final idx = entry.key;
              final data = entry.value;
              _logger.fine('Displaying participant #${idx+1}: $data');
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('${data['firstname']} ${data['lastname']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${data['email']}'),
                      Text('Phone: ${data['phone']}'),
                      if (idx < widget.ticketNames.length) Text('Ticket: ${widget.ticketNames[idx]}'),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            const Text('Answers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...widget.answers.asMap().entries.map((entry) {
              final idx = entry.key;
              final answer = entry.value;
              _logger.fine('Displaying answers for participant #${idx+1}: $answer');
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('Participant #${idx + 1}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: answer.entries.map((e) {
                      // Format JSON-like lists into comma-separated text
                      var resp = e.value.toString();
                      if (resp.startsWith('[') && resp.endsWith(']')) {
                        resp = resp.substring(1, resp.length - 1).replaceAll('"', '');
                      }
                      return Text('${e.key}: $resp');
                    }).toList(),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : () {
                  _submitRegistration();
                },
                child: _isSubmitting
                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : const Text('Create Registration'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}