import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/event_registration/screens/participant_information.dart';
import 'package:app_mobile_frontend/models/event.dart';
import 'package:app_mobile_frontend/network/event.dart';
import 'package:app_mobile_frontend/models/registration.dart'; // <-- Import RegistrationTicketDTO

class TicketSelectPage extends StatefulWidget {
  final int eventId;

  const TicketSelectPage({Key? key, required this.eventId}) : super(key: key);

  @override
  _TicketSelectPageState createState() => _TicketSelectPageState();
}

class _TicketSelectPageState extends State<TicketSelectPage> {
  late Future<EventWithQuestions> eventFuture;
  List<dynamic> tickets = [];
  List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    eventFuture = getEventById(widget.eventId);
    eventFuture.then((event) {
      setState(() {
        tickets = event.tickets;
        quantities = List.filled(tickets.length, 0);
      });
    });
  }

  double get totalCost {
    double total = 0;
    for (int i = 0; i < tickets.length; i++) {
      total += (double.tryParse(tickets[i].price) ?? 0.0) * quantities[i];
    }
    return total;
  }

  void _navigateToParticipantForm(List<dynamic> questions) {
    // Build a list of maps instead of RegistrationTicketDTOs
    final List<Map<String, int>> selectedTickets = [];
    final List<String> selectedTicketNames = [];
    for (int i = 0; i < tickets.length; i++) {
      if (quantities[i] > 0) {
        selectedTickets.add({
          'ticketId': tickets[i].id,
          'quantity': quantities[i],
        });
        selectedTicketNames.add(tickets[i].name);
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParticipantInformationScreen(
          eventId: widget.eventId,
          tickets: selectedTickets, // Pass List<Map<String, dynamic>>
          ticketNames: selectedTicketNames,
          questions: questions,
        ),
      ),
    );
  }
  bool get hasSelectedTickets => quantities.any((q) => q > 0);

  Widget ticketTextRow(int index) {
    final isZero = quantities[index] == 0;
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${quantities[index]} ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isZero ? Colors.grey : Colors.black,
            ),
          ),
          Text(
            '${tickets[index].name} (\$${tickets[index].price})',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget ticketSelectColumn(){
    return ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: SizedBox(
                      height: 56,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: quantities[index] > 0
                                ? () {
                                    setState(() {
                                      quantities[index]--;
                                    });
                                  }
                                : null,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: ticketTextRow(index),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                quantities[index]++;
                    });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EventWithQuestions>(
      future: eventFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // tickets and quantities are already set in initState
        return Scaffold(
          appBar: AppBar(title: Text('Select Tickets')),
          body: Column(
            children: [
              Expanded(
                child: ticketSelectColumn(),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalCost.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: hasSelectedTickets ? () => _navigateToParticipantForm(snapshot.data!.questions) : null,
                    child: Text('Enter Your Details'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}