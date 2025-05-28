import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';


Future<File> exportReportAsPdf(Map<String, dynamic> report) async {
  final pdf = pw.Document();

  final fontBase  = await PdfGoogleFonts.robotoRegular();
  final fontBold  = await PdfGoogleFonts.robotoBold();
  // Collect all unique question texts for columns
  final participants = report['participants'] ?? [];
  final Set<String> questionSet = {};
  for (final p in participants) {
    for (final resp in (p['questionnaireResponses'] ?? [])) {
      if (resp.containsKey('question')) {
        questionSet.add(resp['question']);
      }
    }
  }
  final List<String> questionColumns = questionSet.toList();

  pdf.addPage(
    pw.MultiPage(
        theme: pw.ThemeData.withFont(base: fontBase, bold: fontBold),
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Text(report['eventName'] ?? '', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text(report['eventDescription'] ?? ''),
        pw.SizedBox(height: 8),
        pw.Text('Start: ${report['start'] ?? ''}'),
        pw.Text('End: ${report['end'] ?? ''}'),
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
        _buildParticipantsTablePdf(participants, questionColumns),
      ],
    ),
  );

  // Trigger download/share dialog
  final output = await getTemporaryDirectory();
  var dir = getDownloadsDirectory();
  final file = File('/storage/emulated/0/Download/${report['eventName']}.pdf');
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
      ...questionColumns,
    ],
    data: participants.map<List<String>>((p) {
      Map<String, String> respMap = {};
      for (final resp in (p['questionnaireResponses'] ?? [])) {
        if (resp.containsKey('question') && resp.containsKey('response')) {
          respMap[resp['question']] = resp['response'].toString();
        }
      }
      return [
        p['name'] ?? '',
        p['email'] ?? '',
        p['ticket'] ?? '',
        ...questionColumns.map((q) => respMap[q] ?? ''),
      ];
    }).toList(),
    cellStyle: const pw.TextStyle(fontSize: 10),
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300,  ),
    cellAlignment: pw.Alignment.centerLeft,
  );
}