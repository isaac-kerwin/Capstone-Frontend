import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/network/report.dart';
import 'package:app_mobile_frontend/models/report.dart';

class ReportScreen extends StatefulWidget {
  final int eventId;
  const ReportScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<Report> reportFuture;

  @override
  void initState() {
    super.initState();
    reportFuture = getEventReport(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Report')),
      body: FutureBuilder<Report>(
        future: reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No report data found.'));
          }
          final report = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.eventName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(report.eventDescription),
                const SizedBox(height: 8),
                Text('Location: ${report.eventLocation}'),
                Text('Start: ${report.startDateTime}'),
                Text('End: ${report.endDateTime}'),
                const Divider(height: 32),
                Text('Sales', style: Theme.of(context).textTheme.titleMedium),
                Text('Total Tickets: ${report.sales.totalTickets}'),
                Text('Revenue: \$${report.sales.revenue}'),
                const SizedBox(height: 8),
                Text('Tickets Sold by Type:'),
                ...report.sales.ticketTypes
                    .map((t) => Text('${t['type']}: ${t['count']}')),
                const SizedBox(height: 8),
                Text('Revenue by Ticket:'),
                ...report.sales.revenueByTicket
                    .map((t) => Text('${t['type']}: \$${t['revenue']}')),
                const Divider(height: 32),
                Text('Remaining', style: Theme.of(context).textTheme.titleMedium),
                Text('Remaining Tickets: ${report.remaining.remainingTickets}'),
                ...report.remaining.remainingByTicket.entries
                    .map((e) => Text('${e.key}: ${e.value}')),
                const Divider(height: 32),
                Text('Participants', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _buildParticipantsTable(report.participants),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticipantsTable(List<Participant> participants) {
    if (participants.isEmpty) {
      return const Text('No participants.');
    }

    // Collect all unique question texts for columns
    final Set<String> questionSet = {};
    for (final p in participants) {
      for (final resp in p.questionResponses) {
        if (resp.containsKey('questionText')) {
          questionSet.add(resp['questionText']);
        }
      }
    }
    final List<String> questionColumns = questionSet.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          const DataColumn(label: Text('Name')),
          const DataColumn(label: Text('Email')),
          const DataColumn(label: Text('Ticket Type')),
          ...questionColumns.map((q) => DataColumn(label: Text(q))),
        ],
        rows: participants.map((p) {
          Map<String, String> respMap = {};
          for (final resp in p.questionResponses) {
            if (resp.containsKey('questionText') &&
                resp.containsKey('response')) {
              respMap[resp['questionText']] = resp['response'].toString();
            }
          }
          return DataRow(
            cells: [
              DataCell(Text(p.name)),
              DataCell(Text(p.email)),
              DataCell(Text(p.ticketType)),
              ...questionColumns.map((q) => DataCell(Text(respMap[q] ?? ''))),
            ],
          );
        }).toList(),
      ),
    );
  }
}