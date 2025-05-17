import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_mobile_frontend/models/question.dart';
import 'package:app_mobile_frontend/event_creation/widgets/create_question.dart';
import 'package:app_mobile_frontend/network/event.dart';
import 'package:app_mobile_frontend/fundamental_widgets/action_button.dart';
import 'package:app_mobile_frontend/fundamental_widgets/form_widgets.dart';
import 'package:app_mobile_frontend/network/dio_client.dart';
import 'package:app_mobile_frontend/network/auth.dart';
import 'package:dio/dio.dart';

class QuestionnaireManagementPage extends StatefulWidget {
  final int eventId;
  final List<QuestionDTO> questions;

  const QuestionnaireManagementPage({
    super.key,
    required this.eventId,
    required this.questions,
  });

  @override
  State<QuestionnaireManagementPage> createState() => _QuestionnaireManagementPageState();
}

class _QuestionnaireManagementPageState extends State<QuestionnaireManagementPage> {
  List<QuestionDTO> _questions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _questions = List.from(widget.questions);
  }

  Future<void> _openCreateQuestionDialog() async {
    final CreateQuestionDTO? newQuestion = await showDialog<CreateQuestionDTO>(
      context: context,
      builder: (context) => const CreateQuestionDialog(),
    );
    if (newQuestion != null) {
      setState(() {
        _questions.add(QuestionDTO(
          id: 0, // Temporary ID for new questions
          questionText: newQuestion.questionText,
          isRequired: newQuestion.isRequired,
          displayOrder: newQuestion.displayOrder,
        ));
      });
    }
  }

  Future<void> _openEditQuestionDialog(QuestionDTO question) async {
    final CreateQuestionDTO? editedQuestion = await showDialog<CreateQuestionDTO>(
      context: context,
      builder: (context) => CreateQuestionDialog(
        initialQuestion: CreateQuestionDTO(
          questionText: question.questionText,
          isRequired: question.isRequired,
          displayOrder: question.displayOrder,
        ),
      ),
    );
    if (editedQuestion != null) {
      setState(() {
        final index = _questions.indexWhere((q) => q.id == question.id);
        if (index != -1) {
          _questions[index] = QuestionDTO(
            id: question.id,
            questionText: editedQuestion.questionText,
            isRequired: editedQuestion.isRequired,
            displayOrder: editedQuestion.displayOrder,
          );
        }
      });
    }
  }

  Future<void> _deleteQuestion(QuestionDTO question) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: const Text('Are you sure you want to delete this question?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _questions.removeWhere((q) => q.id == question.id);
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch the full event data first
      final event = await getEventById(widget.eventId);

      // Convert questions to CreateQuestionDTO format
      final questionsToUpdate = _questions.map((q) => CreateQuestionDTO(
        questionText: q.questionText,
        isRequired: q.isRequired,
        displayOrder: q.displayOrder,
      )).toList();

      // Call the API to update the event with all required fields
      final response = await dioClient.dio.put(
        "/events/${widget.eventId}",
        data: {
          "name": event.name,
          "description": event.description,
          "location": event.location,
          "eventType": event.eventType,
          "startDateTime": event.startDateTime.toIso8601String(),
          "endDateTime": event.endDateTime.toIso8601String(),
          "capacity": event.capacity,
          "tickets": event.tickets.map((ticket) => ticket.toJson()).toList(),
          "questions": questionsToUpdate.map((q) => q.toJson()).toList(),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.data["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Questions updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update questions')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating questions: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildQuestionList() {
    if (_questions.isEmpty) {
      return const Center(child: Text('No questions added yet.'));
    }
    return ListView.builder(
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        final question = _questions[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            title: Text(question.questionText),
            subtitle: Text(
              'Required: ${question.isRequired ? "Yes" : "No"}, Order: ${question.displayOrder}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _openEditQuestionDialog(question),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteQuestion(question),
                ),
              ],
            ),
          ),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextButton(
                    onPressed: _openCreateQuestionDialog,
                    child: const Text('Add Question'),
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildQuestionList()),
                  const SizedBox(height: 16),
                  ActionButton(
                    onPressed: _saveChanges,
                    text: 'Save Changes',
                    icon: Icons.save,
                  ),
                ],
              ),
            ),
    );
  }
}