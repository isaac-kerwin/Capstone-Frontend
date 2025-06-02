import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:app_mobile_frontend/features/event_management/widgets/event_text_field.dart';
import 'package:app_mobile_frontend/features/event_management/widgets/date_time_row.dart';
import 'package:app_mobile_frontend/features/event_management/widgets/image_picker_tile.dart';

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
              EventTextField(label: "Event Name", controller: nameController),
              const SizedBox(height: 15),
              EventTextField(label: "Location", controller: locationController),
              const SizedBox(height: 15),
              EventTextField(
                label: "Maximum Capacity",
                controller: capacityController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              EventTextField(
                label: "Description",
                controller: descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 15),
              DateTimeRow(
                label: 'Starts on: ${_startDateTime != null ? _startDateTime!.toLocal().toString().split(' ').first + ' ' + TimeOfDay.fromDateTime(_startDateTime!).format(context) : 'Not selected'}',
                onTap: () => _pickDateTime(true),
              ),
              const SizedBox(height: 15),
              DateTimeRow(
                label: 'Ends on: ${_endDateTime != null ? _endDateTime!.toLocal().toString().split(' ').first + ' ' + TimeOfDay.fromDateTime(_endDateTime!).format(context) : 'Not selected'}',
                onTap: () => _pickDateTime(false),
              ),
              const SizedBox(height: 15),
              ImagePickerTile(image: _image, onTap: _pickImage),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: cancelChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Cancel Changes'),
                  ),
                  ElevatedButton(
                    onPressed: saveChanges,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}