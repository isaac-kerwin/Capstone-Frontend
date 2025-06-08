import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerTile extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const ImagePickerTile({Key? key, required this.image, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            image == null
                ? const Text("Upload Image")
                : Image.file(
                    image!,
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
}
