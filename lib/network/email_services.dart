import 'package:app_mobile_frontend/models/email.dart';
import 'package:dio/dio.dart';
import 'dio_client.dart';

Future<void> sendRegistrationEmail(EmailDTO emailDTO) async {
  try {
    dioClient.dio.post(
      '/email',
      data: emailDTO.toJson(),
    );
  } on DioException catch (e) {
    // You can handle/log errors here as needed
    throw Exception('Failed to send registration email: ${e.response?.data ?? e.message}');
  }
}