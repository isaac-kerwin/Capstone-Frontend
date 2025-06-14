/// Email Services
///
/// Provides functions to send confirmation or other transactional emails.
/// Uses `EmailDTO` and `ConfirmationEmailDTO` payloads.

import 'package:app_mobile_frontend/core/models/email_models.dart';
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

Future<void> sendConfirmationEmail(ConfirmationEmailDTO dto) async {
  try {
    await dioClient.dio.post(
      '/email/invoice',
      data: dto.toJson(),
    );
  } on DioException catch (e) {
    throw Exception(
      'Failed to send confirmation email: ${e.response?.data ?? e.message}',
    );
  }
}