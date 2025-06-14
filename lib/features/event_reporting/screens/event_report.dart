import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/api/report_services.dart';
import 'package:app_mobile_frontend/features/event_management/services/export_report.dart';
import 'package:app_mobile_frontend/features/event_management/services/date_and_time_parser.dart';
import 'package:app_mobile_frontend/features/event_reporting/widgets/report_section_header.dart';
import 'package:app_mobile_frontend/features/event_reporting/widgets/sales_report_section.dart';
import 'package:app_mobile_frontend/features/event_reporting/widgets/remaining_tickets_section.dart';
import 'package:app_mobile_frontend/features/event_reporting/widgets/participants_table.dart';
import 'package:app_mobile_frontend/features/event_reporting/widgets/questions_summary_section.dart';

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
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No report data found.'));
          }

          final report = snapshot.data!;

          // Format start and end date/time
          String startStr = 'N/A';
          String endStr = 'N/A';
          try {
            if (report['start'] != null) {
              final startDate = DateTime.parse(report['start']);
              startStr =
                  '${formatDateAsWords(startDate)} at ${formatTimeAmPm(startDate)}';
            }
            if (report['end'] != null) {
              final endDate = DateTime.parse(report['end']);
              endStr =
                  '${formatDateAsWords(endDate)} at ${formatTimeAmPm(endDate)}';
            }
          } catch (_) {
            // Dates might be invalid or null, keep N/A
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReportSectionHeader(
                  eventName: report['eventName'] ?? 'Event Name Not Available',
                  eventDescription: report['eventDescription'] ?? 'No description.',
                  startStr: startStr,
                  endStr: endStr,
                  onExport: () async {
                    try {
                      // Ensure report data is not null before exporting
                      if (snapshot.data != null) {
                         await exportReportAsPdf(snapshot.data!);
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(
                             content: Text('Report saved to Downloads'),
                             duration: Duration(seconds: 3),
                           ),
                         );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(
                             content: Text('No data to export.'),
                             duration: Duration(seconds: 3),
                           ),
                         );
                      }
                    } catch (e) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                           content: Text('Error exporting PDF: $e'),
                           duration: const Duration(seconds: 3),
                         ),
                       );
                    }
                  },
                ),
                const Divider(height: 32),
                SalesReportSection(
                  salesData: report['sales'] as Map<String, dynamic>? ?? {},
                ),
                const Divider(height: 32),
                RemainingTicketsSection(
                  remainingData: report['remaining'] as Map<String, dynamic>? ?? {},
                ),
                const Divider(height: 32),
                Text('Participants', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ParticipantsTable(
                  participantsData: (report['participants'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ?? [],
                ),
                const Divider(height: 32),
                QuestionsSummarySection(
                  questionsData: report['questions'] as Map<String, dynamic>? ?? {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}