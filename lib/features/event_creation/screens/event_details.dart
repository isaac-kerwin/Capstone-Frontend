import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/features/event_creation/screens/event_tickets.dart';
import 'package:app_mobile_frontend/core/widgets/form_widgets.dart';
import 'package:app_mobile_frontend/core/models/ticket_models.dart';
import 'package:app_mobile_frontend/features/event_creation/screens/event_common_questions.dart';

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
  String? _selectedEventType;
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  bool _isFree = false;

  // Helper method to format date/time nicely
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Not selected';
    return '${dateTime.toLocal().toString().split(' ')[0]} '
        '${TimeOfDay.fromDateTime(dateTime).format(context)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Event Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField(label: 'Event Name', controller: _eventNameController),
            const SizedBox(height: 16),
            buildTextField(label: 'Location', controller: _locationController),
            const SizedBox(height: 16),
            buildTextField(label: 'Description', controller: _descriptionController, maxLines: 3),
            const SizedBox(height: 16),
            buildTextField(label: 'Capacity', controller: _capacityController, isNumber: true),
            const SizedBox(height: 20),
            _buildEventTypeDropdown(),
            const SizedBox(height: 20),
            _buildDateTimeRow(
              label: 'Starts on: ${_formatDateTime(_startDateTime)}',
              onPressed: () => _pickDateTime(isStart: true),
            ),
            const SizedBox(height: 20),
            _buildDateTimeRow(
              label: 'Ends on: ${_formatDateTime(_endDateTime)}',
              onPressed: () => _pickDateTime(isStart: false),
            ),
            const SizedBox(height: 20),
            _buildIsFreeSwitch(),
            const SizedBox(height: 20),
            _buildPhotoUploadButton(),
            const SizedBox(height: 40), 
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTypeDropdown() {
    const List<DropdownMenuEntry<String>> items = [
      DropdownMenuEntry(value: 'SPORTS', label: 'SPORTS'),
      DropdownMenuEntry(value: 'MUSICAL', label: 'MUSIC'),
      DropdownMenuEntry(value: 'SOCIAL', label: 'SOCIAL'),
      DropdownMenuEntry(value: 'VOLUNTEERING', label: 'VOLUNTEERING'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        buildDropdownMenu(
          items: items,
          onSelected: (value) {
            setState(() {
              _selectedEventType = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeRow({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.split(':')[0] + ':',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                label.split(':')[1].trim(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: onPressed,
              child: const Text('Choose Date'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIsFreeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Is this a free event?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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

  Widget _buildPhotoUploadButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload photo from device',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {
            // Implement photo upload functionality
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload),
              SizedBox(width: 8),
              Text('Upload Photo'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onContinue,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final DateTime now = DateTime.now();
    final DateTime? current = isStart ? _startDateTime : _endDateTime;
    final DateTime? minDate = isStart ? DateTime(now.year, now.month, now.day + 1) : _startDateTime;
    final DateTime initialDate = current ?? (isStart ? minDate! : (minDate ?? now));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate ?? DateTime(now.year, now.month, now.day + 1),
      lastDate: DateTime(2030),
      selectableDayPredicate: isStart
          ? (date) => date.isAfter(DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1)))
          : null,
    );

    if (pickedDate == null) return;

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
    return [ticket];
  }

  void _onContinue() {
    final eventName = _eventNameController.text.trim();
    final description = _descriptionController.text.trim();
    final location = _locationController.text.trim();
    final capacity = int.tryParse(_capacityController.text.trim()) ?? 0;

    final now = DateTime.now();

    if (eventName.isEmpty ||
        description.isEmpty ||
        location.isEmpty ||
        _startDateTime == null ||
        _endDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields!')),
      );
      return;
    }

    if (_startDateTime!.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start date must be later than today!')),
      );
      return;
    }

    if (_endDateTime!.isBefore(_startDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date/time cannot be before start date/time!')),
      );
      return;
    }

    if (capacity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Capacity must be greater than 0!')),
      );
      return;
    }

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommonQuestions(eventData: eventData),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TicketManagementScreen(eventData: eventData),
        ),
      );
    }
  }
}