import 'package:flutter/material.dart';

class FilterIndicator extends StatelessWidget {
  final String label;
  final VoidCallback onClear;

  const FilterIndicator({Key? key, required this.label, required this.onClear}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 16, color: Color(0xFF5E55FF)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF5E55FF))),
          const Spacer(),
          TextButton(
            onPressed: onClear,
            child: const Text('Clear', style: TextStyle(color: Color(0xFF5E55FF))),
          ),
        ],
      ),
    );
  }
}
