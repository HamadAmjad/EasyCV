import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_data.dart';

Future<Uint8List> generateModernTemplate(ResumeData data, PdfPageFormat format) async {
  final pdf = pw.Document();

  final headingStyle = pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900);
  final subheadingStyle = pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800);
  final bodyStyle = pw.TextStyle(fontSize: 11, color: PdfColors.grey800);

  pw.Widget buildSection(String title, List<String> items) {
    if (items.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: subheadingStyle),
        pw.SizedBox(height: 6),
        ...items.map((e) => pw.Bullet(text: e, style: bodyStyle)),
        pw.SizedBox(height: 14),
      ],
    );
  }

  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) => pw.Container(
        color: PdfColors.grey100,
        padding: const pw.EdgeInsets.all(30),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Top Name & Contact
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Text(data.name, style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(width: 16),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(data.email, style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                    pw.Text(data.phone, style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                    pw.Text(data.address, style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Summary
            if (data.summary.trim().isNotEmpty) ...[
              pw.Text('Professional Summary', style: subheadingStyle),
              pw.SizedBox(height: 6),
              pw.Text(data.summary, style: bodyStyle),
              pw.SizedBox(height: 14),
            ],

            // Experience
            buildSection('Work Experience', data.experiences),

            // Education
            buildSection('Education', data.education),
            // Achievements
            buildSection('Achievements', data.achievements),

            // Certifications
            buildSection('Certifications', data.certifications),
            /*if (data.certifications.isNotEmpty) ...[
              pw.Text('Certifications', style: subheadingStyle),
              pw.SizedBox(height: 6),
              pw.Text(data.certifications.join(', '), style: bodyStyle),
              pw.SizedBox(height: 14),
            ],*/
            // Skills
            if (data.skills.isNotEmpty) ...[
              pw.Text('Skills', style: subheadingStyle),
              pw.SizedBox(height: 6),
              pw.Text(data.skills.join(', '), style: bodyStyle),
              pw.SizedBox(height: 14),
            ],



            // Languages
            if (data.languages.isNotEmpty) ...[
              pw.Text('Languages', style: subheadingStyle),
              pw.SizedBox(height: 6),
              pw.Text(data.languages.join(', '), style: bodyStyle),
              pw.SizedBox(height: 14),
            ],

            // Hobbies
            if (data.hobbies.isNotEmpty) ...[
              pw.Text('Hobbies', style: subheadingStyle),
              pw.SizedBox(height: 6),
              pw.Text(data.hobbies.join(', '), style: bodyStyle),
              pw.SizedBox(height: 14),
            ],


            // References
            //buildSection('References', data.references),
            if (data.references.isNotEmpty) ...[
              pw.Text('References', style: subheadingStyle),
              pw.SizedBox(height: 6),
              pw.Text(data.references.join(', '), style: bodyStyle),
              pw.SizedBox(height: 14),
            ],
          ],
        ),
      ),
    ),
  );

  return Uint8List.fromList(await pdf.save());
}
