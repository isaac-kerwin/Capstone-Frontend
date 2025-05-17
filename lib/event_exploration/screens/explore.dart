import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/event_registration/screens/new_registration_form_generator.dart';
import 'package:app_mobile_frontend/event_exploration/screens/filter_events.dart';
import 'package:app_mobile_frontend/models/event.dart';
import 'package:app_mobile_frontend/network/event.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late Future<Events> eventsFuture;
  String? activeFilter;
  String? activeCategory;
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  List<EventDetails> allEvents = [];
  bool isSearching = false;
  
  // Map frontend category names to backend enum values
  final Map<String, String> categoryToBackendMap = {
    'Sports': 'SPORTS',
    'Music': 'MUSICAL',
    'Social': 'SOCIAL',
    'Volunteering': 'VOLUNTEERING',
  };

  @override
  void initState() {
    super.initState();
    eventsFuture = getAllEvents();
    // Load initial events to have available for search filtering
    _loadInitialEvents();
    
    // Add listener to search controller
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  
  // Load all events for search filtering
  Future<void> _loadInitialEvents() async {
    try {
      final events = await getAllEvents();
      setState(() {
        allEvents = events.events;
      });
    } catch (e) {
      debugPrint("Error loading initial events: $e");
    }
  }
  
  // Search changed handler
  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
      if (searchQuery.isNotEmpty) {
        isSearching = true;
        _filterEventsBySearch();
      } else {
        isSearching = false;
        // Reset to original filter or all events if no filters active
        if (activeFilter != null) {
          eventsFuture = getFilteredEvents(activeFilter!);
        } else if (activeCategory != null) {
          final backendCategory = categoryToBackendMap[activeCategory] ?? activeCategory;
          eventsFuture = getFilteredEvents('eventType=$backendCategory');
        } else {
          eventsFuture = getAllEvents();
        }
      }
    });
  }
  
  // Filter events by search
  void _filterEventsBySearch() {
    // If we have all events loaded, filter locally for immediate feedback
    if (allEvents.isNotEmpty) {
      final filteredEvents = allEvents.where((event) => 
        event.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        event.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
        event.location.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
      
      // Create events object with filtered events
      final events = Events(
        events: filteredEvents,
        pagination: Pagination(total: filteredEvents.length, pages: 1, page: 1, limit: filteredEvents.length)
      );
      
      setState(() {
        // Use a Future that resolves immediately with our filtered results
        eventsFuture = Future.value(events);
      });
    } else {
      // If we don't have events loaded yet, make a backend request with search parameter
      setState(() {
        final searchFilterParam = 'search=${Uri.encodeComponent(searchQuery)}';
        
        // Combine with any active filters
        if (activeFilter != null) {
          eventsFuture = getFilteredEvents('$activeFilter&$searchFilterParam');
        } else {
          eventsFuture = getFilteredEvents(searchFilterParam);
        }
      });
    }
  }

  void _register(EventDetails event) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegistrationForm(eventId: event.id),
        ),
      );
    });
  }
  
  // Apply filters based on filter modal selections
  void _applyFilters(Map<String, dynamic> filters) {
    List<String> queryParts = [];

    // Category Filter
    if (filters['category'] != null) {
      final backendCategory = categoryToBackendMap[filters['category']] ?? filters['category'];
      queryParts.add('eventType=$backendCategory');
      setState(() {
        activeCategory = filters['category'];
      });
    }

    final now = DateTime.now();

    // ✅ Handle Explicit Date Range Selection First (High Priority)
    if (filters['startDate'] != null && filters['endDate'] != null) {
      final startDateStr = (filters['startDate'] as DateTime).toIso8601String();
      final endDateStr = (filters['endDate'] as DateTime).toIso8601String();
      queryParts.add('startDate=${Uri.encodeComponent(startDateStr)}');
      queryParts.add('endDate=${Uri.encodeComponent(endDateStr)}');
    } 
    // Else handle Predefined Time Filters (Today, Tomorrow, This Week)
    else if (filters['timeFilter'] != null) {
      DateTime startDate;
      DateTime endDate;

      switch (filters['timeFilter']) {
        case 'Today':
          startDate = DateTime(now.year, now.month, now.day);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          break;
        case 'Tomorrow':
          startDate = DateTime(now.year, now.month, now.day + 1);
          endDate = DateTime(now.year, now.month, now.day + 1, 23, 59, 59);
          break;
        case 'This week':
          final daysUntilEndOfWeek = DateTime.daysPerWeek - now.weekday;
          startDate = DateTime(now.year, now.month, now.day);
          endDate = DateTime(now.year, now.month, now.day + daysUntilEndOfWeek, 23, 59, 59);
          break;
        default:
          startDate = now;
          endDate = DateTime(now.year + 1, now.month, now.day);
      }

      final startDateStr = startDate.toIso8601String();
      final endDateStr = endDate.toIso8601String();
      queryParts.add('startDate=${Uri.encodeComponent(startDateStr)}');
      queryParts.add('endDate=${Uri.encodeComponent(endDateStr)}');
    }

    // Location Filter
    if (filters['location'] != null && filters['location'] != "Melbourne, Vic") {
      queryParts.add('location=${Uri.encodeComponent(filters['location'])}');
    }

    // Price Range Filter
    if (filters['priceRange'] != null) {
      final start = filters['priceRange']['start'];
      final end = filters['priceRange']['end'];
      queryParts.add('minPrice=$start');
      queryParts.add('maxPrice=$end');
    }

    final filterQuery = queryParts.join('&');

    setState(() {
      activeFilter = filterQuery.isNotEmpty ? filterQuery : null;

      if (isSearching && searchQuery.isNotEmpty) {
        final searchParam = 'search=${Uri.encodeComponent(searchQuery)}';
        eventsFuture = filterQuery.isNotEmpty 
          ? getFilteredEvents('$filterQuery&$searchParam') 
          : getFilteredEvents(searchParam);
      } else {
        eventsFuture = filterQuery.isNotEmpty 
          ? getFilteredEvents(filterQuery) 
          : getAllEvents();
      }
    });

    _loadInitialEvents();
  }

  void _selectCategory(String category) {
    setState(() {
      // Toggle category selection
      if (activeCategory == category) {
        activeCategory = null;
        
        // If we're searching, maintain search query
        if (isSearching && searchQuery.isNotEmpty) {
          eventsFuture = getFilteredEvents('search=${Uri.encodeComponent(searchQuery)}');
        } else {
          eventsFuture = getAllEvents();
        }
      } else {
        activeCategory = category;
        // Convert the frontend category to backend enum value
        final backendCategory = categoryToBackendMap[category] ?? category;
        
        // If we're searching, include the search query
        if (isSearching && searchQuery.isNotEmpty) {
          eventsFuture = getFilteredEvents('eventType=$backendCategory&search=${Uri.encodeComponent(searchQuery)}');
        } else {
          eventsFuture = getFilteredEvents('eventType=$backendCategory');
        }
      }
    });
    
    // Reload all events for search filtering with the new category applied
    _loadInitialEvents();
  }

  // Clear all filters and search
  void _clearFiltersAndSearch() {
    setState(() {
      activeFilter = null;
      activeCategory = null;
      searchQuery = "";
      isSearching = false;
      _searchController.clear();
      eventsFuture = getAllEvents();
    });
    
    // Reload all events without filters
    _loadInitialEvents();
  }

  // Color palette for event cards
  final List<Color> _eventCardColors = [
    const Color(0xFFFFC371), // Yellow-Orange
    const Color(0xFFFF9A8B), // Soft Red
    const Color(0xFF90CAF9), // Light Blue
    const Color(0xFFA5D6A7), // Light Green
    const Color(0xFFB39DDB), // Light Purple
  ];

  Widget _buildEventItem(EventDetails event) {
    DateTime date = event.startDateTime;
    String month = _getMonthAbbreviation(date.month);
    String day = date.day.toString();

    final int colorIndex = event.id.hashCode % _eventCardColors.length;
    final Color backgroundColor = _eventCardColors[colorIndex];

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white, // Outer white container
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colored card (keeps original size by giving it a fixed height)
          Container(
            width: double.infinity,
            height: 120, // FIXED HEIGHT to prevent shrinking
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(day, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(month, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),

          // Event description (moved here)
          const SizedBox(height: 12),
          Text(
            event.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '+ ${event.capacity} Going',
            style: TextStyle(fontSize: 12, color: Colors.grey[800]),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.location,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    ];
    return months[month - 1];
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventFilterModal(
        onApplyFilters: _applyFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': 'Sports', 'icon': Icons.sports_basketball, 'color': activeCategory == 'Sports' ? const Color(0xFF5E55FF) : Colors.orange},
      {'label': 'Music', 'icon': Icons.music_note, 'color': activeCategory == 'Music' ? const Color(0xFF5E55FF) : Colors.redAccent},
      {'label': 'Social', 'icon': Icons.people, 'color': activeCategory == 'Social' ? const Color(0xFF5E55FF) : Colors.green},
      {'label': 'Volunteering', 'icon': Icons.volunteer_activism, 'color': activeCategory == 'Volunteering' ? const Color(0xFF5E55FF) : Colors.blue},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with location and search
            Container(
              color: const Color(0xFF5E55FF),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar with filter
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search events...',
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Clear search button (only shows when searching)
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white),
                              onPressed: () {
                                _searchController.clear();
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.filter_alt, color: Colors.white),
                            onPressed: _showFilterModal,
                          ),
                        ],
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: const TextStyle(color: Colors.white54),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (_) {
                      // Trigger search when user presses enter/done on keyboard
                      _filterEventsBySearch();
                    },
                  ),
                ],
              ),
            ),

            // Categories section with active state
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: categories.map((cat) {
                    final bool isActive = activeCategory == cat['label'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () => _selectCategory(cat['label'] as String),
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
            ),

            // Active filter indicator
            if (activeFilter != null || activeCategory != null || isSearching)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, size: 16, color: Color(0xFF5E55FF)),
                    const SizedBox(width: 8),
                    Text(
                      _getFilterLabel(),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF5E55FF)),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _clearFiltersAndSearch,
                      child: const Text('Clear', style: TextStyle(color: Color(0xFF5E55FF))),
                    ),
                  ],
                ),
              ),

            // Main content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upcoming Events section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getSectionTitle(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Row(
                            children: [
                              Text('See All'),
                              Icon(Icons.chevron_right, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Horizontal Event List
                    FutureBuilder<Events>(
                      future: eventsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.events.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  Text(
                                    isSearching 
                                      ? 'No events match your search for "$searchQuery"' 
                                      : 'No events match your filters',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: snapshot.data!.events.map(_buildEventItem).toList(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Near You section (will also use filtered results)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Near You',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Row(
                            children: [
                              Text('See All'),
                              Icon(Icons.chevron_right, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Vertical Event List (same data)
                    FutureBuilder<Events>(
                      future: eventsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.events.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('No events match your criteria'),
                            ),
                          );
                        }

                        return Column(
                          children: snapshot.data!.events.map((event) {
                            return GestureDetector(
                              onTap: () => _register(event),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.event, 
                                      color: activeCategory != null ? 
                                        const Color(0xFF5E55FF) : 
                                        Colors.blue
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(event.location, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _register(event),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF5E55FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      child: const Text('Register'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper methods for UI text
  String _getFilterLabel() {
    if (isSearching && searchQuery.isNotEmpty) {
      return 'Search results for: "$searchQuery"';
    } else if (activeCategory != null) {
      return 'Filtered by: $activeCategory';
    } else if (activeFilter != null) {
      return 'Filters applied';
    }
    return '';
  }
  
  String _getSectionTitle() {
    if (isSearching && searchQuery.isNotEmpty) {
      return 'Search Results';
    } else if (activeCategory != null) {
      return '$activeCategory Events';
    }
    return 'Upcoming Events';
  }
}