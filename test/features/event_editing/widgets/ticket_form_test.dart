import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_editing/widgets/ticket_form.dart';

void main() {
  group('TicketForm Widget Tests', () {
    late TextEditingController nameController;
    late TextEditingController descriptionController;
    late TextEditingController priceController;
    late TextEditingController quantityController;
    late bool pickCalled;
    late bool saveCalled;

    setUp(() {
      nameController = TextEditingController(text: 'Test Name');
      descriptionController = TextEditingController(text: 'Desc');
      priceController = TextEditingController(text: '12.34');
      quantityController = TextEditingController(text: '5');
      pickCalled = false;
      saveCalled = false;
    });

    testWidgets('shows Add Ticket and no Cancel when not editing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketForm(
              nameController: nameController,
              descriptionController: descriptionController,
              priceController: priceController,
              quantityController: quantityController,
              salesStart: null,
              salesEnd: null,
              pickDateTime: (isStart) async { pickCalled = true; },
              saveTicket: () async { saveCalled = true; },
              cancelEditing: null,
              isEditing: false,
            ),
          ),
        ),
      );

      // Add Ticket button
      final addBtn = find.widgetWithText(ElevatedButton, 'Add Ticket');
      expect(addBtn, findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Update Ticket'), findsNothing);
      // Cancel button should not be present
      expect(find.widgetWithText(ElevatedButton, 'Cancel'), findsNothing);

      // Tap Add Ticket
      await tester.tap(addBtn);
      await tester.pumpAndSettle();
      expect(saveCalled, isTrue);
    });

    testWidgets('shows Update Ticket and Cancel when editing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketForm(
              nameController: nameController,
              descriptionController: descriptionController,
              priceController: priceController,
              quantityController: quantityController,
              salesStart: DateTime(2025,1,1,10,0),
              salesEnd: DateTime(2025,1,2,10,0),
              pickDateTime: (isStart) async {
                pickCalled = true;
              },
              saveTicket: () async { saveCalled = true; },
              cancelEditing: () { pickCalled = false; },
              isEditing: true,
            ),
          ),
        ),
      );

      // Update Ticket button
      final updateBtn = find.widgetWithText(ElevatedButton, 'Update Ticket');
      expect(updateBtn, findsOneWidget);

      // Cancel button
      final cancelBtn = find.widgetWithText(ElevatedButton, 'Cancel');
      expect(cancelBtn, findsOneWidget);

      // Tap Cancel
      await tester.tap(cancelBtn);
      await tester.pumpAndSettle();
      // pickCalled was false initially, remains false when cancel
      expect(pickCalled, isFalse);

      // Tap both date pickers
      final startPicker = find.textContaining('Sales Start:');
      await tester.tap(startPicker);
      await tester.pumpAndSettle();
      expect(pickCalled, isTrue);

      pickCalled = false;
      final endPicker = find.textContaining('Sales End:');
      await tester.tap(endPicker);
      await tester.pumpAndSettle();
      expect(pickCalled, isTrue);

      // Tap Update
      await tester.tap(updateBtn);
      await tester.pumpAndSettle();
      expect(saveCalled, isTrue);
    });
  });
}
