import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_mobile_frontend/core/models/tickets.dart';
import 'package:app_mobile_frontend/core/models/event.dart';
import 'package:app_mobile_frontend/network/event_services.dart';
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
      List<TicketDTO> ticketsDto = []; // Changed variable name for clarity
      final ticketDto = TicketDTO( // Changed variable name for clarity
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        quantityTotal: int.parse(_quantityController.text),
        salesStart: _salesStart!,
        salesEnd: _salesEnd!,
      );
      ticketsDto.add(ticketDto);

      if (_isEditing) {
        // Update existing ticket
        UpdateEventDTO ticketUpdate = UpdateEventDTO(
          tickets: ticketsDto,
        );
        // Assuming updateEvent can handle updating a single ticket by its ID or requires the full list.
        // The current DTO structure suggests it might be replacing/updating tickets based on the list.
        // For simplicity, we'll assume the backend handles matching or that this is the intended update mechanism.
        await updateEvent(widget.event.id, ticketUpdate); 
        setState(() {
          _tickets[_editingIndex!] = Ticket(
            id: _tickets[_editingIndex!].id, // Keep existing ID
            eventId: widget.event.id,
            name: ticketDto.name,
            description: ticketDto.description,
            price: ticketDto.price.toString(), // Ticket model expects string price
            quantityTotal: ticketDto.quantityTotal,
            quantitySold: _tickets[_editingIndex!].quantitySold, // Preserve sold quantity
            salesStart: ticketDto.salesStart,
            salesEnd: ticketDto.salesEnd,
            status: _tickets[_editingIndex!].status, // Preserve status
            createdAt: _tickets[_editingIndex!].createdAt, // Preserve creation date
            updatedAt: DateTime.now(), // Update modification date
          );
        });
      } else {
        // Create new ticket
        final newTicket = await createTicket(widget.event.id, ticketDto);
        setState(() {
          _tickets.add(newTicket);
        });
      }

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
