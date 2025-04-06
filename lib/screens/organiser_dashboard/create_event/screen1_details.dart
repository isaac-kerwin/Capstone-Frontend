import 'package:flutter/material.dart';
import 'package:first_app/screens/organiser_dashboard/create_event/screen2_tickets.dart';
import 'package:first_app/widgets/form_widgets.dart';
import 'package:first_app/widgets/action_button.dart';
import 'package:first_app/models/tickets.dart';
import 'package:first_app/screens/organiser_dashboard/create_event/screen4_questions.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  // Controllers
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  // State fields
  String? _selectedEventType = 'SPORTS';
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  bool _isFree = false;

  // Helper method to format date/time nicely
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Not selected';
    return '${dateTime.toLocal().toString().split(' ')[0]} '
        '${TimeOfDay.fromDateTime(dateTime).format(context)}';
  }

  /// ----------------------------------
  ///   Main build method
  /// ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField(label: 'Event Name', controller: _eventNameController),
            const SizedBox(height: 16),
            buildTextField(label: 'Location', controller: _locationController),
            const SizedBox(height: 16),
            buildTextField(label: 'Description', controller: _descriptionController),
            const SizedBox(height: 16),
            buildTextField(label: 'Capacity', controller: _capacityController, isNumber: true),
            const SizedBox(height: 16),
            _buildEventTypeDropdown(),
            const SizedBox(height: 16),
            _buildDateTimeRow(
              label: 'Starts on: ${_formatDateTime(_startDateTime)}',
              onPressed: () => _pickDateTime(isStart: true),
            ),
            const SizedBox(height: 16),
            _buildDateTimeRow(
              label: 'Ends on: ${_formatDateTime(_endDateTime)}',
              onPressed: () => _pickDateTime(isStart: false),
            ),
            const SizedBox(height: 16),
            _buildIsFreeSwitch(),
            const SizedBox(height: 24),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

// Build Widgets

  // Event Type Dropdown
  _buildEventTypeDropdown() {
    const List<DropdownMenuEntry<String>> items = [
      DropdownMenuEntry(value: 'SPORTS', label: 'SPORTS'),
      DropdownMenuEntry(value: 'MUSIC', label: 'MUSIC'  ),
      DropdownMenuEntry(value: 'FOOD', label: 'FOOD'    ),
      DropdownMenuEntry(value: 'ART', label: 'ART'      ),
    ];


    return buildDropdownMenu(
      items: items,
      onSelected: (value) {
        setState(() {
          _selectedEventType = value;
          });
        },
    );
  }

  // Date/Time picker row (label + button)
  Widget _buildDateTimeRow({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        TextButton(
          onPressed: onPressed,
          child: const Text('Choose Date'),
        ),
      ],
    );
  }

  // Free-event Switch
  Widget _buildIsFreeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Is this a free event?'),
        Switch(
          value: _isFree,
          onChanged: (value) {
            setState(() {
              _isFree = value;
            });
          },
        ),
      ],
    );
  }

  // Continue button
  Widget _buildContinueButton() {
    return ActionButton(
      onPressed: _onContinue,
      text: 'Continue',
      icon: Icons.arrow_forward,
    );
  }

// Date/Time picker logic

  Future<void> _pickDateTime({required bool isStart}) async {
    final DateTime now = DateTime.now();
    final DateTime? current = isStart ? _startDateTime : _endDateTime;
    final DateTime? minDate = isStart ? DateTime(2020) : _startDateTime;
    final DateTime initialDate = current ?? (isStart ? now : (minDate ?? now));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate ?? DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) return;

    // Show TimePicker
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current ?? now),
    );

    if (pickedTime == null) return;

    final newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isStart) {
        _startDateTime = newDateTime;
        if (_endDateTime != null && _endDateTime!.isBefore(_startDateTime!)) {
          _endDateTime = null;
        }
      } else {
        _endDateTime = newDateTime;
      }
    });
  }
List<TicketDTO> _createFreeTicket() {
      TicketDTO ticket = TicketDTO(
        name: 'Free Ticket',
        description: 'Free ticket for the event',
        price: 0.0,
        quantityTotal: int.parse(_capacityController.text.trim()),
        salesStart: _startDateTime!,
        salesEnd: _endDateTime!,
      );
      List <TicketDTO> tickets = [ticket];
      return tickets;
  }

  // Handle the Continue button press
  // Validate inputs and navigate to the next screen
// continue logic
  void _onContinue() {
    final eventName = _eventNameController.text.trim();
    final description = _descriptionController.text.trim();
    final location = _locationController.text.trim();
    final capacity = int.tryParse(_capacityController.text.trim()) ?? 0;

    // Basic validations
    if (eventName.isEmpty ||
        description.isEmpty ||
        location.isEmpty ||
        _startDateTime == null ||
        _endDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields!'),
        ),
      );
      return;
    }

    if (capacity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Capacity must be greater than 0!'),
        ),
      );
      return;
    }

    // Collect data
    final Map<String, dynamic> eventData = {
      'eventName': eventName,
      'description': description,
      'location': location,
      'type': _selectedEventType!,
      'capacity': capacity,
      'startDateTime': _startDateTime!,
      'endDateTime': _endDateTime!,
      'isFree': _isFree,
    };

    if (_isFree) {
      eventData['tickets'] = _createFreeTicket();
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => CreateEventQuestions(eventData: eventData),
        ),
      );
     // No tickets for free events
    } else {
      Navigator.push(
      context,
      MaterialPageRoute(
         builder: (context) => TicketManagementScreen(eventData: eventData)
      ),
    ); // Placeholder for ticket data
    }

    // Navigate to next screen

  }
}