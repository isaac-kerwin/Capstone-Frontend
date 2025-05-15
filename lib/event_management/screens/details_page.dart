import 'package:flutter/material.dart';
import 'ticket_management_page.dart';
import 'questionnaire_management_page.dart';
import 'edit_event_page.dart';
import 'package:first_app/event_management/services/report_service.dart';
import 'package:first_app/models/event.dart'; // Assuming EventWithQuestions or Event is here
import 'package:first_app/network/event.dart';
import 'package:first_app/models/organizer.dart';
import 'package:first_app/models/question.dart';

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
              onPressed: () => _navigateTo(context, TicketManagementPage(event: widget.event)),
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
                _navigateTo(context, EditEventPage(event: widget.event));
              },
            ),
            _buildDashboardButton(
              label: 'QUESTIONNAIRE MANAGEMENT',
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                try {
                  final eventWithQuestions = await getEventById(widget.event.id);
                  Navigator.pop(context); // Remove loading dialog
                  _navigateTo(
                    context,
                    QuestionnaireManagementPage(
                      eventId: widget.event.id,
                      questions: eventWithQuestions.questions.map((q) => QuestionDTO(
                        id: q.id,
                        questionText: q.question.questionText,
                        isRequired: q.isRequired,
                        displayOrder: q.displayOrder,
                      )).toList(),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context); // Remove loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to load questions: $e')),
                  );
                }
              },
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