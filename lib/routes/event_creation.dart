
import 'package:flutter/material.dart';
import 'package:first_app/screens/organiser_dashboard/create_event/screen1_details.dart';
import 'package:first_app/screens/organiser_dashboard/create_event/screen2_tickets.dart';
import 'package:first_app/screens/organiser_dashboard/create_event/screen3_bank_info.dart';
import 'package:first_app/screens/organiser_dashboard/create_event/screen4_questions.dart';


class EventCreationRoutes{
  static const String prefix = 'organiser_dashboard/create_event';
  static const String detailsScreen = '$prefix/details';
  static const String ticketScreen = '$prefix/tickets';
  static const String bankInfoScreen = '$prefix/bank_info';
  static const String questionsScreen = '$prefix/questions';

  static Map<String, WidgetBuilder> get routes {
    return {
      detailsScreen: (context) => const CreateEventPage(),
      ticketScreen: (context) =>  TicketManagementScreen(eventData: {}),
      bankInfoScreen: (context) => const EditBankInformationPage(eventData: {},),
      questionsScreen: (context) => const CreateEventQuestions(eventData: {},),
    };
  }
}