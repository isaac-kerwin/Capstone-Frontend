import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/models/question.dart';
import 'package:app_mobile_frontend/features/event_creation/widgets/create_question.dart';
import 'package:app_mobile_frontend/network/event.dart';
import 'package:app_mobile_frontend/core/fundamental_widgets/action_button.dart';
import 'package:app_mobile_frontend/features/event_management/widgets/question_tile.dart';
import 'package:logging/logging.dart';

/// Page for creating, editing and managing a list of questionnaire questions for an event
class QuestionnaireManagementPage extends StatefulWidget {
  final int eventId;
  final List<QuestionDTO> questions;
  final int registrationsCount;

  const QuestionnaireManagementPage({
    super.key,
    required this.eventId,
    required this.questions,
    required this.registrationsCount,
  });

  @override
  State<QuestionnaireManagementPage> createState() => _QuestionnaireManagementPageState();
}

class _QuestionnaireManagementPageState extends State<QuestionnaireManagementPage> {
  /// Logger for debugging question management actions
  final Logger _logger = Logger('QuestionManagement');
  List<QuestionDTO> _questions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _logger.info('Initializing with ${widget.questions.length} existing questions');
    _questions = List.from(widget.questions);
  }

  /// Opens a dialog to create a new question and adds it to the local list
  Future<void> _openCreateQuestionDialog() async {
    _logger.fine('Opening create question dialog');
    final CreateQuestionDTO? newQuestion = await showDialog<CreateQuestionDTO>(
      context: context,
      builder: (context) => CreateQuestionDialog(displayOrder: _questions.length + 1),
    );
    if (newQuestion != null) {
      _logger.info('Created new question: ${newQuestion.questionText}');
      setState(() {
        _questions.add(QuestionDTO(
          id: 0, // Temporary ID for new questions
          questionText: newQuestion.questionText,
          isRequired: newQuestion.isRequired,
          displayOrder: newQuestion.displayOrder,
          questionType: newQuestion.questionType,
          options: newQuestion.options,
        ));
      });
    }
  }

  /// Opens a dialog to edit an existing question and updates it in the list
  Future<void> _openEditQuestionDialog(QuestionDTO question) async {
    _logger.fine('Opening edit dialog for question ID: ${question.id}, text: ${question.questionText}, type: ${question.questionType}, options: ${question.options}');
    // Show the dialog for editing, passing in the current question details
    final CreateQuestionDTO? editedQuestion = await showDialog<CreateQuestionDTO>(
      context: context,
      builder: (context) => CreateQuestionDialog(
        initialQuestion: CreateQuestionDTO(
          questionText: question.questionText,
          isRequired: question.isRequired,
          displayOrder: question.displayOrder,
          questionType: question.questionType,
          options: question.options,
        ),
        displayOrder: question.displayOrder,
        allowTypeChange: widget.registrationsCount == 0,
      ),
    );
    if (editedQuestion != null) {
      _logger.info('Edited question ID ${question.id}: ${editedQuestion.questionText}');
      setState(() {
        final index = _questions.indexWhere((q) => q.id == question.id);
        if (index != -1) {
          _questions[index] = QuestionDTO(
            id: question.id,
            questionText: editedQuestion.questionText,
            isRequired: editedQuestion.isRequired,
            displayOrder: editedQuestion.displayOrder,
            questionType: editedQuestion.questionType,
            options: editedQuestion.options,
          );
        }
      });
    }
  }

  /// Prompts for confirmation and deletes the selected question
  Future<void> _deleteQuestion(QuestionDTO question) async {
    _logger.warning('Attempting to delete question ID: ${question.id}');
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
      _logger.info('Deleted question ID: ${question.id}');
      setState(() {
        _questions.removeWhere((q) => q.id == question.id);
      });
    }
  }

  /// Persists all changes (new/edit/delete) by sending updated questions to the backend
  Future<void> _saveChanges() async {
    _logger.info('Saving ${_questions.length} questions for event ID: ${widget.eventId}');
    setState(() { _isLoading = true; });

    try {
      // Convert to DTO list and call network API
      final questionsToUpdate = _questions.map((q) => CreateQuestionDTO(
            questionText: q.questionText,
            isRequired: q.isRequired,
            displayOrder: q.displayOrder,
            questionType: q.questionType,
            options: q.options,
          )).toList();
      final success = await updateEventQuestions(widget.eventId, questionsToUpdate);
      if (success) {
        _logger.info('Questions saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Questions updated successfully')),);
      } else {
        _logger.warning('Failed to save questions');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update questions')),);
      }
    } catch (e) {
      _logger.severe('Error saving questions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating questions: $e')),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  /// Builds the scrollable list of current questions with edit and delete actions
  Widget _buildQuestionList() {
    if (_questions.isEmpty) {
      return const Center(child: Text('No questions added yet.'));
    }
    return ListView.builder(
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        final question = _questions[index];
        final canEdit = widget.registrationsCount == 0;
        final canDelete = widget.registrationsCount == 0;
        return QuestionTile(
          question: question,
          canEdit: canEdit,
          canDelete: canDelete,
          onEdit: (_) => _openEditQuestionDialog(question),
          onDelete: (_) => _deleteQuestion(question),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Main UI scaffold with loading state, add question button, and save button
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
                    onPressed: widget.registrationsCount == 0 ? _openCreateQuestionDialog : null,
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