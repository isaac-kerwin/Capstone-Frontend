import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventFilterModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const EventFilterModal({
    Key? key,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _EventFilterModalState createState() => _EventFilterModalState();
}

class _EventFilterModalState extends State<EventFilterModal> {
  // Filter state variables
  String? selectedCategory;
  String? selectedTimeFilter;
  RangeValues priceRange = const RangeValues(20, 120);
  String location = "Melbourne, Vic";
  DateTime? startDate;
  DateTime? endDate;
  
  // Available locations in Australia
  final List<String> australianLocations = [
    "Melbourne, Vic",
    "Sydney, NSW",
    "Brisbane, QLD",
    "Perth, WA",
    "Adelaide, SA",
    "Hobart, TAS",
    "Darwin, NT",
    "Canberra, ACT",
    "Gold Coast, QLD",
    "Newcastle, NSW",
  ];
  
  // Category options with icon data
  final List<Map<String, dynamic>> categories = [
    {'label': 'Sports', 'icon': Icons.sports_basketball, 'color': Colors.grey},
    {'label': 'Music', 'icon': Icons.music_note, 'color': Colors.grey},
    {'label': 'Social', 'icon': Icons.people, 'color': Colors.grey},
    {'label': 'Volunteering', 'icon': Icons.volunteer_activism, 'color': Colors.grey},
  ];

  // Time filter options
  final List<String> timeFilters = ["Today", "Tomorrow", "This week"];

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF5E55FF);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Filter Events",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Categories
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categories.map((category) {
              final bool isSelected = selectedCategory == category['label'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedCategory = null;
                    } else {
                      selectedCategory = category['label'];
                    }
                  });
                },
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? primaryColor
                            : category['color'] == Colors.blue 
                                ? primaryColor
                                : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category['icon'],
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['label'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.black : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Time & Date
          const Text(
            "Time & Date",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Time filter chips
          Row(
            children: timeFilters.map((filter) {
              final bool isSelected = selectedTimeFilter == filter;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  selectedColor: primaryColor,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedTimeFilter = filter;
                        // Set start and end dates based on the selected time filter
                        final now = DateTime.now();
                        switch (filter) {
                          case "Today":
                            startDate = DateTime(now.year, now.month, now.day);
                            endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
                            break;
                          case "Tomorrow":
                            startDate = DateTime(now.year, now.month, now.day + 1);
                            endDate = DateTime(now.year, now.month, now.day + 1, 23, 59, 59);
                            break;
                          case "This week":
                            startDate = DateTime(now.year, now.month, now.day);
                            // Calculate days until end of week (assuming Sunday is end of week)
                            final daysUntilEndOfWeek = DateTime.daysPerWeek - now.weekday;
                            endDate = DateTime(now.year, now.month, now.day + daysUntilEndOfWeek, 23, 59, 59);
                            break;
                        }
                      } else {
                        selectedTimeFilter = null;
                        startDate = null;
                        endDate = null;
                      }
                    });
                  },
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 12),
          
          // Date range picker
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: startDate != null ? primaryColor : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today, 
                  color: startDate != null ? Colors.white : Colors.grey
                ),
              ),
              title: Text(
                startDate != null && endDate != null
                    ? "${DateFormat('MM/dd/yyyy').format(startDate!)} - ${DateFormat('MM/dd/yyyy').format(endDate!)}"
                    : "Enter Date Range"
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                // Show date range picker
                final DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialDateRange: startDate != null && endDate != null
                      ? DateTimeRange(start: startDate!, end: endDate!)
                      : null,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: primaryColor,
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                
                if (picked != null) {
                  setState(() {
                    startDate = picked.start;
                    endDate = picked.end;
                    // Clear time filter if date range is manually set
                    selectedTimeFilter = null;
                  });
                }
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Location
          const Text(
            "Location",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Location picker
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor, // Always highlight location icon
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.location_on_outlined, color: Colors.white),
              ),
              title: Text(location),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show location selection dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Select Location"),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: australianLocations.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(australianLocations[index]),
                              onTap: () {
                                setState(() {
                                  location = australianLocations[index];
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Price range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Select price range",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "\$${priceRange.start.round()}-\$${priceRange.end.round()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Price slider with updated style to match the design
          Container(
            height: 40, // Add fixed height for better control
            child: SliderTheme(
              data: SliderThemeData(
                // Track style
                trackHeight: 4,
                activeTrackColor: primaryColor,
                inactiveTrackColor: Colors.grey[300],
                
                // Thumb style
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 10,
                  elevation: 4,
                  pressedElevation: 8,
                ),
                
                // Overlay style
                overlayColor: primaryColor.withOpacity(0.2),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                
                // Range slider specific
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  enabledThumbRadius: 10,
                  elevation: 4,
                  pressedElevation: 8,
                ),
                rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                
                // Value indicator
                showValueIndicator: ShowValueIndicator.never,
              ),
              child: RangeSlider(
                values: priceRange,
                min: 0,
                max: 200,
                divisions: 20,
                onChanged: (RangeValues values) {
                  setState(() {
                    priceRange = values;
                  });
                },
              ),
            ),
          ),
          
          const Spacer(),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () {
                    // Reset all filters
                    setState(() {
                      selectedCategory = null;
                      selectedTimeFilter = null;
                      startDate = null;
                      endDate = null;
                      priceRange = const RangeValues(20, 120);
                      location = "Melbourne, Vic";
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "RESET",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {
                    // Apply filters and close modal
                    final filters = {
                      'category': selectedCategory,
                      'timeFilter': selectedTimeFilter,
                      'startDate': startDate,
                      'endDate': endDate,
                      'priceRange': {
                        'start': priceRange.start,
                        'end': priceRange.end,
                      },
                      'location': location.split(',')[0], // Extract the city name for the query
                    };
                    widget.onApplyFilters(filters);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "APPLY",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}