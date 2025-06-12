import 'package:app_mobile_frontend/api/auth_services.dart';
import "package:app_mobile_frontend/api/dio_client.dart";
import 'package:app_mobile_frontend/core/models/registration_models.dart';  
import "package:dio/dio.dart";
import 'package:logging/logging.dart';

final Logger _logger = Logger('EventRegistration');

Future<String?> createRegistration(EventRegistrationDTO registrationDTO) async {
  try {
    final response = await dioClient.dio.post(
      "/registrations",
      data: registrationDTO.toJson(),
    );
    if (response.data["registrationId"] != null) {
      _logger.info("Event registration successful: ${response.data}");
      return response.data["registrationId"].toString();
    } else {
      _logger.warning("Failed to register for event: ${response.data}");
      return null;
    }
  } catch (error) {
    _logger.severe("Error registering for event: $error");
    return null;
  }
}

Future<void> updateRegistrationStatus(String registrationId, String status) async {
  try {
    await dioClient.dio.patch(
      "/registrations/$registrationId/status",
      data: {"status": status},
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
        },
      ),
    );
  } catch (error) {
    _logger.severe("Error updating registration status: $error");
  }
}





