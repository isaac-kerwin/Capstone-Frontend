import 'package:flutter/material.dart';
import 'package:first_app/models/question.dart';
import 'package:first_app/widgets/create_question.dart';
import 'package:first_app/models/event.dart';
import 'package:first_app/models/tickets.dart';
import 'package:first_app/network/event.dart';
import 'package:first_app/screens/organiser_dashboard/organiser_dashboard_home.dart';
import 'package:first_app/widgets/action_button.dart';

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
  // List to store added questions.
  List< CreateQuestionDTO> questions = [];

  // Opens the pop-up dialog to create a new question.
  Future<void> _openCreateQuestionDialog() async {
    final  CreateQuestionDTO? newQuestion = await showDialog< CreateQuestionDTO>(
      context: context,
      builder: (context) => const CreateQuestionDialog(),
    );
    if (newQuestion != null) {
      setState(() {
        questions.add(newQuestion);
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

    // Create the event object
    CreateEventDTO event = CreateEventDTO(
      name : name,
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
    await createEvent(event);
  }

  // Continue button action: check that at least one question is added and navigate.
  Future<void> _continue() async {
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question.')),
      );

      return;
    }
    widget.eventData['questions'] = questions;
    await _unpackAndCreateEvent(widget.eventData);
    
        // Alternatively, if you want to remove all previous routes, use:
     Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const OrganiserDashboard()),
      (Route<dynamic> route) => false,
    );
  
  }

  _buildQuestionList() {
    if (questions.isEmpty) {
      return const Center(child: Text('No questions added yet.'));
    }
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
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
        title: const Text('Question Management'),
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
