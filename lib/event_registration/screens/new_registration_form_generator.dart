import 'package:flutter/material.dart';
import 'package:first_app/models/event.dart';
import 'package:first_app/models/tickets.dart';
import 'package:first_app/network/event.dart';
import 'package:first_app/main_screen.dart';

class RegistrationForm extends StatefulWidget {
  final int eventId;
  const RegistrationForm({Key? key, required this.eventId}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  late Future<EventWithQuestions> eventFuture;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  String? selectedTicket;
  final Map<int, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    eventFuture = getEventById(widget.eventId);
  }

  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the registration data.
      // You can collect the selectedTicket and text field responses here.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Submitted Successfully')),
      );
    
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  _buildTicketDropDown(List<Ticket> tickets) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Select Ticket'),
      value: selectedTicket,
      items: tickets.map((ticket) {
        return DropdownMenuItem<String>(
          value: ticket.name,
          child: Text(ticket.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedTicket = value;
        });
      },
      validator: (value) => value == null ? 'Please select a ticket' : null,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register for Event'),
      ),
      body: FutureBuilder<EventWithQuestions>(
        future: eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No event data found.'));
          }

          final event = snapshot.data!;
          // Initialize controllers for each question if not already done
          for (int i = 0; i < event.questions.length; i++) {
            controllers.putIfAbsent(i, () => TextEditingController());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dynamic questions
                  ...List.generate(event.questions.length, (index) {
                    final question = event.questions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: controllers[index],
                        decoration: InputDecoration(
                          labelText: question.question.questionText,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (question.isRequired &&
                              (value == null || value.isEmpty)) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  // Ticket dropdown
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'Select Ticket'),
                    value: selectedTicket,
                    items: event.tickets.map((ticket) {
                      return DropdownMenuItem<String>(
                        value: ticket.name,
                        child: Text(ticket.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTicket = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a ticket' : null,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 102, 89, 175),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _isSubmitting ? null : _submitForm,
                      child: _isSubmitting
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('PROCEED TO PAYMENT'),
                    ),
                  ),
                ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
