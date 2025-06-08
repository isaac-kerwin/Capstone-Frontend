import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final List<Map<String, dynamic>> categories;
  final ValueChanged<String?> onCategoryTap;
  final Color primaryColor;

  const CategorySelector({
    Key? key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryTap,
    this.primaryColor = const Color(0xFF5E55FF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: categories.map((cat) {
        final label = cat['label'] as String;
        final icon = cat['icon'] as IconData;
        final selected = selectedCategory == label;
        return GestureDetector(
          onTap: () => onCategoryTap(selected ? null : label),
          child: Column(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: selected ? primaryColor : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: selected ? Colors.black : Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
