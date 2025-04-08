import 'package:flutter/material.dart';
import 'ticket_management_page.dart';
import 'package:first_app/event_management/services/report_service.dart';
import 'questionnaire_management_page.dart';
import 'package:first_app/data/participant_data.dart';
import 'edit_event_page.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override

  _createReport(){
    ReportService reportService = ReportService();
    reportService.generatePdfReport(getParticipantData());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organiser Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFCF7FF),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TicketManagementPage()),
                );
              },
              style: _buttonStyle(),
              child: const Text(
                'TICKET MANAGEMENT',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _createReport();
              },
              style: _buttonStyle(),
              child: const Text(
                'GENERATE EVENT REPORT',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Add external URL logic
              },
              style: _buttonStyle(),
              child: const Text(
                'GENERATE EXTERNAL URL',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditEventPage()),
                );
              },
              style: _buttonStyle(),
              child: const Text(
                'EDIT EVENT INFORMATION',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuestionnaireManagementPage()),
                );
              },
              style: _buttonStyle(),
              child: const Text(
                'QUESTIONNAIRE MANAGEMENT',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4A55FF),
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(fontSize: 16, letterSpacing: 1),
    );
  }
}
