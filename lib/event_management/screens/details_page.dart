import 'package:flutter/material.dart';
import 'ticket_management_page.dart';
import 'questionnaire_management_page.dart';
import 'edit_event_page.dart';
import 'package:app_mobile_frontend/event_management/services/report_service.dart';
import 'package:app_mobile_frontend/models/event.dart'; // Assuming EventWithQuestions or Event is here

class DetailsPage extends StatefulWidget {
  final EventDetails event; 
  const DetailsPage({super.key
      , required this.event});
  

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  /*   void _createReport() {
      final reportService = ReportService();
      reportService.generatePdfReport(getParticipantData());
    }
  */
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
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
            _buildDashboardButton(
              label: 'TICKET MANAGEMENT',
              onPressed: () => _navigateTo(context, const TicketManagementPage()),
            ),
/*             _buildDashboardButton(
              label: 'GENERATE EVENT REPORT',
              //onPressed: _createReport,
            ), */
            _buildDashboardButton(
              label: 'GENERATE EXTERNAL URL',
              onPressed: () {
                // TODO: Implement external URL logic
              },
            ),
            _buildDashboardButton(
              label: 'EDIT EVENT INFORMATION',
              onPressed: () {
                // TODO: Replace with the correct Event instance
                _navigateTo(context, EditEventPage(event: widget.event));
              },
            ),
            _buildDashboardButton(
              label: 'QUESTIONNAIRE MANAGEMENT',
              onPressed: () => _navigateTo(context, const QuestionnaireManagementPage()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton({required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: _buttonStyle(),
        child: Text(label, style: const TextStyle(color: Colors.white)),
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