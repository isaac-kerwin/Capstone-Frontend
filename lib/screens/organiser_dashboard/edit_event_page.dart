import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class EditEventPage extends StatefulWidget {
  const EditEventPage({Key? key}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image;

 Future<void> _pickImage() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false, 
      withData: false, // This ensures the path is directly available
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
      print("Selected Image Path: ${_image!.path}");
    } else {
      print("No image selected.");
    }
  } catch (e) {
    print("Error picking image: $e");
  }
}



  void saveChanges() {
    print("Event Name: ${nameController.text}");
    print("Capacity: ${capacityController.text}");
    print("Description: ${descriptionController.text}");
    if (_image != null) {
      print("Image Selected: ${_image!.path}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Event Details")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Edit Event Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: capacityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Edit Maximum Capacity",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Edit Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
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
                        : Image.file(_image!, height: 100, width: 100, fit: BoxFit.cover),
                    const SizedBox(height: 5),
                    const Text("Tap to select an image"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: cancelChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text("Cancel Changes"),
                ),
                ElevatedButton(
                  onPressed: saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text("Save Changes"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
