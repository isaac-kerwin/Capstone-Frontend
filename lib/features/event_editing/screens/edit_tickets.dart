import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/core/models/ticket_models.dart';
import 'package:app_mobile_frontend/core/models/event_models.dart';
import 'package:app_mobile_frontend/api/event_services.dart';
import 'package:app_mobile_frontend/api/ticket_services.dart';
import 'package:app_mobile_frontend/features/event_editing/widgets/ticket_tile.dart';
import 'package:app_mobile_frontend/features/event_editing/widgets/ticket_form.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload tickets when the screen is reopened
    _loadTickets();
  }

  @override
  void initState() {
    super.initState();
    // Initialize ticket list from backend
    _loadTickets();
  }

  // Reload the latest tickets from backend
  Future<void> _loadTickets() async {
    try {
      final event = await getEventById(widget.event.id);
      setState(() {
        _tickets = event.tickets;
      });
    } catch (e) {
      // optionally show error
      debugPrint('Failed to load tickets: $e');
    }
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
    DateTime eventStartDate = widget.event.startDateTime; // Corrected: Assuming widget.event.startDateTime is DateTime

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
      final ticketDto = TicketDTO(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        quantityTotal: int.parse(_quantityController.text),
        salesStart: _salesStart!,
        salesEnd: _salesEnd!,
      );

      if (_isEditing) {
        final idx = _editingIndex!;
        final ticketId = _tickets[idx].id;
        // update backend with event and ticket IDs
        await updateTicket(widget.event.id, ticketId, ticketDto);
      } else {
        // Create new ticket
        await createTicket(widget.event.id, ticketDto);
      }

      // Refresh ticket list
      await _loadTickets();
      _cancelEditing(); // Clears form and resets editing state
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
      // Refresh ticket list
      await _loadTickets();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting ticket: $e')),
      );
    }
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
              TicketForm(
                nameController: _nameController,
                descriptionController: _descriptionController,
                priceController: _priceController,
                quantityController: _quantityController,
                salesStart: _salesStart,
                salesEnd: _salesEnd,
                pickDateTime: _pickDateTime,
                saveTicket: _saveTicket,
                cancelEditing: _isEditing ? _cancelEditing : null,
                isEditing: _isEditing,
              ),
              const SizedBox(height: 24),
              const Text(
                'Existing Tickets',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tickets.length,
                itemBuilder: (context, index) {
                  final ticket = _tickets[index];
                  // Logic for canDelete moved here to pass to TicketTile
                  final bool canDelete = _tickets.length > 1 && ticket.quantitySold == 0;
                  return TicketTile(
                    ticket: ticket,
                    canDelete: canDelete,
                    onEdit: () => _startEditing(index),
                    onDelete: () {
                      if (canDelete) {
                        _deleteTicket(index);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ticket.quantitySold > 0
                                ? 'Cannot delete ticket with existing registrations.'
                                : 'At least one ticket is required. You cannot delete the last ticket.'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
