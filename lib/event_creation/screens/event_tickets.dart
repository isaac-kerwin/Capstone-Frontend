import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/models/tickets.dart';
import 'package:app_mobile_frontend/event_creation/widgets/create_ticket.dart';
import 'package:app_mobile_frontend/fundamental_widgets/action_button.dart';
import 'package:app_mobile_frontend/event_creation/screens/event_common_questions.dart';

class TicketManagementScreen extends StatefulWidget {
  
  Map<String, dynamic> eventData = {}; 

  TicketManagementScreen({ required this.eventData, super.key,});

  @override
  State<TicketManagementScreen> createState() => _TicketManagementScreenState();
}

class _TicketManagementScreenState extends State<TicketManagementScreen> {
  DateTime? salesStart;
  DateTime? salesEnd;
  List<TicketDTO> tickets = [];

  // Helper to pick a date.
  Future<DateTime?> _pickDate(DateTime? initialDate, {DateTime? lastDate, DateTime? firstDate}) async {
    DateTime now = DateTime.now();
    final DateTime effectiveFirstDate = firstDate ?? DateTime(now.year, now.month, now.day);
    DateTime effectiveInitialDate = initialDate ?? effectiveFirstDate;
    if (effectiveInitialDate.isBefore(effectiveFirstDate)) {
      effectiveInitialDate = effectiveFirstDate;
    }
    return await showDatePicker(
      context: context,
      initialDate: effectiveInitialDate,
      firstDate: effectiveFirstDate,
      lastDate: lastDate ?? DateTime(now.year + 5),
    );
  }

  Future<void> _selectSalesStart() async {
    final DateTime? picked = await _pickDate(
      salesStart,
      firstDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        salesStart = picked;
      });
    }
  }

  Future<void> _selectSalesEnd() async {
    // Block dates later than event start date and earlier than or equal to salesStart
    final eventStart = widget.eventData['startDateTime'];
    DateTime? eventStartDate;
    if (eventStart is DateTime) {
      eventStartDate = eventStart;
    } else if (eventStart is String) {
      eventStartDate = DateTime.tryParse(eventStart);
    }
    final DateTime? picked = await _pickDate(
      salesEnd ?? salesStart,
      lastDate: eventStartDate ?? DateTime.now().add(const Duration(days: 365 * 5)),
      firstDate: salesStart != null ? salesStart!.add(const Duration(days: 1)) : DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        salesEnd = picked;
      });
    }
  }

  // Opens the ticket creation pop-up.
  Future<void> _openCreateTicketDialog() async {
    if (salesStart == null || salesEnd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both sales start and end dates.')),
      );
      return;
    }
    final TicketDTO? newTicket = await showDialog<TicketDTO>(
      context: context,
      builder: (context) => CreateTicketDialog(
        salesStart: salesStart!,
        salesEnd: salesEnd!,
      ),
    );
    if (newTicket != null) {
      setState(() {
        tickets.add(newTicket);
      });
    }
  }

  String _formatDate(DateTime? date) {
    return date == null ? 'Not selected' : date.toLocal().toString().split(' ')[0];
  }
  
  void _onContinue(){
    if (salesStart == null || salesEnd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both sales start and end dates.')),
      );
      return;
    }
    if (tickets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one ticket.')),
      );
      return;
    }

    widget.eventData['tickets'] = tickets;
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => CommonQuestions( eventData: widget.eventData,),
      ),
    );
  }

  Widget _buildDateRow({
    required String label,
    required String dateText,
    required VoidCallback onPressed,
    required String buttonText,
  }) {
    return Row(
      children: [
        Expanded(child: Text('$label: $dateText')),
        TextButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ],
    );
  }

  Widget _buildTicketList() {
  if (tickets.isEmpty) {
    return const Center(child: Text('No tickets added yet.'));
  }
  return ListView.builder(
    itemCount: tickets.length,
    itemBuilder: (context, index) {
      final ticket = tickets[index];
      return ListTile(
        title: Text(ticket.name),
        subtitle: Text('Price: ${ticket.price}, Quantity: ${ticket.quantityTotal}'),
      );
    },
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sales Start Date
            _buildDateRow(
              label: 'Sales Start',
              dateText: _formatDate(salesStart),
              onPressed: _selectSalesStart,
              buttonText: 'Select Start',
            ),
            const SizedBox(height: 8),
            // Sales End Date
            _buildDateRow(
              label: 'Sales End',
              dateText: _formatDate(salesEnd),
              onPressed: _selectSalesEnd,
              buttonText: 'Select End',
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: _openCreateTicketDialog, child: Text('Add Tickets')),
            const SizedBox(height: 16),
            // List of tickets
            Expanded(child: _buildTicketList()),
            ActionButton( 
              onPressed: _onContinue,
              text: 'Continue',
              icon: Icons.arrow_forward,
            ),
            
          ],
        ),
      ),
    );
  }
}
