import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:app_mobile_frontend/models/event.dart';
import 'package:app_mobile_frontend/network/event.dart';

class EditEventPage extends StatefulWidget {
  final EventDetails event;

  const EditEventPage({super.key, required this.event});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? _selectedEventType;
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  File? _image;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.event.name;
    capacityController.text = widget.event.capacity.toString();
    descriptionController.text = widget.event.description;
    locationController.text = widget.event.location;
    _selectedEventType = widget.event.eventType;
    _startDateTime = widget.event.startDateTime;
    _endDateTime = widget.event.endDateTime;
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() => _image = File(result.files.single.path!));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  Future<void> _pickDateTime(bool isStart) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDateTime ?? DateTime.now() : _endDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
            _startDateTime = dateTime;
          } else {
            _endDateTime = dateTime;
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

  Future<void> saveChanges() async {
    if (_startDateTime == null || _endDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both start and end dates")),
      );
      return;
    }

    if (_endDateTime!.isBefore(_startDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End date must be after start date")),
      );
      return;
    }

    try {
      final updatedEvent = UpdateEventDTO(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        location: locationController.text.trim(),
        capacity: int.parse(capacityController.text),
        eventType: _selectedEventType!,
        startDateTime: _startDateTime!,
        endDateTime: _endDateTime!,
      );

      await updateEvent(widget.event.id, updatedEvent);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event updated successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update event: $e")),
        );
      }
    }
  }

  void cancelChanges() {
    setState(() {
      nameController.text = widget.event.name;
      capacityController.text = widget.event.capacity.toString();
      descriptionController.text = widget.event.description;
      locationController.text = widget.event.location;
      _selectedEventType = widget.event.eventType;
      _startDateTime = widget.event.startDateTime;
      _endDateTime = widget.event.endDateTime;
      _image = null;
    });
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }


  Widget _buildDateTimeRow({
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
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
            Text(label),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            _image == null
                ? const Text("Upload Image")
                : Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(height: 5),
            const Text("Tap to select an image"),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton(
          text: "Cancel Changes",
          color: Colors.red,
          onPressed: cancelChanges,
        ),
        _buildButton(
          text: "Save Changes",
          onPressed: saveChanges,
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(label: "Event Name", controller: nameController),
              const SizedBox(height: 15),
              _buildTextField(label: "Location", controller: locationController),
              const SizedBox(height: 15),
              _buildTextField(
                label: "Maximum Capacity",
                controller: capacityController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: "Description",
                controller: descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 15),
              _buildDateTimeRow(
                label: 'Starts on: ${_formatDateTime(_startDateTime)}',
                onPressed: () => _pickDateTime(true),
              ),
              const SizedBox(height: 15),
              _buildDateTimeRow(
                label: 'Ends on: ${_formatDateTime(_endDateTime)}',
                onPressed: () => _pickDateTime(false),
              ),
              const SizedBox(height: 15),
              _buildImagePicker(),
              const SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}