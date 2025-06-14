import 'package:app_mobile_frontend/api/auth_services.dart';
import "package:app_mobile_frontend/api/dio_client.dart";
import "package:dio/dio.dart";
import 'package:logging/logging.dart';
import 'package:app_mobile_frontend/core/models/question_models.dart';  // import CreateQuestionDTO

// Initialize logger
final Logger _logger = Logger('EventQuestions');

// Updates only the questionnaire questions for a given event
Future<bool> updateEventQuestion(int eventId, int eventQuestionId, UpdateQuestionDTO question) async {
  try {
    final response = await dioClient.dio.put(
      "/events/$eventId/questions/$eventQuestionId",
      data: { 'isRequired': question.isRequired, 'displayOrder': question.displayOrder },
      options: Options(
        headers: { 'Authorization': 'Bearer ${await getToken()}' },
      ),
    );
    if (response.data["success"]) {
      _logger.info("Question updated successfully for event $eventId: ${response.data}");
      return true;
    } else {
      _logger.warning("Failed to update questions: ${response.data}");
      return false;
    }
  } catch (e) {
    _logger.severe("Error updating questions: $e");
    return false;
  }
}

Future<bool> deleteEventQuestion(int eventId, int eventQuestionId) async {
  try {
    final response = await dioClient.dio.delete(
      "/events/$eventId/questions/$eventQuestionId",
      options: Options(
        headers: { 'Authorization': 'Bearer ${await getToken()}' },
      ),
    );
    if (response.data["success"]) {
      _logger.info("Question deleted successfully: $eventQuestionId");
      return true;
    } else {
      _logger.warning("Failed to delete question: ${response.data}");
      return false;
    }
  } catch (e) {
    _logger.severe("Error deleting question: $e");
    return false;
  }
}

Future<bool> createEventQuestion(int eventId, CreateQuestionDTO question) async {
  try {
    final response = await dioClient.dio.post(
      "/events/$eventId/questions",
      data: question.toJson(),
      options: Options(
        headers: { 'Authorization': 'Bearer ${await getToken()}' },
      ),
    );
    if (response.data["success"]) {
      _logger.info("Question created successfully for event $eventId: ${response.data}");
      return true;
    } else {
      _logger.warning("Failed to create question: ${response.data}");
      return false;
    }
  } catch (e) {
    _logger.severe("Error creating question: $e");
    return false;
  }
}
