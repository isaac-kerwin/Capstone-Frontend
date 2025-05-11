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
  File? _image;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.event.name;
    capacityController.text = widget.event.capacity.toString();
    descriptionController.text = widget.event.description;
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
        print("Selected Image Path: ${_image!.path}");
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> saveChanges() async {
    try {
      final updatedEvent = UpdateEventDTO(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        location: widget.event.location,
        capacity: int.parse(capacityController.text),
        eventType: widget.event.eventType,
        startDateTime: widget.event.startDateTime,
        endDateTime: widget.event.endDateTime,
      );

      await updateEvent(widget.event.id, updatedEvent);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event updated successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update event: $e")),
      );
    }
  }

  void cancelChanges() {
    setState(() {
      nameController.clear();
      capacityController.clear();
      descriptionController.clear();
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
          color: Colors.blue,
          onPressed: saveChanges,
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
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
      appBar: AppBar(title: const Text("Edit Event Details")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(label: "Edit Event Name", controller: nameController),
              const SizedBox(height: 15),
              _buildTextField(
                label: "Edit Maximum Capacity",
                controller: capacityController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: "Edit Description",
                controller: descriptionController,
                maxLines: 3,
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