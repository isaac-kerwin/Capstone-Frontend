import 'package:first_app/screens/organiser_dashboard/create_event/screen4_questions.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/form_widgets.dart';
import 'package:first_app/widgets/action_button.dart';


class EditBankInformationPage extends StatefulWidget {
  final Map<String, dynamic> eventData; 

  const EditBankInformationPage({
    super.key,
    required this.eventData,
  });

  @override
  State<EditBankInformationPage> createState() =>
      _EditBankInformationPageState();
}

class _EditBankInformationPageState extends State<EditBankInformationPage> {
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bsbController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Account Name
            buildTextField(label: "Account Name", controller: _accountNameController),
            const SizedBox(height: 16),
            // Account Number
            buildTextField(label: "Account Number", controller: _accountNumberController, isNumber: true),
            const SizedBox(height: 16),
            // BSB
            buildTextField(label: "BSB", controller: _bsbController, isNumber: true),
            const SizedBox(height: 24),
            // Continue Button
            ActionButton(
              onPressed: _onContinue,
              text: 'Continue',
              icon: Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }

  void _onContinue() {
    final accountName = _accountNameController.text.trim();
    final accountNumber = _accountNumberController.text.trim();
    final bsb = _bsbController.text.trim();

    // Basic validation
    if (accountName.isEmpty || accountNumber.isEmpty || bsb.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all bank fields!')),
      );
      return;
    }

    widget.eventData['accountName'] = accountName;  
    widget.eventData['accountNumber'] = accountNumber;
    widget.eventData['bsb'] = bsb;

    //Print all widget.eventData data to console for debugging 
    print('Event Data: ${widget.eventData['eventName']}');
    
    // Navigate to the CreateRegistrationFormPage with all data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEventQuestions(
          eventData : widget.eventData
        ),
      ),
    );
  }
}
