import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_editing/widgets/question_tile.dart';
import 'package:app_mobile_frontend/core/models/question.dart';

void main() {
  group('QuestionTile Widget Tests', () {
    late QuestionDTO sampleQuestion;
    late bool editCalled;
    late bool deleteCalled;

    setUp(() {
      sampleQuestion = QuestionDTO(
        id: 1,
        questionText: 'Sample?',
        isRequired: true,
        displayOrder: 5,
        questionType: 'TEXT',
        options: [],
      );
      editCalled = false;
      deleteCalled = false;
    });

    testWidgets('displays question text and subtitle correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionTile(
              question: sampleQuestion,
              canEdit: true,
              canDelete: true,
              onEdit: (_) {},
              onDelete: (_) {},
            ),
          ),
        ),
      );

      // Title
      expect(find.text('Sample?'), findsOneWidget);
      // Subtitle text contains required and order
      expect(find.textContaining('Required: Yes'), findsOneWidget);
      expect(find.textContaining('Order: 5'), findsOneWidget);
    });

    testWidgets('edit and delete icons invoke callbacks when allowed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionTile(
              question: sampleQuestion,
              canEdit: true,
              canDelete: true,
              onEdit: (_) => editCalled = true,
              onDelete: (_) => deleteCalled = true,
            ),
          ),
        ),
      );

      // Tap Edit icon
      final editIcon = find.byTooltip('Edit Question');
      expect(editIcon, findsOneWidget);
      await tester.tap(editIcon);
      expect(editCalled, isTrue);

      // Tap Delete icon
      final deleteIcon = find.byTooltip('Delete Question');
      expect(deleteIcon, findsOneWidget);
      await tester.tap(deleteIcon);
      expect(deleteCalled, isTrue);
    });

    testWidgets('icons disabled when not allowed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionTile(
              question: sampleQuestion,
              canEdit: false,
              canDelete: false,
              onEdit: (_) => editCalled = true,
              onDelete: (_) => deleteCalled = true,
            ),
          ),
        ),
      );

      // Edit icon should show disabled tooltip and not call
      final editIcon = find.byTooltip('Cannot edit after registrations');
      expect(editIcon, findsOneWidget);
      await tester.tap(editIcon);
      expect(editCalled, isFalse);

      // Delete icon should show disabled tooltip and not call
      final deleteIcon = find.byTooltip('Cannot delete after registrations');
      expect(deleteIcon, findsOneWidget);
      await tester.tap(deleteIcon);
      expect(deleteCalled, isFalse);
    });
  });
}
