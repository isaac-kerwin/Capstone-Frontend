import 'package:app_mobile_frontend/fundamental_widgets/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/models/question.dart';
import 'package:app_mobile_frontend/event_creation/widgets/create_question.dart';

class CreateQuestionDialog extends StatefulWidget {
  final CreateQuestionDTO? initialQuestion;

  const CreateQuestionDialog({
    super.key,
    this.initialQuestion,
  });

  @override
  State<CreateQuestionDialog> createState() => _CreateQuestionDialogState();
}

class _CreateQuestionDialogState extends State<CreateQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionTextController;
  late bool isRequired;
  late final TextEditingController _displayOrderController;

  // Add these for question type and options
  String _questionType = 'text';
  List<TextEditingController> _optionControllers = [];

  @override
  void initState() {
    super.initState();
    _questionTextController = TextEditingController(text: widget.initialQuestion?.questionText ?? '');
    isRequired = widget.initialQuestion?.isRequired ?? false;
    _displayOrderController = TextEditingController(
      text: widget.initialQuestion?.displayOrder.toString() ?? '',
    );
    // Optionally, initialize _questionType and _optionControllers from initialQuestion if editing
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    _displayOrderController.dispose();
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
            DropdownMenuItem(value: 'text', child: Text('Text')),
            DropdownMenuItem(value: 'dropdown', child: Text('Dropdown Menu')),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _questionType = value;
              if (_questionType == 'dropdown' && _optionControllers.isEmpty) {
                _optionControllers.add(TextEditingController());
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildOptionsFields() {
    if (_questionType != 'dropdown') return const SizedBox.shrink();
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
                      if (_questionType == 'dropdown' && (val == null || val.trim().isEmpty)) {
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

  String? validateDisplayOrder(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the display order';
    }
    if (int.tryParse(value.trim()) == null) {
      return 'Enter a valid number';
    }
    return null;
  }

  _createQuestionDTO() {
    return CreateQuestionDTO(
      questionText: _questionTextController.text.trim(),
      isRequired: isRequired,
      displayOrder: int.parse(_displayOrderController.text.trim()),
      questionType: _questionType,
      options: _questionType == 'dropdown'
          ? _optionControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList()
          : null,
    );
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
              // Display Order field.
              buildTextField(
                label: "Display Order",
                controller: _displayOrderController,
                validator: validateDisplayOrder,
                isNumber: true,
              ),
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