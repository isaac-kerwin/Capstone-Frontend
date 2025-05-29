// date-time picker
// Navigation Button
// Switch 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

Widget buildTextField({
  required String label,
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
  int? maxLines = 1,
  bool obscureText = false,
  bool isNumber = false,
  String? Function(String?)? validator,
  void Function(String?)? onSaved,
  void Function(String)? onChanged,

  }) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    obscureText: obscureText,
    inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
    onChanged: onChanged,
    onSaved: onSaved,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );
}

Widget buildDropdownMenu({
  String? hint,
  String? initialSelection,
  required List<DropdownMenuEntry<String>> items,
  required ValueChanged<String?> onSelected,
}) {

   final String currentSelection = initialSelection ?? items.first.value;
    return DropdownMenu<String>(
      hintText: hint ?? 'Select an option',
      initialSelection: currentSelection,
      dropdownMenuEntries: items,
      onSelected: onSelected,
    );
}
