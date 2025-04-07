import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import '../../models/participant.dart';


class ReportService {
  Future<File> generatePdfReport(List<Participant> participants) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Melbourne Italian Festa 2024', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text('Participant Report', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 5),
            pw.Text('Generated: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}'),
            pw.Divider(),
          ],
        ),
        footer: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text('Page ${context.pageNumber} of ${context.pagesCount}'),
          ],
        ),
        build: (context) => [
          pw.Table.fromTextArray(
            headers: ['ID', 'Name', 'Email', 'Phone', 'Ticket Type', 'Registration Date', 'Checked In'],
            data: participants.map((p) => [
              p.id,
              p.name,
              p.email,
              p.phone,
              p.ticketType,
              DateFormat('dd/MM/yyyy').format(p.registrationDate),
              p.checkedIn ? 'Yes' : 'No',
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerLeft,
              4: pw.Alignment.centerLeft,
              5: pw.Alignment.centerLeft,
              6: pw.Alignment.centerLeft,
            },
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Participants: ${participants.length}'),
              pw.Text('Checked In: ${participants.where((p) => p.checkedIn).length}'),
            ],
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/melbourne_italian_festa_participants.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File> generateCsvReport(List<Participant> participants) async {
    List<List<dynamic>> rows = [];
    
    // Add header row
    rows.add(['ID', 'Name', 'Email', 'Phone', 'Ticket Type', 'Registration Date', 'Checked In']);
    
    // Add data rows
    for (var p in participants) {
      rows.add([
        p.id,
        p.name,
        p.email,
        p.phone,
        p.ticketType,
        DateFormat('dd/MM/yyyy').format(p.registrationDate),
        p.checkedIn ? 'Yes' : 'No',
      ]);
    }
    
    String csv = const ListToCsvConverter().convert(rows);
    
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/melbourne_italian_festa_participants.csv');
    await file.writeAsString(csv);
    return file;
  }
}