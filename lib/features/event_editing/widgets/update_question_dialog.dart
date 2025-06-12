import 'package:flutter/material.dart';

/// A dialog to update only the "isRequired" property of a question.
class UpdateQuestionDialog extends StatefulWidget {
  /// Initial required state
  final bool isRequired;

  /// Callback when the new required state is saved
  final ValueChanged<bool> onSave;

  const UpdateQuestionDialog({
    Key? key,
    required this.isRequired,
    required this.onSave,
  }) : super(key: key);

  @override
  _UpdateQuestionDialogState createState() => _UpdateQuestionDialogState();
}

class _UpdateQuestionDialogState extends State<UpdateQuestionDialog> {
  late bool _isRequired;

  @override
  void initState() {
    super.initState();
    _isRequired = widget.isRequired;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Question Settings'),
      content: CheckboxListTile(
        title: const Text('Required'),
        value: _isRequired,
        onChanged: (value) {
          if (value != null) {
            setState(() => _isRequired = value);
          }
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_isRequired);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}