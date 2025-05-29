import 'package:app_mobile_frontend/event_management/screens/edit_registrations.dart';
import 'edit_tickets.dart';
import 'edit_questions.dart';
import 'edit_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_mobile_frontend/models/event.dart'; // Assuming EventWithQuestions or Event is here
import 'package:app_mobile_frontend/network/event.dart';
import 'package:app_mobile_frontend/features/event_management/widgets/event_info_tile.dart';
import 'package:app_mobile_frontend/models/question.dart';
import 'package:app_mobile_frontend/event_management/screens/edit_registrations.dart';   
import 'package:app_mobile_frontend/features/event_management/screens/event_report.dart'; 

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

body: Padding(
  padding: const EdgeInsets.all(24.0),
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EventInfoTile(event: widget.event),
        _buildDashboardButton(
          label: 'EDIT EVENT TICKETS',
          onPressed: () => _navigateTo(context, TicketManagementPage(event: widget.event)),
        ),
        _buildDashboardButton(
          label: 'GENERATE EXTERNAL URL',
          onPressed: () {
            // TODO: Implement external URL logic
          },
        ),
        _buildDashboardButton(
          label: 'EVENT REPORT',
          onPressed: () {
            _navigateTo(context, ReportScreen(eventId: widget.event.id));
          }
        ),
        _buildDashboardButton(
          label: 'EDIT EVENT INFORMATION',
          onPressed: () {
            _navigateTo(context, EditEventPage(event: widget.event));
          },
        ),
        _buildDashboardButton(
          label: 'EDIT EVENT REGISTRATIONS',
          onPressed: () {
            _navigateTo(context, EditRegistrationsScreen(eventId: widget.event.id));
          },
        ),
        _buildDashboardButton(
          label: 'EDIT EVENT QUESTIONS',
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
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(fontSize: 16, letterSpacing: 1),
    );
  }
}