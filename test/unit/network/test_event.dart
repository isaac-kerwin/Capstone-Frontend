import 'package:first_app/models/question.dart';
import 'package:first_app/models/tickets.dart';
import 'package:first_app/network/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/network/event.dart';
import 'package:flutter/material.dart';// Needed to initialize Flutter bindings
import 'package:first_app/models/event.dart';
import 'dart:convert';

void main() {
  // Ensure Flutter is initialized before running tests


  WidgetsFlutterBinding.ensureInitialized(); 

  
/*   test('Test Get all events', () async {
    await getAllEvents();
    expect(true, true);
  }); */

  test('Test get Event by id', () async {
    await getEventById(2);
    expect(true, true);
  });

/*   test('Test create event', () async {
    List<TicketDTO> tickets = [
      TicketDTO(name: "test1", description: "test description 1", price: 25.00, 
                quantityTotal: 80, salesStart: DateTime.parse("2025-05-15T00:00:00.000Z"), 
                salesEnd: DateTime.parse("2025-08-14T23:59:59.000Z")),

      TicketDTO(name: "test2", description: "test description 2", price: 30.00,
                quantityTotal: 100, salesStart: DateTime.parse("2025-05-15T00:00:00.000Z"), 
                salesEnd: DateTime.parse("2025-08-14T23:59:59.000Z"))
      ];  

    List<CreateQuestionDTO> questions = [
      CreateQuestionDTO(questionText: "test question 1", isRequired: true, displayOrder: 1),
      CreateQuestionDTO(questionText: "test question 2", isRequired: false, displayOrder: 2),
    ];

    CreateEventDTO event = CreateEventDTO(
      name: "Test Event",
      description: "Event for Testing",
      location: "Melbourne",
      eventType: "SPORTS",
      startDateTime: DateTime.parse("2025-08-15T09:00:00.000Z"),
      endDateTime: DateTime.parse("2025-09-15T09:00:00.000Z"),
      capacity: 100,
      tickets: tickets,
      questions: questions,
    );

    final prettyJson = JsonEncoder.withIndent('  ').convert(event.toJson());
    print(prettyJson);
  

    await createEvent(event); 
    expect(true, true);
  }); */

/*   test('Test update event', () async {
    UpdateEventDTO event = UpdateEventDTO(
      name: "Updated Event",
      description: "Updated Event for Testing",
      location: "Melbourne",
      capacity: 100,
      eventType: "SPORTS",
      startDateTime: DateTime.parse("2025-08-15T09:00:00.000Z"),
      endDateTime: DateTime.parse("2025-09-15T09:00:00.000Z"),
    );

    await updateEvent(2, event); 
    expect(true, true);
  });
 */
  //NOT WORKING IN BACKEND YET
/*   test('Test delete event', () async {
    await loginUser("isaac1@gmail.com", "Isaac123");
    await deleteEvent(1); 
    expect(true, true);
  }); 
 */
  
}