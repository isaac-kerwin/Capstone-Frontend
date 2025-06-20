/// Event Services
/// Uses `CreateEventDTO` and `UpdateEventDTO` for creating and updating events.
/// Uses `EventWithQuestions` for retrieving event details with questions.
/// Provides CRUD operations for events and tickets:
/// - createEvent, updateEvent, deleteEvent
/// - getAllEvents, getEventById
/// - createTicket, updateTicket, deleteTicket

import 'package:app_mobile_frontend/api/auth_services.dart';
import "package:app_mobile_frontend/api/dio_client.dart";
import "package:app_mobile_frontend/core/models/event_models.dart";
import "package:dio/dio.dart";
import "package:app_mobile_frontend/core/models/ticket_models.dart";
import 'package:logging/logging.dart';

// Initialize logger
final Logger _logger = Logger('EventNetwork');

Future<void> createEvent(CreateEventDTO event) async {
  try {
    final response = await dioClient.dio.post(
      "/events",
      data: event.toJson(),
          options: Options(
      headers: {
        'Authorization': 'Bearer ${await getToken()}',
      },
    ));
    if (response.data["success"]) {
      _logger.info("Event created successfully: ${response.data}");
      // Update event to published status
      await publishEvent(response.data["data"]["id"]);
    } else {
      _logger.warning("Failed to create event: ${response.data}");
    }
  } catch (error) {
    _logger.severe("Error creating event: $error");
  }
}

Future<void> updateEvent(int id, UpdateEventDTO updatedEvent) async {
  try {
    final response = await dioClient.dio.put(
      "/events/$id",
      data: updatedEvent.toJson(),
          options: Options(
      headers: {
        'Authorization': 'Bearer ${await getToken()}',}));
    if (response.data["success"]) {
      _logger.info("Event updated successfully: ${response.data}");
    } else {
      _logger.warning("Failed to update event: ${response.data}");
    }
  } catch (error) {
    _logger.severe("Error updating event: $error");
  }     
}

Future<void> deleteEvent(int id) async {
  try {
    final response = await dioClient.dio.delete(
      "/events/$id",
          options: Options(
      headers:
        {'Authorization': 'Bearer ${await getToken()}',}));
    if (response.data["success"]) {
      _logger.info("Event deleted successfully: ${response.data}");
    } else {
      _logger.warning("Failed to delete event: ${response.data}");
    }
  } catch (error) {
    _logger.severe("Error deleting event: $error");
  }
}

//Implemented
Future<Events> getAllEvents() async {
  try{
    final response = await dioClient.dio.get("/events");
    if(response.data["success"]){
      final  responseData = response.data;
      Events events = Events.fromJson(responseData["data"]);
      return events;
    }
    else{
      throw Exception("Failed to get events: ${response.data}");
    }
  }
  catch(error){
    throw Exception("Error getting events: $error");
  }
}

Future<Events> getFilteredEvents(String filter) async{
  try{
    final response = await dioClient.dio.get("/events?$filter");
    if(response.data["success"]){
      final  responseData = response.data;
      Events events = Events.fromJson(responseData["data"]);
      return events;
    }
    else{
      throw Exception("Failed to get events: ${response.data}");
    }
  }
  catch(error){
    throw Exception("Error getting events: $error");
  }
}

Future<EventWithQuestions> getEventById(int id) async {
  try {
    _logger.fine("ID: $id");
    final response = await dioClient.dio.get("/events/$id");
    if (response.data["success"]) {
      final responseData = response.data;
      EventWithQuestions event = EventWithQuestions.fromJson(responseData["data"]);
      return event;
    } else {
      throw Exception("Failed to get event: ${response.data}");
    }
  } catch (error) {
    throw Exception("Error getting event: $error");
  }
}


Future<bool> publishEvent(int id) async{
  try {
    final response = await dioClient.dio.patch(
      "/events/${id}/status",
      data: {
        "status": "PUBLISHED",
      },
      options: Options(
      headers: {
        'Authorization': 'Bearer ${await getToken()}',
      },
    ));
    if (response.data["success"]) {
      _logger.info("Event published successfully: ${response.data}");
      return true;
    } else {
      _logger.warning("Failed to publish event: ${response.data}");
      return false;
    }
  } catch (error) {
    _logger.severe("Error publishing event: $error");
    return false;
  }
}

Future<Ticket> getTicketById(int eventId, int ticketId) async {
  try {
    _logger.fine("/events/$eventId/tickets/$ticketId");
    final response = await dioClient.dio.get("/events/$eventId/tickets/$ticketId");
    if (response.data["success"]) {
      final ticketData = response.data["data"];
      _logger.fine("Ticket data: $ticketData");
      return Ticket.fromJson(ticketData);
    } else {
      _logger.warning("Failed to get ticket: ${response.data}");
      throw Exception("Failed to get ticket: ${response.data}");
    }
  } catch (error) {
    _logger.severe("Error getting ticket: $error");
    throw Exception("Error getting ticket: $error");
  }
}


Future<List<dynamic>> getEventRegistrations(String eventId, bool pendingOnly) async {
  if (pendingOnly) {
    // If pendingOnly is true, filter registrations
    try {
      final response = await dioClient.dio.get(
        "/events/$eventId/registrations?status=PENDING",
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await getToken()}',
          },
        ),
      );
      return response.data["data"];
    } catch (error) {
      print("Error fetching pending registrations for event: $error");
      rethrow;
    }
  }
  else {
    try {
      final response = await dioClient.dio.get(
          "/events/$eventId/registrations",
          options: Options(
          headers: {
            'Authorization': 'Bearer ${await getToken()}',
          },
        ),
      );
      return response.data["data"];
    } catch (error) {
      print("Error fetching registrations for event: $error");
      rethrow;
    }
  }
}


