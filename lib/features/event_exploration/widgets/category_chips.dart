import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final String? activeCategory;
  final ValueChanged<String> onSelect;

  const CategoryChips({Key? key, required this.activeCategory, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': 'Sports', 'icon': Icons.sports_basketball, 'color': activeCategory == 'Sports' ? const Color(0xFF5E55FF) : Colors.orange},
      {'label': 'Music', 'icon': Icons.music_note, 'color': activeCategory == 'Music' ? const Color(0xFF5E55FF) : Colors.redAccent},
      {'label': 'Social', 'icon': Icons.people, 'color': activeCategory == 'Social' ? const Color(0xFF5E55FF) : Colors.green},
      {'label': 'Volunteering', 'icon': Icons.volunteer_activism, 'color': activeCategory == 'Volunteering' ? const Color(0xFF5E55FF) : Colors.blue},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: categories.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () => onSelect(cat['label'] as String),
                child: Chip(
                  avatar: Icon(cat['icon'] as IconData, size: 16, color: Colors.white),
                  label: Text(cat['label'] as String),
                  backgroundColor: cat['color'] as Color,
                  labelStyle: const TextStyle(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
