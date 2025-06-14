import 'package:flutter/material.dart';

class TimeFilterChips extends StatelessWidget {
  final List<String> filters;
  final String? selectedFilter;
  final ValueChanged<String?> onFilterSelected;
  final Color primaryColor;

  const TimeFilterChips({
    Key? key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.primaryColor = const Color(0xFF5E55FF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: filters.map((f) {
        final selected = selectedFilter == f;
        return Container(
          margin: const EdgeInsets.only(right: 14),
          child: ChoiceChip(
            label: Text(f),
            selected: selected,
            selectedColor: primaryColor,
            backgroundColor: Colors.grey[200],
            labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
            onSelected: (sel) => onFilterSelected(sel ? f : null),
          ),
        );
      }).toList(),
    );
  }
}
