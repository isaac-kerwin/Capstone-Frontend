import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_mobile_frontend/models/tickets.dart';
import 'package:app_mobile_frontend/models/event.dart';
import 'package:app_mobile_frontend/network/event.dart';

class TicketManagementPage extends StatefulWidget {
  final EventDetails event;
  
  const TicketManagementPage({super.key, required this.event});

  @override
  State<TicketManagementPage> createState() => _TicketManagementPageState();
}

class _TicketManagementPageState extends State<TicketManagementPage> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _salesStart;
  DateTime? _salesEnd;

  bool _isEditing = false;
  int? _editingIndex;

  List<Ticket> _tickets = [];

  @override
  void initState() {
    super.initState();
    _tickets = List.from(widget.event.tickets);
  }

  void _startEditing(int index) {
    final ticket = _tickets[index];
    setState(() {
      _isEditing = true;
      _editingIndex = index;
      _priceController.text = ticket.price;
      _quantityController.text = ticket.quantityTotal.toString();
      _nameController.text = ticket.name;
      _descriptionController.text = ticket.description;
      _salesStart = ticket.salesStart;
      _salesEnd = ticket.salesEnd;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _editingIndex = null;
      _clearControllers();
    });
  }

  void _clearControllers() {
    _priceController.clear();
    _quantityController.clear();
    _nameController.clear();
    _descriptionController.clear();
    _salesStart = null;
    _salesEnd = null;
  }

  Future<void> _pickDateTime(bool isStart) async {
    DateTime now = DateTime.now();
    late DateTime firstDate;
    late DateTime lastDate;

    // Get event start date for validation
    final eventStart = widget.event.startDateTime;
    DateTime eventStartDate = eventStart is DateTime
        ? eventStart
        : DateTime.tryParse(eventStart.toString()) ?? DateTime(now.year + 5);

    if (isStart) {
      firstDate = DateTime(now.year, now.month, now.day);
      lastDate = _salesEnd != null && _salesEnd!.isBefore(eventStartDate)
          ? _salesEnd!
          : eventStartDate.subtract(const Duration(days: 1));
    } else {
      firstDate = _salesStart != null
          ? _salesStart!.add(const Duration(days: 1))
          : DateTime(now.year, now.month, now.day);
      lastDate = eventStartDate.subtract(const Duration(days: 0));
    }

    // Prevent invalid range
    if (lastDate.isBefore(firstDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isStart
              ? 'No valid start dates available before event start.'
              : 'No valid end dates available after ticket start and before event start.'),
        ),
      );
      return;
    }

    // Ensure initialDate is valid
    DateTime initialDate;
    if (isStart) {
      initialDate = (_salesStart != null && _salesStart!.isAfter(firstDate)) ? _salesStart! : firstDate;
      if (initialDate.isAfter(lastDate)) initialDate = lastDate;
    } else {
      initialDate = (_salesEnd != null && _salesEnd!.isAfter(firstDate)) ? _salesEnd! : firstDate;
      if (initialDate.isAfter(lastDate)) initialDate = lastDate;
    }

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          final DateTime dateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          if (isStart) {
            _salesStart = dateTime;
            // If end is before new start, clear end
            if (_salesEnd != null && _salesEnd!.isBefore(_salesStart!)) {
              _salesEnd = null;
            }
          } else {
            _salesEnd = dateTime;
          }
        });
      }
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Not selected';
    return '${dateTime.toLocal().toString().split(' ')[0]} '
        '${TimeOfDay.fromDateTime(dateTime).format(context)}';
  }

  Future<void> _saveTicket() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _salesStart == null ||
        _salesEnd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    if (_salesEnd!.isBefore(_salesStart!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sales end date must be after start date')),
      );
      return;
    }

    try {
      List<TicketDTO> tickets = [];
      final ticket = TicketDTO(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        quantityTotal: int.parse(_quantityController.text),
        salesStart: _salesStart!,
        salesEnd: _salesEnd!,
      );
      tickets.add(ticket);

      if (_isEditing) {
        // Update existing ticket
        UpdateEventDTO ticketUpdate = UpdateEventDTO(
          tickets: tickets,
        );
        await updateEvent(widget.event.id, ticketUpdate);
        setState(() {
          _tickets[_editingIndex!] = Ticket(
            id: _tickets[_editingIndex!].id,
            eventId: widget.event.id,
            name: ticket.name,
            description: ticket.description,
            price: ticket.price.toString(),
            quantityTotal: ticket.quantityTotal,
            quantitySold: _tickets[_editingIndex!].quantitySold,
            salesStart: ticket.salesStart,
            salesEnd: ticket.salesEnd,
            status: _tickets[_editingIndex!].status,
            createdAt: _tickets[_editingIndex!].createdAt,
            updatedAt: DateTime.now(),
          );
        });
      } else {
        // Create new ticket
        final newTicket = await createTicket(widget.event.id, ticket);
        setState(() {
          _tickets.add(newTicket);
        });
      }

      _cancelEditing();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Ticket updated successfully!' : 'Ticket added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteTicket(int index) async {
    try {
      await deleteTicket(widget.event.id, _tickets[index].id);
      setState(() {
        _tickets.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting ticket: $e')),
      );
    }
  }

  Widget _buildTicketForm() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Ticket Name',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Description (Optional)',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          decoration: const InputDecoration(
            labelText: 'Price (\$)',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Quantity',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _pickDateTime(true),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sales Start: ${_formatDateTime(_salesStart)}'),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _pickDateTime(false),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sales End: ${_formatDateTime(_salesEnd)}'),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            if (_isEditing)
              Expanded(
                child: ElevatedButton(
                  onPressed: _cancelEditing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (_isEditing) const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A55FF),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Update Ticket' : 'Add Ticket',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTicketList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _tickets.length,
      itemBuilder: (context, index) {
        final ticket = _tickets[index];
        final canDelete = _tickets.length > 1; // Prevent deleting last ticket
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
                Text('Sales Period: ${_formatDateTime(ticket.salesStart)} - ${_formatDateTime(ticket.salesEnd)}'),
                if (ticket.description.isNotEmpty)
                  Text('Description: ${ticket.description}'),
                Text('Status: ${ticket.status}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _startEditing(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: canDelete
                      ? () => _deleteTicket(index)
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('At least one ticket is required. You cannot delete the last ticket.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Management'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditing ? 'Edit Ticket' : 'Add New Ticket',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTicketForm(),
              const SizedBox(height: 24),
              const Text(
                'Existing Tickets',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTicketList(),
            ],
          ),
        ),
      ),
    );
  }
}
