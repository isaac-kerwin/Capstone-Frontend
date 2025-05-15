import 'package:first_app/network/auth.dart';
import "package:first_app/network/dio_client.dart";
import "package:first_app/models/event.dart";
import "package:first_app/models/tickets.dart";
import "package:dio/dio.dart";

// TO DO  
Future<void> createEvent(CreateEventDTO event) async {
  try {
    print("Access Token used for createEvent: $accessToken");
    final response = await dioClient.dio.post(
      "/events",
      data: event.toJson(),
          options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    ));
    if (response.data["success"]) {
      print("Event created successfully: ${response.data}");
    } else {
      print("Failed to create event: ${response.data}");
    }
  } catch (error) {
    print("Error creating event: $error");
  }
}

Future<void> updateEvent(int id, UpdateEventDTO updatedEvent) async {
  try {
    final response = await dioClient.dio.put(
      "/events/$id",
      data: updatedEvent.toJson(),
          options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',}));
    if (response.data["success"]) {
      print("Event updated successfully: ${response.data}");
    } else {
      print("Failed to update event: ${response.data}");
    }
  } catch (error) {
    print("Error updating event: $error");
  }     
}

// NOT WORKING IN BACKEND YET
Future<void> deleteEvent(int id) async {
  try {
    final response = await dioClient.dio.delete(
      "/events/$id",
          options: Options(
      headers:
        {'Authorization': 'Bearer $accessToken',}));
    if (response.data["success"]) {
      print("Event deleted successfully: ${response.data}");
    } else {
      print("Failed to delete event: ${response.data}");
    }
  } catch (error) {
    print("Error deleting event: $error");
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
    print("ID: $id");
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

Future<Ticket> createTicket(int eventId, TicketDTO ticket) async {
  try {
    final response = await dioClient.dio.post(
      "/events/$eventId/tickets",
      data: ticket.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    if (response.data["success"]) {
      return Ticket.fromJson(response.data["data"]);
    } else {
      throw Exception("Failed to create ticket: ${response.data}");
    }
  } catch (error) {
    throw Exception("Error creating ticket: $error");
  }
}

Future<Ticket> updateTicket(int ticketId, TicketDTO ticket) async {
  try {
    final response = await dioClient.dio.put(
      "/tickets/$ticketId",
      data: ticket.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    if (response.data["success"]) {
      return Ticket.fromJson(response.data["data"]);
    } else {
      throw Exception("Failed to update ticket: ${response.data}");
    }
  } catch (error) {
    throw Exception("Error updating ticket: $error");
  }
}

Future<void> deleteTicket(int ticketId) async {
  try {
    final response = await dioClient.dio.delete(
      "/tickets/$ticketId",
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    if (!response.data["success"]) {
      throw Exception("Failed to delete ticket: ${response.data}");
    }
  } catch (error) {
    throw Exception("Error deleting ticket: $error");
  }
}