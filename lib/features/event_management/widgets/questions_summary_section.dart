import 'package:flutter/material.dart';

class QuestionsSummarySection extends StatelessWidget {
  final Map<String, dynamic> questionsData;

  const QuestionsSummarySection({super.key, required this.questionsData});

  @override
  Widget build(BuildContext context) {
    if (questionsData.isEmpty) {
      return const Text('No questions summary available.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Questions Summary', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...questionsData.entries.map<Widget>((entry) {
          final details = entry.value as Map<String, dynamic>; // Ensure this cast is safe
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
              ...details.entries.map((opt) => Text('${opt.key}: ${opt.value}')),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ],
    );
  }
}
