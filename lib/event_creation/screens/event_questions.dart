import 'package:flutter/material.dart';
import 'package:first_app/models/question.dart';
import 'package:first_app/event_creation/widgets/create_question.dart';
import 'package:first_app/models/event.dart';
import 'package:first_app/models/tickets.dart';
import 'package:first_app/network/event.dart';
import 'package:first_app/event_management/screens/organiser_dashboard_home.dart';
import 'package:first_app/fundamental_widgets/action_button.dart';
import 'package:dio/dio.dart';
import 'package:first_app/network/dio_client.dart';
import 'package:first_app/network/auth.dart';
import 'package:first_app/network/users.dart';


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
  
  // Opens the pop-up dialog to create a new question.
  Future<void> _openCreateQuestionDialog() async {
    final  CreateQuestionDTO? newQuestion = await showDialog< CreateQuestionDTO>(
      context: context,
      builder: (context) => const CreateQuestionDialog(),
    );
    if (newQuestion != null) {
      setState(() {
        widget.eventData["questions"] ??= [];
        widget.eventData["questions"].add(newQuestion);
      });
    }
  }

  Future<void> _continue() async {
    print('Create Event button pressed');
    if ((widget.eventData["questions"] ?? []).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question.')),
      );
      return;
    }
    try {
      bool success = await _unpackAndCreateEvent(widget.eventData);
      if (success) {
        print('Event created successfully, navigating...');
        // Fetch the current user's profile to get the correct organiserId
        final profile = await getUserProfile();
        final organiserId = profile?.id ?? 1;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OrganiserDashboard(organiserId: organiserId)),
          (Route<dynamic> route) => false,
        );
      } else {
        print('Event creation failed, not navigating.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create event.')),
        );
      }
    } catch (e, stack) {
      print('Error in _continue: $e');
      print(stack);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create event: $e')),
      );
    }
  }

  Future<bool> _unpackAndCreateEvent(Map<String, dynamic> eventData) async {
    try {
      print('Unpacking event data...');
      // Unpack the event data
      String name = eventData['eventName'];
      String description = eventData['description'];
      String location = eventData['location'];
      String type = eventData['type'];
      DateTime startDateTime = eventData['startDateTime'];
      DateTime endDateTime = eventData['endDateTime'];
      int capacity = eventData['capacity'];
      List<TicketDTO> tickets = eventData['tickets'];
      List<CreateQuestionDTO> questions = List<CreateQuestionDTO>.from(eventData['questions']);

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

      print('Calling createEvent API...');
      // Call the API to create the event
      final response = await dioClient.dio.post(
        "/events",
        data: event.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      print('createEvent API call finished');
      if (response.data["success"]) {
        print("Event created successfully: \\${response.data}");
        return true;
      } else {
        print("Failed to create event: \\${response.data}");
        return false;
      }
    } catch (e, stack) {
      print('Error in _unpackAndCreateEvent: $e');
      print(stack);
      return false;
    }
  }

  _buildQuestionList() {
    if ((widget.eventData["questions"] ?? []).isEmpty) {
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
