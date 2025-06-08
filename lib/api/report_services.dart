import 'package:app_mobile_frontend/api/dio_client.dart';
import 'package:app_mobile_frontend/api/auth_services.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('EventReport');

Future<dynamic> getEventReport(int eventId) async {
  try {
    final response = await dioClient.dio.get(
      '/events/$eventId/report',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
        },
      ),
    );
    if (response.statusCode == 200 && response.data != null) {
      _logger.info("Event report fetched successfully: ${response.data}"); 
      return response.data;
    } else {
      throw Exception('Failed to fetch event report: ${response.data}');
    }
  } on DioException catch (e) {
    throw Exception('Failed to fetch event report: ${e.response?.data ?? e.message}');
  }
}