
import 'package:first_app/event_creation/screens/event_questions.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/question.dart';
 
 class CommonQuestions extends StatefulWidget {
   Map<String, dynamic> eventData = {};
   CommonQuestions({required this.eventData, super.key});
  
 
   @override
   State<CommonQuestions> createState() => _CommonQuestionsState();
 }
 
 class _CommonQuestionsState extends State<CommonQuestions> {
   bool enableFirstName = false;
   bool enableLastName = false;
   bool enablePhoneNumber = false;
   bool enableDOB = false;

   _addToggledQuestions(enableFirstName, enableLastName, enablePhoneNumber, enableDOB, questions) {

      if (enableFirstName) {
          questions.add(CreateQuestionDTO(
            questionText: 'First Name',
            isRequired: true,
            displayOrder: 1,
          ));
      }
      if (enableLastName) {
          questions.add(CreateQuestionDTO(
            questionText: 'Last Name',
            isRequired: true,
            displayOrder: 2,
          ));
      }
      if (enablePhoneNumber) {
          questions.add(CreateQuestionDTO(
            questionText: 'Phone Number',
            isRequired: true,
            displayOrder: 3,
          ));
      }
      if (enableDOB) {
          questions.add(CreateQuestionDTO(
            questionText: 'Date of Birth',
            isRequired: true,
            displayOrder: 4,
          ));
      }
   }

    _onContinue() {
      List<CreateQuestionDTO> questions = [];
      _addToggledQuestions(enableFirstName, enableLastName, enablePhoneNumber, enableDOB, questions);
      widget.eventData['questions'] = questions;  
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
       appBar: AppBar(title: const Text('Select Fields')),
       body: SingleChildScrollView(
         padding: const EdgeInsets.all(16),
         child: Column(
           children: [
             SwitchListTile(
               title: const Text('First Name'),
               value: enableFirstName,
               onChanged: (bool value) {
                 setState(() {
                   enableFirstName = value;
                 });
               },
             ),
             SwitchListTile(
               title: const Text('Last Name'),
               value: enableLastName,
               onChanged: (bool value) {
                 setState(() {
                   enableLastName = value;
                 });
               },
             ),
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