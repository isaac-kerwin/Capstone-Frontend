import 'package:flutter/material.dart';

class ParticipantsTable extends StatelessWidget {
  final List participantsData;

  const ParticipantsTable({super.key, required this.participantsData});

  @override
  Widget build(BuildContext context) {
    if (participantsData.isEmpty) {
      return const Text('No participants.');
    }

    // Collect all unique question texts for columns
    final Set<String> questionSet = {};
    for (final p in participantsData) {
      final responses = p['questionnaireResponses'] ?? p['questionnairreResponses'] ?? [];
      for (final resp in responses) {
        if (resp.containsKey('question')) {
          questionSet.add(resp['question']);
        }
      }
    }
    final List<String> questionColumns = questionSet.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          const DataColumn(label: Text('Name')),
          const DataColumn(label: Text('Email')),
          const DataColumn(label: Text('Ticket Type')),
          ...questionColumns.map((q) => DataColumn(label: Text(q))),
        ],
        rows: participantsData.map<DataRow>((p) {
          Map<String, String> respMap = {};
          final responses = p['questionnaireResponses'] ?? p['questionnairreResponses'] ?? [];
          for (final resp in responses) {
            if (resp.containsKey('question') && resp.containsKey('response')) {
              var respText = resp['response'].toString();
              // Corrected regex to only remove square brackets and double quotes
              respText = respText.replaceAll(RegExp(r'[\[\]"]'), ''); 
              respText = respText.split(',').map((s) => s.trim()).join(', ');
              respMap[resp['question']] = respText;
            }
          }
          return DataRow(
            cells: [
              DataCell(Text(p['name'] ?? '')),
              DataCell(Text(p['email'] ?? '')),
              DataCell(Text(p['ticket'] ?? '')),
              ...questionColumns.map((q) => DataCell(Text(respMap[q] ?? ''))),
            ],
          );
        }).toList(),
      ),
    );
  }
}
