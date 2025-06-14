import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_editing/screens/edit_questions.dart';
import 'package:app_mobile_frontend/core/models/question_models.dart';

void main() {
  group('QuestionnaireManagementPage Widget Tests', () {
    late List<QuestionDTO> sampleQuestions;

    setUp(() {
      sampleQuestions = [
        QuestionDTO(id: 1, questionText: 'First?', isRequired: true, displayOrder: 1, questionType: 'TEXT', options: []),
        QuestionDTO(id: 2, questionText: 'Second?', isRequired: false, displayOrder: 2, questionType: 'TEXT', options: []),
      ];
    });

    testWidgets('displays initial list of questions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QuestionnaireManagementPage(
            eventId: 123,
            questions: sampleQuestions,
            registrationsCount: 0,
          ),
        ),
      );

      // Should display each question text
      expect(find.text('First?'), findsOneWidget);
      expect(find.text('Second?'), findsOneWidget);
    });

    testWidgets('Add Question button enabled when no registrations', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QuestionnaireManagementPage(
            eventId: 123,
            questions: sampleQuestions,
            registrationsCount: 0,
          ),
        ),
      );
      final addButton = find.widgetWithText(TextButton, 'Add Question');
      expect(addButton, findsOneWidget);
      final button = tester.widget<TextButton>(addButton);
      expect(button.onPressed != null, isTrue);
    });

    testWidgets('Add Question button disabled when registrations exist', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QuestionnaireManagementPage(
            eventId: 123,
            questions: sampleQuestions,
            registrationsCount: 5,
          ),
        ),
      );
      final addButton = find.widgetWithText(TextButton, 'Add Question');
      expect(addButton, findsOneWidget);
      final button = tester.widget<TextButton>(addButton);
      expect(button.onPressed, isNull);
    });
  });
}
