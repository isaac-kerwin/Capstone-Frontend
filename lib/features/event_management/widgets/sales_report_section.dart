import 'package:flutter/material.dart';

class SalesReportSection extends StatelessWidget {
  final Map<String, dynamic> salesData;

  const SalesReportSection({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sales', style: Theme.of(context).textTheme.titleMedium),
        Text('Total Tickets: ${salesData['totalTickets'] ?? 'N/A'}'),
        Text('Revenue: \$${salesData['revenue'] ?? 'N/A'}'),
        const SizedBox(height: 8),
        Text('Tickets Sold by Type:'),
        ...((salesData['soldByTickets'] ?? []) as List)
            .map<Widget>((t) => Text('${t['name']}: ${t['total']}')),
        const SizedBox(height: 8),
        Text('Revenue by Ticket:'),
        ...((salesData['revenueByTickets'] ?? []) as List)
            .map<Widget>((t) => Text('${t['name']}: \$${t['total']}')),
      ],
    );
  }
}
