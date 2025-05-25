import 'package:app_mobile_frontend/network/auth.dart';
import "package:app_mobile_frontend/network/dio_client.dart";
import 'package:app_mobile_frontend/models/registration.dart';  
import "package:dio/dio.dart";

Future<String?> createRegistration(EventRegistrationDTO registrationDTO) async {
  try {
    final response = await dioClient.dio.post(
      "/registrations",
      data: registrationDTO.toJson(),
    );
    if (response.data["registrationId"] != null) {
      print("Event registration successful: ${response.data}");
      return response.data["registrationId"].toString();
    } else {
      print("Failed to register for event: ${response.data}");
      return null;
    }
  } catch (error) {
    print("Error registering for event: $error");
    return null;
  }
}

Future<void> updateRegistrationStatus(String registrationId, String status) async {
  try {
    final response = await dioClient.dio.patch(
      "/registrations/$registrationId/status",
      data: {"status": status},
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
        },
      ),
    );
  } catch (error) {
    print("Error updating registration status: $error");
  }
}





