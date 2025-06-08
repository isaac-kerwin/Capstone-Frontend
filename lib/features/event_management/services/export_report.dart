import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:app_mobile_frontend/features/event_management/services/date_and_time_parser.dart';


Future<File> exportReportAsPdf(Map<String, dynamic> report) async {
  final pdf = pw.Document();

  final fontBase  = await PdfGoogleFonts.robotoRegular();
  final fontBold  = await PdfGoogleFonts.robotoBold();
  // Collect all unique question texts for columns
  final participants = report['participants'] as List? ?? [];
  final Set<String> questionSet = {};
  for (final p in participants.cast<Map<String, dynamic>>()) {
    final responses = p['questionnaireResponses'] as List? ?? p['questionnairreResponses'] as List? ?? [];
    for (final resp in responses.cast<Map<String, dynamic>>()) {
      if (resp.containsKey('question')) {
        questionSet.add(resp['question']);
      }
    }
  }
  final List<String> questionColumns = questionSet.toList();

  // Format start and end date/time
  String startStr = '';
  String endStr = '';
  try {
    if (report['start'] != null) {
      final startDate = DateTime.parse(report['start']);
      startStr = '${formatDateAsWords(startDate)} at ${formatTimeAmPm(startDate)}';
    }
    if (report['end'] != null) {
      final endDate = DateTime.parse(report['end']);
      endStr = '${formatDateAsWords(endDate)} at ${formatTimeAmPm(endDate)}';
    }
  } catch (_) {}

  pdf.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(base: fontBase, bold: fontBold),
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Text(report['eventName'] ?? '', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text(report['eventDescription'] ?? ''),
        pw.SizedBox(height: 8),
        pw.Text('Start: $startStr'),
        pw.Text('End: $endStr'),
        pw.Divider(),
        pw.Text('Sales', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Total Tickets: ${report['sales']?['totalTickets'] ?? ''}'),
        pw.Text('Revenue: \$${report['sales']?['revenue'] ?? ''}'),
        pw.SizedBox(height: 8),
        pw.Text('Tickets Sold by Type:'),
        ...((report['sales']?['soldByTickets'] ?? []) as List)
            .map<pw.Widget>((t) => pw.Text('${t['name']}: ${t['total']}')),
        pw.SizedBox(height: 8),
        pw.Text('Revenue by Ticket:'),
        ...((report['sales']?['revenueByTickets'] ?? []) as List)
            .map<pw.Widget>((t) => pw.Text('${t['name']}: \$${t['total']}')),
        pw.Divider(),
        pw.Text('Remaining', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Remaining Tickets: ${report['remaining']?['remainingTickets'] ?? ''}'),
        ...((report['remaining']?['remainingByTicket'] ?? []) as List)
            .map<pw.Widget>((r) => pw.Text('${r['name']}: ${r['total']}')),
        pw.Divider(),
        pw.Text('Participants', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text('See next page for full participant table.', style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic)),
      ],
    ),
  );

  // Add participant table on a new landscape page
  pdf.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(base: fontBase, bold: fontBold),
      pageFormat: PdfPageFormat.a4.landscape,
      build: (context) => [
        pw.Text('Participants Table', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 12),
        _buildParticipantsTablePdf(participants, questionColumns),
      ],
    ),
  );

  // Trigger download/share dialog, suffixing if the file exists
  final dir = '/storage/emulated/0/Download';
  final baseName = report['eventName'] ?? 'report';
  String filePath = '$dir/$baseName.pdf';
  File file = File(filePath);
  int counter = 1;
  while (await file.exists()) {
    filePath = '$dir/$baseName($counter).pdf';
    file = File(filePath);
    counter++;
  }
  await file.writeAsBytes(await pdf.save());
  return file;
}

pw.Widget _buildParticipantsTablePdf(List participants, List<String> questionColumns) {
  if (participants.isEmpty) {
    return pw.Text('No participants.');
  }

  return pw.Table.fromTextArray(
    headers: [
      'Name',
      'Email',
      'Ticket Type',
      'Registration Status',
      ...questionColumns,
    ],
    data: participants.map<List<String>>((p) {
      Map<String, String> respMap = {};
      final responses = (p['questionnaireResponses'] as List? ?? p['questionnaireResponses'] as List? ?? []).cast<Map<String, dynamic>>();
     for (final resp in responses) {
        if (resp.containsKey('question') && resp.containsKey('response')) {
          // Clean up checkbox list formatting e.g., ["A","B"]
          var respText = resp['response'].toString();
          respText = respText.replaceAll(RegExp(r'[\[\]\"]'), '');
          respText = respText.split(',').map((s) => s.trim()).join(', ');
          respMap[resp['question']] = respText;
        }
      }
      return [
        p['name'] ?? '',
        p['email'] ?? '',
        p['ticket'] ?? '',
        p['registrationStatus'] ?? '',
        ...questionColumns.map((q) => respMap[q] ?? ''),
      ];
    }).toList(),
    cellStyle: const pw.TextStyle(fontSize: 10),
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300,  ),
    cellAlignment: pw.Alignment.centerLeft,
  );
}