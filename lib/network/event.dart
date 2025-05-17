import 'package:app_mobile_frontend/network/auth.dart';
import "package:app_mobile_frontend/network/dio_client.dart";
import "package:app_mobile_frontend/models/event.dart";
import "package:dio/dio.dart";

// TO DO  
Future<void> createEvent(CreateEventDTO event) async {
  try {
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

// Future<Events> searchEvents(String searchTerm) async {
//   try {
//     final encodedSearchTerm = Uri.encodeComponent(searchTerm);
//     final response = await dioClient.dio.get("/events?search=$encodedSearchTerm");
    
//     if (response.data["success"]) {
//       final responseData = response.data;
//       Events events = Events.fromJson(responseData["data"]);
//       return events;
//     } else {
//       throw Exception("Failed to search events: ${response.data}");
//     }
//   } catch (error) {
//     throw Exception("Error searching events: $error");
//   }
// }

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

Future<bool> publishEvent(int id) async{
  try {
    final response = await dioClient.dio.patch(
      "/events/${id}/status",
      data: {
        "status": "PUBLISHED",
      },
      options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    ));
    if (response.data["success"]) {
      print("Event published successfully: ${response.data}");
      return true;
    } else {
      print("Failed to publish event: ${response.data}");
      return false;
    }
  } catch (error) {
    print("Error publishing event: $error");
    return false;
  }
}