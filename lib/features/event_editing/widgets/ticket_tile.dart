import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/core/models/tickets.dart'; // Assuming Ticket model is here

typedef TicketActionCallback = void Function();

class TicketTile extends StatelessWidget {
  final Ticket ticket;
  final bool canDelete;
  final TicketActionCallback onEdit;
  final TicketActionCallback onDelete;
  // Assuming _formatDateTime is available or passed, or dates are pre-formatted
  // For simplicity, let's assume salesStartFormatted and salesEndFormatted are passed
  // Or, we can include a simple formatter here if context is not strictly needed for it.

  const TicketTile({
    super.key,
    required this.ticket,
    required this.canDelete,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDateTime(BuildContext context, DateTime? dateTime) {
    if (dateTime == null) return 'Not set';
    return '${dateTime.toLocal().toString().split(' ')[0]} '
        '${TimeOfDay.fromDateTime(dateTime).format(context)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          ticket.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${ticket.price}'),
            Text('Quantity: ${ticket.quantityTotal} (${ticket.quantitySold} sold)'),
            Text('Sales Period: ${_formatDateTime(context, ticket.salesStart)} - ${_formatDateTime(context, ticket.salesEnd)}'),
            if (ticket.description.isNotEmpty)
              Text('Description: ${ticket.description}'),
            Text('Status: ${ticket.status}'), // Assuming status is a string
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: canDelete ? Colors.red : Colors.grey),
              onPressed: canDelete ? onDelete : null,
              tooltip: canDelete ? 'Delete' : (ticket.quantitySold > 0 ? 'Cannot delete ticket with sales' : 'Cannot delete last ticket'),
            ),
          ],
        ),
      ),
    );
  }
}
