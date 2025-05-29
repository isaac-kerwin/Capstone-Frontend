import 'package:app_mobile_frontend/models/registration.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/models/event.dart';
import 'package:app_mobile_frontend/network/event.dart';
import 'package:app_mobile_frontend/features/event_registration/screens/registration_summary.dart';

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

  /// Collects all answers for each participant in a list of maps.
  List<Map<String, dynamic>> _collectAnswers(EventWithQuestions event) {
    final answers = <Map<String, dynamic>>[];
    final questionCount = event.questions.length;

    for (var tIndex = 0; tIndex < widget.tickets.length; tIndex++) {
      final ticket = widget.tickets[tIndex];
      final qty = _parseQuantity(ticket['quantity']);

      for (var copy = 0; copy < qty; copy++) {
        final answerMap = <String, dynamic>{};
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

          answerMap[question.question.questionText] = text;
        }
        answers.add(answerMap);
      }
    }
    return answers;
  }

  Widget _buildQuestionFields(EventWithQuestions event) {
    final questionCount = event.questions.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.tickets.length, (ticketIndex) {
        final ticket = widget.tickets[ticketIndex];
        final ticketName = widget.ticketNames[ticketIndex];
        final quantity = _parseQuantity(ticket['quantity']);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(quantity, (copyIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$ticketName Ticket #${copyIndex + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(questionCount, (questionIndex) {
                    final composite = ticketIndex * 1000 + copyIndex * questionCount + questionIndex;
                    final question = event.questions[questionIndex];
                    final qText = question.question.questionText;
                    final qType = question.question.questionType.toLowerCase();

                    controllers.putIfAbsent(composite, () => TextEditingController());
                    if (qType == 'checkbox') {
                      checkboxSelections.putIfAbsent(composite, () => <int>{});
                      final opts = question.question.options ?? [];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(qText, style: const TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            ...opts.map((opt) {
                              final checked = checkboxSelections[composite]!.contains(opt.id);
                              return CheckboxListTile(
                                title: Text(opt.optionText),
                                value: checked,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      checkboxSelections[composite]!.add(opt.id);
                                    } else {
                                      checkboxSelections[composite]!.remove(opt.id);
                                    }
                                    controllers[composite]!.text = checkboxSelections[composite]!.join(',');
                                  });
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    } else if (qType == 'dropdown') {
                      dropdownSelections.putIfAbsent(composite, () => null);
                      final opts = question.question.options ?? [];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: DropdownButtonFormField<int>(
                          value: dropdownSelections[composite],
                          decoration: InputDecoration(
                            labelText: qText,
                            border: const OutlineInputBorder(),
                          ),
                          items: opts
                              .map((opt) => DropdownMenuItem<int>(
                                    value: opt.id,
                                    child: Text(opt.optionText),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              dropdownSelections[composite] = val;
                              controllers[composite]!.text = val?.toString() ?? '';
                            });
                          },
                          validator: (val) => question.isRequired && (val == null) ? 'This field is required' : null,
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          controller: controllers[composite],
                          decoration: InputDecoration(
                            labelText: qText,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (val) => question.isRequired && (val == null || val.isEmpty) ? 'This field is required' : null,
                        ),
                      );
                    }
                  }),
                ],
              ),
            );
          }),
        );
      }),
    );
  }

  void _goToSummary(EventWithQuestions event) {
    if (!_formKey.currentState!.validate()) return;
    final answers = _collectAnswers(event);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationSummaryScreen(
          eventId: widget.eventId,
          participantData: widget.participantData,
          tickets: widget.tickets,
          ticketNames: widget.ticketNames,
          answers: answers,
          event: event,
        ),
      ),
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
            return Center(child: Text('Error: ${snapshot.error}'));
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => _goToSummary(event),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                          : const Text('Review Registration'),
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
