import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_mobile_frontend/features/event_editing/widgets/ticket_tile.dart';
import 'package:app_mobile_frontend/core/models/ticket_models.dart';

void main() {
  group('TicketTile Widget Tests', () {
    late Ticket sampleTicket;
    late bool editCalled;
    late bool deleteCalled;

    setUp(() {
      sampleTicket = Ticket(
        id: 1,
        eventId: 100,
        name: 'Original Name',
        description: 'Desc',
        price: '10.0',
        quantityTotal: 5,
        quantitySold: 0,
        salesStart: DateTime(2025,1,1),
        salesEnd: DateTime(2025,1,2),
        status: 'ACTIVE',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      editCalled = false;
      deleteCalled = false;
    });

    testWidgets('displays ticket name and invokes edit callback when editable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: sampleTicket,
              canDelete: true,
              onEdit: () => editCalled = true,
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Original Name'), findsOneWidget);
      final editButton = find.widgetWithIcon(IconButton, Icons.edit);
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      expect(editCalled, isTrue);
    });

    testWidgets('delete button disabled when canDelete is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: sampleTicket,
              canDelete: false,
              onEdit: () => editCalled = true,
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      final deleteButton = find.widgetWithIcon(IconButton, Icons.delete);
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      expect(deleteCalled, isFalse);
    });
  });
}
