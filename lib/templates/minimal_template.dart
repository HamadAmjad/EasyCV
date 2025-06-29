import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_data.dart';

Future<Uint8List> generateMinimalTemplate(ResumeData data, PdfPageFormat format) async {
  final pdf = pw.Document();

  final nameStyle = pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold);
  final headerStyle = pw.TextStyle(fontSize: 15, color: PdfColors.grey900);
  final sectionTitle = pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, color: PdfColors.black);
  final bodyStyle = pw.TextStyle(fontSize: 11, color: PdfColors.grey800);

  pw.Widget buildSection(String title, List<String> items) {
    if (items.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),
        pw.Text(title, style: sectionTitle),
        pw.SizedBox(height: 4),
        ...items.map((e) => pw.Bullet(text: e, style: bodyStyle)),
      ],
    );
  }

  pdf.addPage(
    pw.Page(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(24),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(data.name, style: nameStyle),
          pw.SizedBox(height: 2),
          pw.Text(data.email, style: headerStyle),
          pw.Text(data.phone, style: headerStyle),
          pw.Text(data.address, style: headerStyle),
          pw.Divider(),

          // Summary
          if (data.summary.trim().isNotEmpty) ...[
            pw.Text('Summary', style: sectionTitle),
            pw.SizedBox(height: 4),
            pw.Text(data.summary, style: bodyStyle),
          ],



          // Experience
          buildSection('Experience', data.experiences),

          // Education
          buildSection('Education', data.education),
          // Achievements
          buildSection('Achievements', data.achievements),


          // Certifications
          if (data.certifications.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text('Certifications', style: sectionTitle),
            pw.SizedBox(height: 4),
            pw.Text(data.certifications.join(', '), style: bodyStyle),
          ],
          // Skills
          if (data.skills.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text('Skills', style: sectionTitle),
            pw.SizedBox(height: 4),
            pw.Text(data.skills.join(', '), style: bodyStyle),
          ],

          // Languages
          if (data.languages.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text('Languages', style: sectionTitle),
            pw.SizedBox(height: 4),
            pw.Text(data.languages.join(', '), style: bodyStyle),
          ],

          // Hobbies
          if (data.hobbies.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text('Hobbies', style: sectionTitle),
            pw.SizedBox(height: 4),
            pw.Text(data.hobbies.join(', '), style: bodyStyle),
          ],


          // References
          buildSection('References', data.references),
        ],
      ),
    ),
  );

  return Uint8List.fromList(await pdf.save());
}
