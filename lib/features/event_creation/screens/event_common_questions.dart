
import 'package:app_mobile_frontend/features/event_creation/screens/event_questions.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_frontend/models/question.dart';
 
 class CommonQuestions extends StatefulWidget {
   Map<String, dynamic> eventData = {};
   CommonQuestions({required this.eventData, super.key});
  
 
   @override
   State<CommonQuestions> createState() => _CommonQuestionsState();
 }
 
 class _CommonQuestionsState extends State<CommonQuestions> {
   bool enablePhoneNumber = false;
   bool enableDOB = false;
   bool enableEmergencyContact = false;
   bool enablePrefferedName = false;
   bool enableCompanyName = false;
  
   _addToggledQuestions(enablePhoneNumber, enableDOB, questions) {
      if (enablePhoneNumber) {
          questions.add(CreateQuestionDTO(
            questionText: 'Phone Number',
            isRequired: true,
            displayOrder: questions.length + 1,
            questionType: "text"
          ));
      }
      if (enableDOB) {
          questions.add(CreateQuestionDTO(
            questionText: 'Date of Birth',
            isRequired: true,
            displayOrder: questions.length + 1,
            questionType: "text"
          ));
      }
      if (enableEmergencyContact) {
      questions.add(CreateQuestionDTO(
        questionText: 'Emergency Contact',
        isRequired: true,
        displayOrder: questions.length + 1,
        questionType: "text"
      ));
      }
      if (enablePrefferedName) {
      questions.add(CreateQuestionDTO(
        questionText: 'Preferred Name',
        isRequired: true,
        displayOrder: questions.length + 1,
        questionType: "text"
      ));
      }
      if (enableCompanyName) {
      questions.add(CreateQuestionDTO(
        questionText: 'Company Name',
        isRequired: true,
        displayOrder: questions.length + 1,
        questionType: "text"
      ));
      }
      
   }

    _onContinue() {
      List<CreateQuestionDTO> questions = [];
      widget.eventData['questions'] = questions;  
      _addToggledQuestions(enablePhoneNumber, enableDOB, questions);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CreateEventQuestions(
            eventData: widget.eventData,
          ),
        ),
      );
   }
 
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: const Text('Add Common Questions')),
       body: SingleChildScrollView(
         padding: const EdgeInsets.all(16),
         child: Column(
           children: [
             SwitchListTile(
               title: const Text('Phone Number'),
               value: enablePhoneNumber,
               onChanged: (bool value) {
                 setState(() {
                   enablePhoneNumber = value;
                 });
               },
             ),
             SwitchListTile(
               title: const Text('Date of Birth'),
               value: enableDOB,
               onChanged: (bool value) {
                 setState(() {
                   enableDOB = value;
                 });
               },
             ),
              SwitchListTile(
                title: const Text('Emergency Contact'),
                value: enableEmergencyContact,
                onChanged: (bool value) {
                  setState(() {
                    enableEmergencyContact = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Preferred Name'),
                value: enablePrefferedName,
                onChanged: (bool value) {
                  setState(() {
                    enablePrefferedName = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Company Name'),
                value: enableCompanyName,
                onChanged: (bool value) {
                  setState(() {
                    enableCompanyName = value;
                  });
                },
              ),

             const SizedBox(height: 20),
             ElevatedButton(
               onPressed: () {
                _onContinue();
               },
               child: const Text('Continue'),
             ),
           ],
         ),
       ),
     );
   }
 }