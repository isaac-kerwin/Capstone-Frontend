import 'dart:math';
import 'package:app_mobile_frontend/core/fundamental_widgets/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/models/question.dart';
import 'package:app_mobile_frontend/features/event_creation/widgets/create_question.dart';

class CreateQuestionDialog extends StatefulWidget {
  final CreateQuestionDTO? initialQuestion;
  final int displayOrder;

  const CreateQuestionDialog({
    super.key,
    this.initialQuestion,
    required this.displayOrder,
  });

  @override
  State<CreateQuestionDialog> createState() => _CreateQuestionDialogState();
}

class _CreateQuestionDialogState extends State<CreateQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionTextController;
  late bool isRequired;

  // Add these for question type and options
  String _questionType = "TEXT";
  List<TextEditingController> _optionControllers = [];

  @override
  void initState() {
    super.initState();
    _questionTextController = TextEditingController(text: widget.initialQuestion?.questionText ?? '');
    isRequired = widget.initialQuestion?.isRequired ?? false;
    // Optionally, initialize _questionType and _optionControllers from initialQuestion if editing
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    for (var c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  _buildIsRequiredSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Is Required:'),
        Switch(
          value: isRequired,
          onChanged: (value) {
            setState(() {
              isRequired = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildQuestionTypeDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Question Type:'),
        DropdownButton<String>(
          value: _questionType,
          items: const [
            DropdownMenuItem(value: "TEXT", child: Text('Text')),
            DropdownMenuItem(value: 'DROPDOWN', child: Text('Dropdown Menu')),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _questionType = value;
              if (_questionType == 'DROPDOWN' && _optionControllers.isEmpty) {
                _optionControllers.add(TextEditingController());
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildOptionsFields() {
    if (_questionType != 'DROPDOWN') return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text('Dropdown Options:', style: TextStyle(fontWeight: FontWeight.bold)),
        ..._optionControllers.asMap().entries.map((entry) {
          final idx = entry.key;
          final controller = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Option ${idx + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (_questionType == 'DROPDOWN' && (val == null || val.trim().isEmpty)) {
                        return 'Option cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
                if (_optionControllers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _optionControllers.removeAt(idx);
                      });
                    },
                  ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _optionControllers.add(TextEditingController());
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Option'),
        ),
      ],
    );
  }

_createQuestionDTO() {
  if (_questionType == 'DROPDOWN'){
  return CreateQuestionDTO(
    questionText: _questionTextController.text.trim(),
    isRequired: isRequired,
    displayOrder: widget.displayOrder,
    questionType: _questionType,
    options: _questionType == 'DROPDOWN'
      ? _optionControllers
          .asMap()
          .entries
          .where((e) => e.value.text.trim().isNotEmpty)
          .map((e) => <String, dynamic>{
                // no id field
                'optionText': e.value.text.trim(),
                'displayOrder': e.key + 1,
              })
          .toList()
      : null,
  );
  }
  else {
    return CreateQuestionDTO(
      questionText: _questionTextController.text.trim(),
      isRequired: isRequired,
      displayOrder: widget.displayOrder,
      questionType: _questionType,
    );
  }
}

  _onPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      final question = _createQuestionDTO();
      Navigator.pop(context, question);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialQuestion == null ? 'Create Question' : 'Edit Question'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Question Text field.
              buildTextField(
                label: "Question Text",
                controller: _questionTextController,
              ),
              const SizedBox(height: 8),
              // isRequired field using a Switch.
              _buildIsRequiredSwitch(),
              const SizedBox(height: 8),
              // Question Type dropdown.
              _buildQuestionTypeDropdown(),
              const SizedBox(height: 8),
              // Options fields for dropdown type.
              _buildOptionsFields(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cancel action.
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _onPressed, // Create/Edit question action.
          child: Text(widget.initialQuestion == null ? 'Create' : 'Save'),
        ),
      ],
    );
  }
}