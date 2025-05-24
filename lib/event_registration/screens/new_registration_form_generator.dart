import 'package:app_mobile_frontend/models/registration.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/models/event.dart';
import 'package:app_mobile_frontend/network/event.dart';
import 'package:app_mobile_frontend/main_screen.dart';
import 'package:app_mobile_frontend/network/event_registration.dart';
import 'package:app_mobile_frontend/models/email.dart';
import 'package:app_mobile_frontend/network/email.dart';



class RegistrationForm extends StatefulWidget {
  final int eventId;
  final List<String> ticketNames;
  final List<Map<String, int>> tickets;
  final List<Map<String, String>> participantData;
  // final List<Map<String, dynamic>> questions;
  const RegistrationForm({Key? key, 
  required this.eventId,
  required this.tickets,
  required this.ticketNames,
  required this.participantData
  }) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  late Future<EventWithQuestions> eventFuture;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  final Map<int, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    eventFuture = getEventById(widget.eventId);
  }

  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  /// Parses the quantity value safely from dynamic input.
  int _parseQuantity(dynamic quantityValue) {
    if (quantityValue is int) return quantityValue;
    if (quantityValue is String) return int.tryParse(quantityValue) ?? 0;
    return 0;
  }

  /// Generates a unique index for mapping controllers to ticket/person/question.
  int _generateControllerIndex(int ticketIndex, int copyIndex, int questionIndex, int questionCount) {
    return (ticketIndex * 1000) + (copyIndex * questionCount) + questionIndex;
  }

  Map<String, dynamic> _buildRegistrationPayload(EventWithQuestions event) {
  final List<Map<String, dynamic>> ticketSelections = [];
  final List<Map<String, dynamic>> participants = [];

  for (int ticketIndex = 0; ticketIndex < widget.tickets.length; ticketIndex++) {
    final ticket = widget.tickets[ticketIndex];
    final ticketId = ticket['ticketId'];
    final int quantity = _parseQuantity(ticket['quantity']);

    ticketSelections.add({
      'ticketId': ticketId,
      'quantity': quantity,
    });

    for (int copyIndex = 0; copyIndex < quantity; copyIndex++) {
      int participantIndex = participants.length;
      final participantResponses = <Map<String, dynamic>>[];
      _setParticipantResponses(event, participantIndex, ticketIndex, copyIndex, participants, participantResponses);

      // Replace these with actual form inputs if needed
      final email = widget.participantData[participantIndex]['email'] ?? '';
      final firstName = widget.participantData[participantIndex]['firstname'] ?? '';
      final lastName = widget.participantData[participantIndex]['lastname'] ?? '';
      final phoneNumber = widget.participantData[participantIndex]['phone'] ?? '';

      participants.add({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'responses': participantResponses,
      });
    }
  }
  
  return {
    'eventId': event.id,
    'tickets': ticketSelections,
    'participants': participants,
  };
}

_setParticipantResponses(event, participantIndex, ticketIndex, copyIndex, participants, participantResponses) {  
  for (int questionIndex = 0; questionIndex < event.questions.length; questionIndex++) {
    int controllerIndex = _generateControllerIndex(ticketIndex, copyIndex, questionIndex, event.questions.length);
    final controller = controllers[controllerIndex];
    final question = event.questions[questionIndex];

    final text = controller?.text.trim();
    if (text == null || text.isEmpty) continue;

    participantResponses.add({
      'eventQuestionId': question.question.id,
      'responseText': text,
    });
  }
  return participantResponses;
}

void _submitForm(eventId, tickets, participantData, responses, event) async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final registrationPayload = _buildRegistrationPayload(event);
      EventRegistrationDTO registrationDTO = EventRegistrationDTO(
        eventId: eventId,
        tickets: tickets,
        participants: registrationPayload['participants'],
      );

      // Send registration to backend and get registrationId
      final registrationId = await createRegistration(registrationDTO);

      if (registrationId != null) {
        // Build and send email for the first participant (or loop for all if needed)
        final participant = participantData.isNotEmpty ? participantData[0] : {};
        final email = participant['email'] ?? '';
        final eventName = event.name ?? '';
        final startDateTime = event.startDateTime ?? DateTime.now();
        final endDateTime = event.endDateTime ?? DateTime.now();
        final location = event.location ?? '';
        final type = 'confirmation';
        

        final emailDTO = EmailDTO(
          email: email,
          registrationID: registrationId,
          eventName: eventName,
          startDateTime: startDateTime,
          endDateTime: endDateTime,
          location: location,
          type: type,
        );
        print(emailDTO.toJson());

        await sendRegistrationEmail(emailDTO);
      }

      // Navigate or show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration submitted!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      debugPrint('Submission error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}

Widget _buildQuestionFields(EventWithQuestions event) {
  int questionCount = event.questions.length;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(widget.tickets.length, (ticketIndex) {
      final ticket = widget.tickets[ticketIndex];
      final ticketName = widget.ticketNames[ticketIndex];
      final quantity = widget.tickets.fold<int>(
        0,
        (sum, ticket) {
          final int q = ticket['quantity']!;
          if (q is int) return sum + q;
          if (q is String) return sum + q ?? 0;
          return sum;
        },
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(quantity, (copyIndex) {
          int ticketNumber = ticketIndex + 1;
          int personNumber = copyIndex + 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                '$ticketName Ticket #$personNumber',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...List.generate(questionCount, (questionIndex) {
                int controllerIndex = (ticketIndex * 1000) + (copyIndex * questionCount) + questionIndex;
                final question = event.questions[questionIndex];

                controllers.putIfAbsent(controllerIndex, () => TextEditingController());

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controllers[controllerIndex],
                    decoration: InputDecoration(
                      labelText: question.question.questionText,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (question.isRequired && (value == null || value.isEmpty)) {
                        return 'This field is required';
                      }
                      return null;
                      },
                    ),
                  );
                }),
              ],
            );
          }),
        );
      }),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register for Event'),
      ),
      body: FutureBuilder<EventWithQuestions>(
        future: eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No event data found.'));
          }

          final event = snapshot.data!;
          // Initialize controllers for each question if not already done
          for (int i = 0; i < event.questions.length; i++) {
            controllers.putIfAbsent(i, () => TextEditingController());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuestionFields(event),
                  const SizedBox(height: 20),
                  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : () async {
                        if (_formKey.currentState?.validate() != true) return;

                        final registrationPayload = _buildRegistrationPayload(event);
                        _submitForm(
                          widget.eventId,
                          widget.tickets,
                          widget.participantData,
                          event.questions,
                          event,
                        );
                        // TODO: send `registrationPayload` to backend
                      },      

                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Complete Registration'),
                  ),
                  ),
                ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

 