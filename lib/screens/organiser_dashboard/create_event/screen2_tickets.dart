import 'package:flutter/material.dart';
import 'package:first_app/models/tickets.dart';
import 'package:first_app/widgets/create_ticket.dart';
import 'package:first_app/screens/organiser_dashboard/create_event/screen3_bank_info.dart';

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
  Future<DateTime?> _pickDate(DateTime? initialDate) async {
    DateTime now = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
  }

  Future<void> _selectSalesStart() async {
    final DateTime? picked = await _pickDate(salesStart);
    if (picked != null) {
      setState(() {
        salesStart = picked;
      });
    }
  }

  Future<void> _selectSalesEnd() async {
    final DateTime? picked = await _pickDate(salesEnd ?? salesStart);
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
        builder: (context) => EditBankInformationPage( eventData: widget.eventData,),
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
        ElevatedButton(
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
            ElevatedButton(
              onPressed: _openCreateTicketDialog,
              child: const Text('Add Ticket'),
            ),
            const SizedBox(height: 16),
            // List of tickets
            Expanded(child: _buildTicketList()),
            ElevatedButton( 
              onPressed: _onContinue,
              child: const Text('Continue'),
            ),
            
          ],
        ),
      ),
    );
  }
}
