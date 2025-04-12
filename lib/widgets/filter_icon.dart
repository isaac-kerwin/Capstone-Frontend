import 'package:flutter/material.dart';

class FilterIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const FilterIcon({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: isSelected
                ? Colors.deepPurple
                : Colors.deepPurple.withOpacity(0.1),
            child: Icon(icon, color: isSelected ? Colors.white : Colors.deepPurple),
          ),
          const SizedBox(height: 4),
          Text(label)
        ],
      ),
    );
  }
}
