import 'package:app_mobile_frontend/models/event.dart';
import 'package:app_mobile_frontend/network/event.dart';

/// Service to fetch or filter events based on search and filters.
class EventQueryService {
  /// Returns a list of events matching search query or filters.
  static Future<Events> fetchEvents({
    required List<EventDetails> allEvents,
    required String searchQuery,
    String? activeFilter,
    String? activeCategory,
    required Map<String, String> categoryMap,
  }) async {
    // Local search first
    if (allEvents.isNotEmpty && searchQuery.isNotEmpty) {
      final filtered = allEvents.where((event) {
        final q = searchQuery.toLowerCase();
        return event.name.toLowerCase().contains(q) ||
            event.description.toLowerCase().contains(q) ||
            event.location.toLowerCase().contains(q);
      }).toList();
      return Events(
        events: filtered,
        pagination: Pagination(
          total: filtered.length,
          pages: 1,
          page: 1,
          limit: filtered.length,
        ),
      );
    }
    // Server-side filters
    if (activeFilter != null) {
      return getFilteredEvents(activeFilter);
    }
    if (activeCategory != null) {
      final cat = categoryMap[activeCategory] ?? activeCategory;
      return getFilteredEvents('eventType=$cat');
    }
    // Default fetch all
    return getAllEvents();
  }
}
