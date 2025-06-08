import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/features/event_exploration/screens/filter_events.dart';
import 'package:app_mobile_frontend/core/models/event.dart';
import 'package:app_mobile_frontend/network/event_services.dart';
import 'package:app_mobile_frontend/features/event_registration/screens/view_event.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/search_bar.dart' as search_widgets;
import 'package:app_mobile_frontend/features/event_exploration/widgets/category_chips.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/filter_indicator.dart';
import 'package:app_mobile_frontend/features/event_exploration/widgets/event_item.dart';
import 'package:app_mobile_frontend/features/event_exploration/services/event_query_service.dart';

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
    eventsFuture = getAllEvents(); // initial load
    _loadInitialEvents();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0, 
        elevation: 0,
        backgroundColor: const Color(0xFF5E55FF),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            CategoryChips(
              activeCategory: activeCategory,
              onSelect: _selectCategory,
            ),
            FilterIndicator(
              label: isSearching && searchQuery.isNotEmpty
                        ? 'Search results for: "$searchQuery"'
                        : activeCategory != null
                          ? 'Filtered by: $activeCategory'
                          : activeFilter != null
                            ? 'Filters applied'
                            : '',
              onClear: _clearFiltersAndSearch,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUpcomingEvents(context),
                    const SizedBox(height: 20),
                    _buildAllEventsList(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      // Query via service, handles search and filters
      isSearching = searchQuery.isNotEmpty;
      eventsFuture = EventQueryService.fetchEvents(
        allEvents: allEvents,
        searchQuery: searchQuery,
        activeFilter: activeFilter,
        activeCategory: activeCategory,
        categoryMap: categoryToBackendMap,
      );
    });
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      activeCategory = filters['category'];
      activeFilter = filters['category'] != null
          ? 'eventType=${categoryToBackendMap[filters['category']] ?? filters['category']}'
          : null;
      eventsFuture = EventQueryService.fetchEvents(
        allEvents: allEvents,
        searchQuery: searchQuery,
        activeFilter: activeFilter,
        activeCategory: activeCategory,
        categoryMap: categoryToBackendMap,
      );
    });
  }

  void _register(EventDetails event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsPage(eventId: event.id),
      ),
    );
  }

  void _clearFiltersAndSearch() {
    setState(() {
      activeFilter = null;
      activeCategory = null;
      searchQuery = "";
      isSearching = false;
      _searchController.clear();
      eventsFuture = EventQueryService.fetchEvents(
        allEvents: allEvents,
        searchQuery: '',
        activeFilter: null,
        activeCategory: null,
        categoryMap: categoryToBackendMap,
      );
    });
  }

  void _selectCategory(String category) {
    setState(() {
      activeCategory = activeCategory == category ? null : category;
      eventsFuture = EventQueryService.fetchEvents(
        allEvents: allEvents,
        searchQuery: searchQuery,
        activeFilter: activeFilter,
        activeCategory: activeCategory,
        categoryMap: categoryToBackendMap,
      );
    });
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

  // --- Main Build ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF5E55FF),
      padding: const EdgeInsets.all(16),
      child: search_widgets.SearchBar(
        controller: _searchController,
        onSubmitted: (_) => _onSearchChanged(),
        onClear: () => _searchController.clear(),
        onFilter: _showFilterModal,
      ),
    );
  }

  Widget  _buildUpcomingEvents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isSearching && searchQuery.isNotEmpty
              ? 'Search Results'
              : activeCategory != null
                  ? '$activeCategory Events'
                  : 'Upcoming Events',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        FutureBuilder<Events>(
          future: eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !isSearching) {
              // Show shimmer or placeholder only on initial load or filter change, not during active search typing
              return const Center(child: CircularProgressIndicator()); // Or a shimmer effect
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData && snapshot.data!.events.isNotEmpty) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: snapshot.data!.events.map((event) {
                    return EventItem(
                      event: event,
                      onTap: () => _register(event),
                    );
                  }).toList(),
                ),
              );
            }
            if (isSearching && snapshot.data?.events.isEmpty == true) {
              return const Center(child: Text('No events found for your search.'));
            }
            return const SizedBox.shrink(); // Or a message like 'No upcoming events'
          },
        ),
      ],
    );
  }

  Widget _buildAllEventsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Events',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        FutureBuilder<Events>(
          future: eventsFuture, // This might need to be a different future if 'All Events' should not be filtered
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
               return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error loading events: ${snapshot.error}'));
            }
            if (snapshot.hasData && snapshot.data!.events.isNotEmpty) {
              return Column(
                children: snapshot.data!.events.map((event) {
                  // Using the original vertical list item structure for now
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
                            color: activeCategory != null
                                ? const Color(0xFF5E55FF)
                                : Colors.blue,
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
                                Text(
                                  event.location,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: const Text('View Event'),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }
            return const Center(child: Text('No events available.'));
          },
        ),
      ],
    );
  }


}