import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/features/event_exploration/screens/filter_events.dart';
import 'package:app_mobile_frontend/models/event.dart';
import 'package:app_mobile_frontend/network/event.dart';
import 'package:app_mobile_frontend/features/event_registration/screens/view_event.dart';

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

  final Map<String, String> categoryToBackendMap = {
    'Sports': 'SPORTS',
    'Music': 'MUSICAL',
    'Social': 'SOCIAL',
    'Volunteering': 'VOLUNTEERING',
  };

  final List<Color> _eventCardColors = [
    const Color(0xFFFFC371),
    const Color(0xFFFF9A8B),
    const Color(0xFF90CAF9),
    const Color(0xFFA5D6A7),
    const Color(0xFFB39DDB),
  ];

  @override
  void initState() {
    super.initState();
    eventsFuture = getAllEvents();
    _loadInitialEvents();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

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

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
      if (searchQuery.isNotEmpty) {
        isSearching = true;
        _filterEventsBySearch();
      } else {
        isSearching = false;
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

  void _filterEventsBySearch() {
    if (allEvents.isNotEmpty) {
      final filteredEvents = allEvents.where((event) =>
        event.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        event.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
        event.location.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();

      final events = Events(
        events: filteredEvents,
        pagination: Pagination(total: filteredEvents.length, pages: 1, page: 1, limit: filteredEvents.length)
      );

      setState(() {
        eventsFuture = Future.value(events);
      });
    } else {
      setState(() {
        final searchFilterParam = 'search=${Uri.encodeComponent(searchQuery)}';
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
          builder: (_) => EventDetailsPage(eventId: event.id),
        ),
      );
    });
  }

  void _applyFilters(Map<String, dynamic> filters) {
    List<String> queryParts = [];
    if (filters['category'] != null) {
      final backendCategory = categoryToBackendMap[filters['category']] ?? filters['category'];
      queryParts.add('eventType=$backendCategory');
      setState(() {
        activeCategory = filters['category'];
      });
    }
    final now = DateTime.now();
    if (filters['startDate'] != null && filters['endDate'] != null) {
      final startDateStr = (filters['startDate'] as DateTime).toIso8601String();
      final endDateStr = (filters['endDate'] as DateTime).toIso8601String();
      queryParts.add('startDate=${Uri.encodeComponent(startDateStr)}');
      queryParts.add('endDate=${Uri.encodeComponent(endDateStr)}');
    } else if (filters['timeFilter'] != null) {
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
    if (filters['location'] != null && filters['location'] != "Melbourne, Vic") {
      queryParts.add('location=${Uri.encodeComponent(filters['location'])}');
    }
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
      if (activeCategory == category) {
        activeCategory = null;
        if (isSearching && searchQuery.isNotEmpty) {
          eventsFuture = getFilteredEvents('search=${Uri.encodeComponent(searchQuery)}');
        } else {
          eventsFuture = getAllEvents();
        }
      } else {
        activeCategory = category;
        final backendCategory = categoryToBackendMap[category] ?? category;
        if (isSearching && searchQuery.isNotEmpty) {
          eventsFuture = getFilteredEvents('eventType=$backendCategory&search=${Uri.encodeComponent(searchQuery)}');
        } else {
          eventsFuture = getFilteredEvents('eventType=$backendCategory');
        }
      }
    });
    _loadInitialEvents();
  }

  void _clearFiltersAndSearch() {
    setState(() {
      activeFilter = null;
      activeCategory = null;
      searchQuery = "";
      isSearching = false;
      _searchController.clear();
      eventsFuture = getAllEvents();
    });
    _loadInitialEvents();
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

  // --- UI Helper Widgets ---

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search events...',
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
      onSubmitted: (_) => _filterEventsBySearch(),
    );
  }

  Widget _buildCategoryChips() {
    final categories = [
      {'label': 'Sports', 'icon': Icons.sports_basketball, 'color': activeCategory == 'Sports' ? const Color(0xFF5E55FF) : Colors.orange},
      {'label': 'Music', 'icon': Icons.music_note, 'color': activeCategory == 'Music' ? const Color(0xFF5E55FF) : Colors.redAccent},
      {'label': 'Social', 'icon': Icons.people, 'color': activeCategory == 'Social' ? const Color(0xFF5E55FF) : Colors.green},
      {'label': 'Volunteering', 'icon': Icons.volunteer_activism, 'color': activeCategory == 'Volunteering' ? const Color(0xFF5E55FF) : Colors.blue},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: categories.map((cat) {
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
    );
  }

  Widget _buildActiveFilterIndicator() {
    if (activeFilter == null && activeCategory == null && !isSearching) return const SizedBox.shrink();
    return Padding(
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
    );
  }

  Widget _buildHorizontalEventList() {
    return FutureBuilder<Events>(
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
            children: snapshot.data!.events.map((event) {
              return GestureDetector(
                onTap: () => _register(event),
                child: _buildEventItem(event),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildVerticalEventList() {
    return FutureBuilder<Events>(
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
                      child: const Text('View Event'),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

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
        color: Colors.white,
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
          Container(
            width: double.infinity,
            height: 120,
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

  // --- Main Build ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF5E55FF),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                ],
              ),
            ),
            _buildCategoryChips(),
            _buildActiveFilterIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getSectionTitle(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildHorizontalEventList(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'All Events',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                    
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildVerticalEventList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}