import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/filter_icon.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _minPrice = 20;
  double _maxPrice = 350;
  String _selectedCategory = 'Art';
  String _selectedTime = 'Tomorrow';
  String _location = "Melbourne, Vic";
  DateTimeRange? _dateRange;

  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationController.text = _location;
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    String rangeLabel = _dateRange == null
        ? "Enter Date Range"
        : "${DateFormat('MMM d, yyyy').format(_dateRange!.start)} - ${DateFormat('MMM d, yyyy').format(_dateRange!.end)}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Events"),
        centerTitle: true,
        leading: BackButton(),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterIcon(
                  label: "Sports",
                  icon: Icons.sports_soccer,
                  isSelected: _selectedCategory == 'Sports',
                  onTap: () => setState(() => _selectedCategory = 'Sports'),
                ),
                FilterIcon(
                  label: "Music",
                  icon: Icons.music_note,
                  isSelected: _selectedCategory == 'Music',
                  onTap: () => setState(() => _selectedCategory = 'Music'),
                ),
                FilterIcon(
                  label: "Art",
                  icon: Icons.brush,
                  isSelected: _selectedCategory == 'Art',
                  onTap: () => setState(() => _selectedCategory = 'Art'),
                ),
                FilterIcon(
                  label: "Food",
                  icon: Icons.restaurant,
                  isSelected: _selectedCategory == 'Food',
                  onTap: () => setState(() => _selectedCategory = 'Food'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Time & Date
            const Text("Time & Date", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _timeButton("Today"),
                const SizedBox(width: 8),
                _timeButton("Tomorrow"),
                const SizedBox(width: 8),
                _timeButton("This week"),
              ],
            ),
            const SizedBox(height: 12),

            // Date Range Picker
            GestureDetector(
              onTap: _pickDateRange,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        rangeLabel,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Location Input
            const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_pin, color: Colors.deepPurple),
                hintText: "Enter location",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) => setState(() => _location = value),
            ),

            const SizedBox(height: 24),

            // Price Range
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Select price range", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("\$${_minPrice.toInt()}–\$${_maxPrice.toInt()}", style: const TextStyle(color: Colors.deepPurple)),
              ],
            ),
            RangeSlider(
              min: 20,
              max: 350,
              divisions: 33,
              values: RangeValues(_minPrice, _maxPrice),
              onChanged: (values) {
                setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                });
              },
              activeColor: Colors.deepPurple,
              inactiveColor: Colors.deepPurple.withOpacity(0.2),
            ),

            const Spacer(),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'Art';
                        _selectedTime = 'Tomorrow';
                        _locationController.text = "Melbourne, Vic";
                        _minPrice = 20;
                        _maxPrice = 350;
                        _dateRange = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("RESET"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Applied: $_selectedCategory - $_selectedTime - $_location - \$${_minPrice.toInt()}–\$${_maxPrice.toInt()}"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                    ),
                    child: const Text("APPLY", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeButton(String label) {
    final bool isSelected = _selectedTime == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTime = label),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepPurple : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? Colors.deepPurple : Colors.grey.shade300),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
