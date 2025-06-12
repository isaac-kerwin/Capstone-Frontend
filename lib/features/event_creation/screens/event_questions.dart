import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/core/models/question_models.dart';
import 'package:app_mobile_frontend/features/event_creation/widgets/create_question.dart';
import 'package:app_mobile_frontend/core/models/event_models.dart';
import 'package:app_mobile_frontend/core/models/ticket_models.dart';
import 'package:app_mobile_frontend/api/event_services.dart';
import 'package:app_mobile_frontend/core/widgets/navbar.dart';
import 'package:app_mobile_frontend/core/widgets/action_button.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('EventQuestions');

class CreateEventQuestions extends StatefulWidget {
  final Map<String, dynamic> eventData;
  const CreateEventQuestions({
    super.key,
    required this.eventData,
  });

  @override
  State<CreateEventQuestions> createState() => _CreateEventQuestionsScreenState();
}

class _CreateEventQuestionsScreenState extends State<CreateEventQuestions> {
  @override
  void initState() {
    super.initState();
    // Ensure the key exists and is a List<CreateQuestionDTO>
    widget.eventData.putIfAbsent('questions', () => <CreateQuestionDTO>[]);
  }

  // Opens the pop-up dialog to create a new question.
  Future<void> _openCreateQuestionDialog() async {
    final CreateQuestionDTO? newQuestion = await showDialog<CreateQuestionDTO>(
      context: context,
      builder: (context) => CreateQuestionDialog(displayOrder: widget.eventData['questions'].length + 1),
    );
    if (newQuestion != null) {
      setState(() {
        widget.eventData["questions"].add(newQuestion);
      });
    }
  }

  _unpackAndCreateEvent(Map<String, dynamic> eventData) async {
    // Unpack the event data
    String name = eventData['eventName'];
    String description = eventData['description'];
    String location = eventData['location'];
    String type = eventData['type'];
    DateTime startDateTime = eventData['startDateTime'];
    DateTime endDateTime = eventData['endDateTime'];
    int capacity = eventData['capacity'];
    List<TicketDTO> tickets = eventData['tickets'];
    List<CreateQuestionDTO> questions = eventData['questions'];

    for (var question in questions) {
      _logger.fine(question.toJson().toString());
    }

    // Create the event object
    CreateEventDTO event = CreateEventDTO(
      name: name,
      description: description,
      location: location,
      eventType: type,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      capacity: capacity,
      tickets: tickets,
      questions: questions,
    );

    // Call the API to create the event
    _logger.fine(event.toJson().toString());
    await createEvent(event);
  }

  // Continue button action: check that at least one question is added and navigate.
  Future<void> _continue() async {
    if (widget.eventData["questions"].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question.')),
      );

      return;
    }

    await _unpackAndCreateEvent(widget.eventData);

    // Alternatively, if you want to remove all previous routes, use:
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MainScreen(
          initialIndex: 1, // Dashboard tab
        ),
      ),
      (_) => false,
    );
  }

  _buildQuestionList() {
    if (widget.eventData["questions"].isEmpty) {
      return const Center(child: Text('No questions added yet.'));
    }
    return ListView.builder(
      itemCount: widget.eventData["questions"].length,
      itemBuilder: (context, index) {
        final question = widget.eventData["questions"][index];
        return ListTile(
          title: Text(question.questionText),
          subtitle: Text(
              'Required: ${question.isRequired ? "Yes" : "No"}, Order: ${question.displayOrder}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Custom Questions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Button to add a new question.
            TextButton(
              onPressed: _openCreateQuestionDialog,
              child: const Text('Add Question'),
            ),
            const SizedBox(height: 16),
            // Display list of added questions.
            Expanded(child: _buildQuestionList()),
            const SizedBox(height: 16),
            // Continue button.
            ActionButton(
              onPressed: _continue,
              text: 'Create Event',
              icon: Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }
}