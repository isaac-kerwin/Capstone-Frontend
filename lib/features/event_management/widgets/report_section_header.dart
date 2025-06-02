import 'package:flutter/material.dart';

class ReportSectionHeader extends StatelessWidget {
  final String eventName;
  final String eventDescription;
  final String startStr;
  final String endStr;
  final VoidCallback onExport;

  const ReportSectionHeader({
    super.key,
    required this.eventName,
    required this.eventDescription,
    required this.startStr,
    required this.endStr,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eventName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onExport,
          child: const Text('Export as PDF'),
        ),
        const SizedBox(height: 8),
        Text(eventDescription),
        const SizedBox(height: 8),
        Text('Start: $startStr'),
        Text('End: $endStr'),
      ],
    );
  }
}
