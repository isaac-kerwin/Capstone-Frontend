import 'package:app_mobile_frontend/models/report.dart';
import 'package:app_mobile_frontend/network/dio_client.dart';
import 'package:app_mobile_frontend/network/auth.dart';
import 'package:dio/dio.dart';

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
      print("Event report fetched successfully: ${response.data}"); 
      return response.data;
    } else {
      throw Exception('Failed to fetch event report: ${response.data}');
    }
  } on DioException catch (e) {
    throw Exception('Failed to fetch event report: ${e.response?.data ?? e.message}');
  }
}