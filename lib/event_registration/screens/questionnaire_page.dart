import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/event_registration/screens/new_registration_form_generator.dart';

class QuestionnairePage extends StatefulWidget {
  final List<dynamic> questions;
  final void Function(Map<String, String>) onSubmit;

  const QuestionnairePage({
    Key? key,
    required this.questions,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  Map<String, String> responses = {};
  final _formKey = GlobalKey<FormState>();

  void _handleResponsesChanged(Map<String, String> newResponses) {
    setState(() {
      responses = newResponses;
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(responses);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all required questions.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Questionnaire')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: DynamicQuestionForm(
                    questions: widget.questions,
                    onResponsesChanged: _handleResponsesChanged,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 