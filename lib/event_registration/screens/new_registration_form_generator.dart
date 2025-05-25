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
  const RegistrationForm({
    Key? key,
    required this.eventId,
    required this.tickets,
    required this.ticketNames,
    required this.participantData,
  }) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  late Future<EventWithQuestions> eventFuture;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  final Map<int, TextEditingController> controllers = {};
  final Map<int, Set<int>> checkboxSelections = {};
  final Map<int, int?> dropdownSelections = {};

  @override
  void initState() {
    super.initState();
    eventFuture = getEventById(widget.eventId);
  }

  @override
  void dispose() {
    controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  int _parseQuantity(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> _buildRegistrationPayload(EventWithQuestions event) {
    final ticketsPayload = <Map<String, dynamic>>[];
    final participantsPayload = <Map<String, dynamic>>[];
    final questionCount = event.questions.length;

    for (var tIndex = 0; tIndex < widget.tickets.length; tIndex++) {
      final ticket = widget.tickets[tIndex];
      final qty = _parseQuantity(ticket['quantity']);
      ticketsPayload.add({
        'ticketId': ticket['ticketId'],
        'quantity': qty,
      });

      for (var copy = 0; copy < qty; copy++) {
        final responses = <Map<String, dynamic>>[];
        for (var qIndex = 0; qIndex < questionCount; qIndex++) {
          final composite = tIndex * 1000 + copy * questionCount + qIndex;
          final question = event.questions[qIndex];
          String text = controllers[composite]?.text.trim() ?? '';
          if (text.isEmpty) continue;

          final qType = question.question.questionType.toLowerCase();
          if (qType == 'dropdown') {
            final sel = dropdownSelections[composite];
            final opt = question.question.options?.firstWhere(
              (o) => o.id == sel,
            );
            text = opt?.optionText ?? text;
          }
          if (qType == 'checkbox') {
            final selSet = checkboxSelections[composite] ?? <int>{};
            final texts = question.question.options
                    ?.where((o) => selSet.contains(o.id))
                    .map((o) => o.optionText)
                    .toList() ?? [];
            text = texts.join(', ');
          }

          responses.add({
            'eventQuestionId': question.question.id,
            'responseText': text,
          });
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

    return {
      'eventId': event.id,
      'tickets': ticketsPayload,
      'participants': participantsPayload,
    };
  }

  void _submitForm(int eventId, List<Map<String, int>> tickets, List<Map<String, String>> pdata, EventWithQuestions event) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final payload = _buildRegistrationPayload(event);
      final dto = EventRegistrationDTO(
        eventId: payload['eventId'],
        tickets: payload['tickets'],
        participants: payload['participants'],
      );
      print('Payload: \${dto.toJson()}');

      final regId = await createRegistration(dto);
      if (regId != null) {
        final first = pdata.first;
        final emailDto = EmailDTO(
          email: first['email'] ?? '',
          registrationID: regId,
          eventName: event.name ?? '',
          startDateTime: event.startDateTime ?? DateTime.now(),
          endDateTime: event.endDateTime ?? DateTime.now(),
          location: event.location ?? '',
          type: 'confirmation',
        );
        sendRegistrationEmail(emailDto);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration submitted!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (r) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
    } finally {
      setState(() => _isSubmitting = false);
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

            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0), // Add space between each participant's section
              child: Column(
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

                    // For checkboxes, store selections as a Set<int> in controllers
                    if (question.question.questionType.toLowerCase() == 'checkbox') {
                      controllers.putIfAbsent(controllerIndex, () => TextEditingController());
                      final options = question.question.options ?? [];
                      Set<int> selectedOptions = {};
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0), // Space after each checkbox group
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(question.question.questionText, style: const TextStyle(fontWeight: FontWeight.w500)),
                            ...options.map((opt) {
                              final isChecked = selectedOptions.contains(opt.id);
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return CheckboxListTile(
                                    title: Text(opt.optionText),
                                    value: isChecked,
                                    onChanged: (checked) {
                                      setState(() {
                                        if (checked == true) {
                                          selectedOptions.add(opt.id);
                                        } else {
                                          selectedOptions.remove(opt.id);
                                        }
                                        controllers[controllerIndex]?.text = selectedOptions.join(',');
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,
                                  );
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }

                    // For dropdowns
                    if (question.question.questionType.toLowerCase() == 'dropdown') {
                      controllers.putIfAbsent(controllerIndex, () => TextEditingController());
                      final options = question.question.options ?? [];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0), // Space after each dropdown
                        child: DropdownButtonFormField<int>(
                          value: controllers[controllerIndex]?.text.isNotEmpty == true
                              ? int.tryParse(controllers[controllerIndex]!.text)
                              : null,
                          decoration: InputDecoration(
                            labelText: question.question.questionText,
                            border: const OutlineInputBorder(),
                          ),
                          items: options
                              .map((opt) => DropdownMenuItem<int>(
                                    value: opt.id,
                                    child: Text(opt.optionText),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            controllers[controllerIndex]?.text = value?.toString() ?? '';
                          },
                          validator: (value) {
                            if (question.isRequired && (value == null || value.toString().isEmpty)) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                      );
                    }

                    // Default: Text input
                    controllers.putIfAbsent(controllerIndex, () => TextEditingController());
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0), // Space after each text field
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
              ),
            );
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register for Event')),
      body: FutureBuilder<EventWithQuestions>(
        future: eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));  
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No event data found.'));
          }
          final event = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuestionFields(event),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => _submitForm(
                                widget.eventId,
                                widget.tickets,
                                widget.participantData,
                                event,
                              ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                          : const Text('Complete Registration'),
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
