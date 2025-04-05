import 'package:first_app/widgets/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/question.dart';
import 'package:first_app/widgets/create_question.dart';

class CreateQuestionDialog extends StatefulWidget {
  const CreateQuestionDialog({super.key});

  @override
  State<CreateQuestionDialog> createState() => _CreateQuestionDialogState();
}

class _CreateQuestionDialogState extends State<CreateQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionTextController = TextEditingController();
  bool isRequired = false;
  final TextEditingController _displayOrderController = TextEditingController();

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

  _createQuestionDTO(){
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
      title: const Text('Create Question'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Question Text field.
              buildTextField(label: "Question Text", controller: _questionTextController),
              const SizedBox(height: 8),
              // isRequired field using a Switch.
              _buildIsRequiredSwitch(),
              const SizedBox(height: 8),
              // Display Order field.
              buildTextField( label: "Display Order", controller: _displayOrderController, validator: validateDisplayOrder, isNumber: true, ),
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
          onPressed: () { _onPressed(); // Create question action.
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}