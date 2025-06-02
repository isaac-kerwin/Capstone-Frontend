import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePickerTile extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Color primaryColor;
  final VoidCallback onTap;

  const DateRangePickerTile({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onTap,
    this.primaryColor = const Color(0xFF5E55FF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final display = startDate != null && endDate != null
        ? '${DateFormat('MM/dd/yyyy').format(startDate!)} - ${DateFormat('MM/dd/yyyy').format(endDate!)}'
        : 'Enter Date Range';

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: startDate != null ? primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.calendar_today,
          color: startDate != null ? Colors.white : Colors.grey,
        ),
      ),
      title: Text(display),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
