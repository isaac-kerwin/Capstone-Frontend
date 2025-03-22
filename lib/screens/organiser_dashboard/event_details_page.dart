import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/participant.dart';
import '../../data/participant_data.dart';
import '../../services/report_service.dart';
import '../../widgets/event_info_item.dart';
import '../../widgets/action_button.dart';
import 'package:first_app/services/url_service.dart';
import 'package:first_app/screens/organiser_dashboard/edit_event_page.dart';  

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({Key? key}) : super(key: key);

  Future<void> _generateAndShareReports(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Generating reports..."),
            ],
          ),
        );
      },
    );

    try {
      final participants = getParticipantData();
      final reportService = ReportService();
      final pdfFile = await reportService.generatePdfReport(participants);
      final csvFile = await reportService.generateCsvReport(participants);
      
      // Dismiss loading dialog
      Navigator.of(context).pop();
      
      // Show options dialog to share files
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Reports Generated"),
            content: const Text("Choose which file to share:"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Share.shareXFiles([XFile(pdfFile.path)], text: 'Event Participant Report');
                },
                child: const Text("Share PDF"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Share.shareXFiles([XFile(csvFile.path)], text: 'Event Participant Data');
                },
                child: const Text("Share CSV"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Dismiss loading dialog
      Navigator.of(context).pop();
      
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to generate reports: ${e.toString()}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Melbourne Italian Festa 2024',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '5/80 Filled Capacity',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            EventInfoItem(
              icon: Icons.calendar_today,
              iconColor: Colors.blue,
              title: 'Saturday 5th October 2024',
              subtitle: '3pm to 11:30pm',
            ),
            const SizedBox(height: 16),
            EventInfoItem(
              icon: Icons.location_on,
              iconColor: Colors.blue,
              title: 'Royal Exhibition Building',
              subtitle: '9 Nicholson St, Carlton VIC 3053',
            ),
            const SizedBox(height: 32),
            ActionButton(
              text: 'GENERATE EVENT REPORT',
              icon: Icons.arrow_forward,
              onPressed: () => _generateAndShareReports(context),
            ),
            const SizedBox(height: 16),
            ActionButton(
              text: 'GENERATE EXTERNAL URL',
              icon: Icons.arrow_forward,
              onPressed: () {
                UrlService url = UrlService();
                url.copyAndNavigate(context);
              },
            ),
            const SizedBox(height: 16),
            ActionButton(
              text: 'EDIT EVENT INFORMATION',
              icon: Icons.arrow_forward,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditEventPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}