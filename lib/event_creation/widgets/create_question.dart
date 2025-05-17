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

  @override
  void initState() {
    super.initState();
    _questionTextController = TextEditingController(text: widget.initialQuestion?.questionText ?? '');
    isRequired = widget.initialQuestion?.isRequired ?? false;
    _displayOrderController = TextEditingController(
      text: widget.initialQuestion?.displayOrder.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    _displayOrderController.dispose();
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
    );
  }

  _onPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      // Create the question object.
      final question = _createQuestionDTO();
      Navigator.pop(context, question); // Return the created question.
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