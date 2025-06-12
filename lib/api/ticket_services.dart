import 'package:app_mobile_frontend/api/auth_services.dart';
import "package:app_mobile_frontend/api/dio_client.dart";
import "package:dio/dio.dart";
import "package:app_mobile_frontend/core/models/ticket_models.dart";


Future<Ticket> createTicket(int eventId, TicketDTO ticket) async {
  try {
    final response = await dioClient.dio.post(
      "/events/$eventId/tickets",
      data: ticket.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
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

Future<Ticket> updateTicket(int eventId, int ticketId, TicketDTO ticket) async {
  try {
    final response = await dioClient.dio.put(
      "/events/$eventId/tickets/$ticketId",
      data: ticket.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
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

Future<void> deleteTicket(int eventId, int ticketId) async {
  try {
    final response = await dioClient.dio.delete(
      "/events/$eventId/tickets/$ticketId",
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
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
