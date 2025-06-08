import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/core/models/question.dart';

typedef QuestionAction = void Function(QuestionDTO question);

/// A tile widget displaying a question with edit and delete actions.
class QuestionTile extends StatelessWidget {
  final QuestionDTO question;
  final bool canEdit;
  final bool canDelete;
  final QuestionAction onEdit;
  final QuestionAction onDelete;

  const QuestionTile({
    Key? key,
    required this.question,
    required this.canEdit,
    required this.canDelete,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onPressed: canEdit ? () => onEdit(question) : null,
              tooltip: canEdit ? 'Edit Question' : 'Cannot edit after registrations',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: canDelete ? () => onDelete(question) : null,
              tooltip: canDelete ? 'Delete Question' : 'Cannot delete after registrations',
            ),
          ],
        ),
      ),
    );
  }
}