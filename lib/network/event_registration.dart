import 'package:app_mobile_frontend/network/auth.dart';
import "package:app_mobile_frontend/network/dio_client.dart";
import "package:app_mobile_frontend/models/registration.dart";
import "package:dio/dio.dart";

Future<bool> singleRegistration(int event, EventRegistrationDTO) async{
  try {
    final response = await dioClient.dio.post(
      "/events/$event/registration",
      data: EventRegistrationDTO.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    if (response.data["success"]) {
      print("Event registration successful: ${response.data}");
      return true;
    } else {
      print("Failed to register for event: ${response.data}");
      return false;
    }
  } catch (error) {
    print("Error registering for event: $error");
    return false;
  }
}

