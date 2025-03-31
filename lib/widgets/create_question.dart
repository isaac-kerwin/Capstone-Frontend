import 'package:flutter/material.dart';
import 'package:first_app/models/question.dart';

class CreateQuestionDialog extends StatefulWidget {
  const CreateQuestionDialog({super.key});

  @override
  State<CreateQuestionDialog> createState() => _CreateQuestionDialogState();
}

class _CreateQuestionDialogState extends State<CreateQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  String questionText = '';
  bool isRequired = false;
  String displayOrderStr = '';

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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Question Text'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the question text';
                  }
                  return null;
                },
                onSaved: (value) => questionText = value!.trim(),
              ),
              const SizedBox(height: 8),
              // isRequired field using a Switch.
              Row(
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
              ),
              const SizedBox(height: 8),
              // Display Order field.
              TextFormField(
                decoration: const InputDecoration(labelText: 'Display Order'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the display order';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => displayOrderStr = value!.trim(),
              ),
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
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState!.save();
              final question = CreateQuestionDTO(
                questionText: questionText,
                isRequired: isRequired,
                displayOrder: int.parse(displayOrderStr),
              );
              Navigator.pop(context, question); 
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}