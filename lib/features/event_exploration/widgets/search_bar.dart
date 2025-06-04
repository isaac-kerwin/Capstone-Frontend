import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onFilter;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onSubmitted,
    required this.onClear,
    required this.onFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search events...',
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
                onPressed: onClear,
              ),
            IconButton(
              icon: const Icon(Icons.filter_alt, color: Colors.white),
              onPressed: onFilter,
            ),
          ],
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.white54),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      style: const TextStyle(color: Colors.white),
      onSubmitted: onSubmitted,
    );
  }
}
