import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/category_selector.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/time_filter_chips.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/date_range_picker_tile.dart';

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
          CategorySelector(
            selectedCategory: selectedCategory,
            categories: categories,
            onCategoryTap: (cat) => setState(() => selectedCategory = cat),
            primaryColor: primaryColor,
          ),

          const SizedBox(height: 36),

          // Time & Date
          const Text('Time & Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Time chips
          TimeFilterChips(
            filters: timeFilters,
            selectedFilter: selectedTimeFilter,
            onFilterSelected: (f) => setState(() {
              selectedTimeFilter = f;
              // reset date when using time filter
              if (f != null) {
                final now = DateTime.now();
                switch (f) {
                  case 'Today':
                    startDate = DateTime(now.year, now.month, now.day);
                    endDate = startDate!.add(const Duration(hours: 23, minutes: 59, seconds: 59));
                    break;
                  case 'Tomorrow':
                    startDate = DateTime(now.year, now.month, now.day + 1);
                    endDate = startDate!.add(const Duration(hours: 23, minutes: 59, seconds: 59));
                    break;
                  case 'This week':
                    startDate = DateTime(now.year, now.month, now.day);
                    final daysLeft = DateTime.daysPerWeek - now.weekday;
                    endDate = DateTime(now.year, now.month, now.day + daysLeft, 23, 59, 59);
                    break;
                }
              } else {
                startDate = endDate = null;
              }
            }),
            primaryColor: primaryColor,
          ),

          const SizedBox(height: 24),

          // Date range picker
          DateRangePickerTile(
            startDate: startDate,
            endDate: endDate,
            onTap: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDateRange: startDate != null && endDate != null
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