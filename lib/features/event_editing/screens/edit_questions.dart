import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/core/models/question_models.dart';
import 'package:app_mobile_frontend/features/event_creation/widgets/create_question.dart';
import 'package:app_mobile_frontend/api/question_services.dart';
import 'package:app_mobile_frontend/features/event_editing/widgets/question_tile.dart';
import 'package:app_mobile_frontend/features/event_editing/widgets/update_question_dialog.dart';
import 'package:app_mobile_frontend/api/event_services.dart';
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
  State<QuestionnaireManagementPage> createState() =>
      _QuestionnaireManagementPageState();
}

class _QuestionnaireManagementPageState
    extends State<QuestionnaireManagementPage> {
  /// Logger for debugging question management actions
  final Logger _logger = Logger('QuestionManagement');
  List<QuestionDTO> _questions = [];

  /// Reload questions from backend
  Future<void> _loadQuestions() async {
    try {
      final event = await getEventById(widget.eventId);
      setState(() {
        _questions = event.questions
            .map((q) => QuestionDTO(
                  id: q.id,
                  questionText: q.question.questionText,
                  isRequired: q.isRequired,
                  displayOrder: q.displayOrder,
                  questionType: q.question.questionType,
                  options: q.question.options
                          ?.map((opt) => {
                                'optionText': opt.optionText,
                                'displayOrder': opt.displayOrder
                              })
                          .toList() ??
                      [],
                ))
            .toList();
      });
    } catch (e) {
      _logger.severe('Failed to load questions: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _logger
        .info('Initializing question management for event ${widget.eventId}');
    _loadQuestions();
  }

  /// Opens a dialog to create a new question and adds it to the local list
  Future<void> _openCreateQuestionDialog() async {
    _logger.fine('Opening create question dialog');
    final CreateQuestionDTO? newQuestion = await showDialog<CreateQuestionDTO>(
      context: context,
      builder: (context) => CreateQuestionDialog(
          displayOrder: _questions.length + 1), // create dialog
    );
    if (newQuestion != null) {
      _logger.info('Created new question: ${newQuestion.questionText}');
      // Call create API then update local list
      final created = await createEventQuestion(widget.eventId, newQuestion);
      if (created) {
        // Reload questions from backend
        await _loadQuestions();
      }
    }
  }

  /// Opens a dialog to edit an existing question and updates it in the list
  Future<void> _openEditQuestionDialog(QuestionDTO question) async {
    _logger.fine(
        'Opening edit dialog for question ID: ${question.id}, text: ${question.questionText}, type: ${question.questionType}, options: ${question.options}');
    // Show dialog to update only 'isRequired'
    await showDialog<bool>(
      context: context,
      builder: (context) => UpdateQuestionDialog(
        isRequired: question.isRequired,
        onSave: (newRequired) async {
          final index = _questions.indexWhere((q) => q.id == question.id);
          if (index != -1) {
            // Call API to update isRequired only
            final success = await updateEventQuestion(
              widget.eventId,
              question.id,
              UpdateQuestionDTO(isRequired: newRequired),
            );
            if (success) {
              // Reload questions from backend
              await _loadQuestions();
            }
          }
        },
      ), // update dialog
    );
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
      final deleted = await deleteEventQuestion(widget.eventId, question.id);
      if (deleted) {
        // Reload questions from backend
        await _loadQuestions();
      }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextButton(
              onPressed: widget.registrationsCount == 0
                  ? _openCreateQuestionDialog
                  : null,
              child: const Text('Add Question'),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildQuestionList()),
          ],
        ),
      ),
    );
  }
}
