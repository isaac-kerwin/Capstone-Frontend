import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/network/report.dart';
import 'package:app_mobile_frontend/event_management/services/export_report.dart';

class ReportScreen extends StatefulWidget {
  final int eventId;
  const ReportScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<dynamic> reportFuture;

  @override
  void initState() {
    super.initState();
    reportFuture = getEventReport(widget.eventId);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Report')),
      body: FutureBuilder<dynamic>(
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
                Text(report['eventName'] ?? '',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                TextButton(
                onPressed: () async {
                  try{
                    if (snapshot.hasData) {
                      await exportReportAsPdf(snapshot.data!);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Report saved to Downloads'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                  catch (e) {}
                },
                child: const Text('Export as PDF'),
              ),
                const SizedBox(height: 8),
                Text(report['eventDescription'] ?? ''),
                const SizedBox(height: 8),
                Text('Start: ${report['start'] ?? ''}'),
                Text('End: ${report['end'] ?? ''}'),
                const Divider(height: 32),
                Text('Sales', style: Theme.of(context).textTheme.titleMedium),
                Text('Total Tickets: ${report['sales']?['totalTickets'] ?? ''}'),
                Text('Revenue: \$${report['sales']?['revenue'] ?? ''}'),
                const SizedBox(height: 8),
                Text('Tickets Sold by Type:'),
                ...((report['sales']?['soldByTickets'] ?? []) as List)
                    .map<Widget>((t) => Text('${t['name']}: ${t['total']}')),
                const SizedBox(height: 8),
                Text('Revenue by Ticket:'),
                ...((report['sales']?['revenueByTickets'] ?? []) as List)
                    .map<Widget>((t) => Text('${t['name']}: \$${t['total']}')),
                const Divider(height: 32),
                Text('Remaining', style: Theme.of(context).textTheme.titleMedium),
                Text('Remaining Tickets: ${report['remaining']?['remainingTickets'] ?? ''}'),
                ...((report['remaining']?['remainingByTicket'] ?? []) as List)
                    .map<Widget>((r) => Text('${r['name']}: ${r['total']}')),
                const Divider(height: 32),
                Text('Participants', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _buildParticipantsTable(report['participants'] ?? []),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticipantsTable(List participants) {
    if (participants.isEmpty) {
      return const Text('No participants.');
    }

    // Collect all unique question texts for columns
    final Set<String> questionSet = {};
    for (final p in participants) {
      for (final resp in (p['questionnaireResponses'] ?? [])) {
        if (resp.containsKey('question')) {
          questionSet.add(resp['question']);
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
        rows: participants.map<DataRow>((p) {
          Map<String, String> respMap = {};
          for (final resp in (p['questionnaireResponses'] ?? [])) {
            if (resp.containsKey('question') && resp.containsKey('response')) {
              respMap[resp['question']] = resp['response'].toString();
            }
          }
          return DataRow(
            cells: [
              DataCell(Text(p['name'] ?? '')),
              DataCell(Text(p['email'] ?? '')),
              DataCell(Text(p['ticket'] ?? '')),
              ...questionColumns.map((q) => DataCell(Text(respMap[q] ?? ''))),
            ],
          );
        }).toList(),
      ),
    );
  }
}