import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/core/models/question.dart'; // Update the path if needed

void main() {
  group('Question Models', () {
    test('T1.4.1 - Test Question.fromJson', () {
      final json = {
        "id": 1,
        "eventId": 101,
        "isRequired": true,
        "displayOrder": 1,
        "createdAt": "2025-01-01T10:00:00Z",
        "updatedAt": "2025-01-01T10:00:00Z",
        "question": {
          "id": 10,
          "questionText": "What is your name?",
          "questionType": "text",
          "category": "personal",
          "validationRules": "required",
          "createdAt": "2025-01-01T09:00:00Z",
          "updatedAt": "2025-01-01T09:30:00Z"
        }
      };

      final question = Question.fromJson(json);
      expect(question.id, 1);
      expect(question.question.questionText, "What is your name?");
      expect(question.question.category, "personal");
    });

    test('T1.4.2 - Test missing field in Question.fromJson', () {
      final json = {
        // Missing "id" in outer question object
        "eventId": 101,
        "isRequired": true,
        "displayOrder": 1,
        "createdAt": "2025-01-01T10:00:00Z",
        "updatedAt": "2025-01-01T10:00:00Z",
        "question": {
          // Also missing "questionText" here
          "id": 10,
          "questionType": "text",
          "category": "personal",
          "validationRules": "required",
          "createdAt": "2025-01-01T09:00:00Z",
          "updatedAt": "2025-01-01T09:30:00Z"
        }
      };

      expect(() => Question.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('T1.4.3 - Test creation of QuestionDetails with all fields', () {
      final details = QuestionDetails(
        id: 1,
        questionText: "Your age?",
        questionType: "number",
        category: "demographic",
        validationRules: "min:0",
        createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
        updatedAt: DateTime.parse("2025-01-01T08:30:00Z"),
      );

      expect(details.questionText, "Your age?");
      expect(details.category, "demographic");
    });

    test('T1.4.4 - Test null optional fields in QuestionDetails', () {
      final details = QuestionDetails(
        id: 2,
        questionText: "Comments?",
        questionType: "text",
        category: null,
        validationRules: null,
        createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
        updatedAt: DateTime.parse("2025-01-01T08:30:00Z"),
      );

      expect(details.category, null);
      expect(details.validationRules, null);
    });

    test('T1.4.5 - Test QuestionGroup.fromJson with list of questions', () {
      final json = {
        "questions": [
          {
            "id": 1,
            "eventId": 101,
            "isRequired": true,
            "displayOrder": 1,
            "createdAt": "2025-01-01T10:00:00Z",
            "updatedAt": "2025-01-01T10:00:00Z",
            "question": {
              "id": 10,
              "questionText": "Name?",
              "questionType": "text",
              "category": "personal",
              "validationRules": "required",
              "createdAt": "2025-01-01T09:00:00Z",
              "updatedAt": "2025-01-01T09:30:00Z"
            }
          },
          {
            "id": 2,
            "eventId": 101,
            "isRequired": false,
            "displayOrder": 2,
            "createdAt": "2025-01-01T10:05:00Z",
            "updatedAt": "2025-01-01T10:05:00Z",
            "question": {
              "id": 11,
              "questionText": "Age?",
              "questionType": "text",
              "category": "demographic",
              "validationRules": null,
              "createdAt": "2025-01-01T09:10:00Z",
              "updatedAt": "2025-01-01T09:40:00Z"
            }
          }
        ]
      };

      final group = QuestionGroup.fromJson(json);
      expect(group.questions.length, 2);
      expect(group.questions[1].question.questionText, "Age?");
    });

    test('T1.4.7 - Test QuestionGroup.fromJson with empty question list', () {
      final json = {
        "questions": []
      };
      final group = QuestionGroup.fromJson(json);
      expect(group.questions, isEmpty);
    });
  });
}
