import 'package:flutter/material.dart';

class RemainingTicketsSection extends StatelessWidget {
  final Map<String, dynamic> remainingData;

  const RemainingTicketsSection({super.key, required this.remainingData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Remaining', style: Theme.of(context).textTheme.titleMedium),
        Text('Remaining Tickets: ${remainingData['remainingTickets'] ?? 'N/A'}'),
        ...((remainingData['remainingByTicket'] ?? []) as List)
            .map<Widget>((r) => Text('${r['name']}: ${r['total']}')),
      ],
    );
  }
}
