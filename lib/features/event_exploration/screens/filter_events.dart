import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventFilterModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;
  const EventFilterModal({super.key, required this.onApplyFilters});

  @override
  State<EventFilterModal> createState() => _EventFilterModalState();
}

class _EventFilterModalState extends State<EventFilterModal> {
  // ─── filter state ────────────────────────────────────────────────
  String? selectedCategory;
  String? selectedTimeFilter;
  DateTime? startDate;
  DateTime? endDate;

  // ─── static data ────────────────────────────────────────────────
  final Color primaryColor = const Color(0xFF5E55FF);
  final List<Map<String, dynamic>> categories = [
    {'label': 'Sports',       'icon': Icons.sports_basketball},
    {'label': 'Music',        'icon': Icons.music_note},
    {'label': 'Social',       'icon': Icons.people},
    {'label': 'Volunteering', 'icon': Icons.volunteer_activism},
  ];
  final List<String> timeFilters = ['Today', 'Tomorrow', 'This week'];

  // ─── helpers ────────────────────────────────────────────────────
  void _resetAll() => setState(() {
        selectedCategory  = null;
        selectedTimeFilter = null;
        startDate         = null;
        endDate           = null;
      });

  void _apply() {
    widget.onApplyFilters({
      'category'   : selectedCategory,
      'timeFilter' : selectedTimeFilter,
      'startDate'  : startDate,
      'endDate'    : endDate,
    });
    Navigator.pop(context);
  }

  // ─── build ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // drag-handle & title
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 28),
              decoration: BoxDecoration(
                color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const Text('Filter Events',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),

          // Categories
          Wrap(
            spacing: 18, runSpacing: 18,
            children: categories.map((cat) {
              final selected = selectedCategory == cat['label'];
              return GestureDetector(
                onTap: () => setState(() => selectedCategory =
                    selected ? null : cat['label'] as String),
                child: Column(children: [
                  Container(
                    width: 54, height: 54,
                    decoration: BoxDecoration(
                      color: selected ? primaryColor : Colors.grey[300],
                      shape: BoxShape.circle),
                    child: Icon(cat['icon'], color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 10),
                  Text(cat['label'],
                    style: TextStyle(fontSize: 13,
                        color: selected ? Colors.black : Colors.grey[600])),
                ]),
              );
            }).toList(),
          ),

          const SizedBox(height: 36),

          // Time & Date
          const Text('Time & Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Time chips
          Row(
            children: timeFilters.map((f) {
              final selected = selectedTimeFilter == f;
              return Container(
                margin: const EdgeInsets.only(right: 14),
                child: ChoiceChip(
                  label: Text(f),
                  selected: selected,
                  selectedColor: primaryColor,
                  backgroundColor: Colors.grey[200],
                  labelStyle:
                      TextStyle(color: selected ? Colors.white : Colors.black),
                  onSelected: (sel) => setState(() {
                    if (sel) {
                      selectedTimeFilter = f;
                      final now = DateTime.now();
                      switch (f) {
                        case 'Today':
                          startDate = DateTime(now.year, now.month, now.day);
                          endDate   = startDate!.add(const Duration(hours: 23, minutes: 59, seconds: 59));
                          break;
                        case 'Tomorrow':
                          startDate = DateTime(now.year, now.month, now.day + 1);
                          endDate   = startDate!.add(const Duration(hours: 23, minutes: 59, seconds: 59));
                          break;
                        case 'This week':
                          startDate = DateTime(now.year, now.month, now.day);
                          final daysLeft = DateTime.daysPerWeek - now.weekday;
                          endDate = DateTime(now.year, now.month, now.day + daysLeft, 23, 59, 59);
                          break;
                      }
                    } else {
                      selectedTimeFilter = null;
                      startDate = endDate = null;
                    }
                  }),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Date range picker
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: startDate != null ? primaryColor : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.calendar_today,
                    color: startDate != null ? Colors.white : Colors.grey),
              ),
              title: Text(startDate != null
                      ? '${DateFormat('MM/dd/yyyy').format(startDate!)} - '
                        '${DateFormat('MM/dd/yyyy').format(endDate!)}'
                      : 'Enter Date Range'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialDateRange: startDate != null
                      ? DateTimeRange(start: startDate!, end: endDate!)
                      : null,
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: primaryColor,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) {
                  setState(() {
                    startDate = picked.start;
                    endDate   = picked.end;
                    selectedTimeFilter = null;
                  });
                }
              },
            ),
          ),

          const Spacer(),

          // Buttons
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _resetAll,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('RESET',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              )),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('APPLY',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}