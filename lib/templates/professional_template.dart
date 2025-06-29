import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_data.dart';

Future<Uint8List> generateProfessionalTemplate(ResumeData data, PdfPageFormat format) async {
  final pdf = pw.Document();

  final titleStyle = pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold);
  final headerStyle = pw.TextStyle(fontSize: 12, color: PdfColors.grey900);
  final sectionTitle = pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColors.black);
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
      margin: const pw.EdgeInsets.all(30),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header
          pw.Text(data.name.toUpperCase(), style: titleStyle),
          pw.SizedBox(height: 2),
          pw.Text('Contact: ${data.phone} | ${data.email} | ${data.address}', style: headerStyle),
          pw.Divider(),

          // Objective / Summary
          if (data.summary.trim().isNotEmpty) ...[
            pw.Text('Career Objective', style: sectionTitle),
            pw.SizedBox(height: 4),
            pw.Text(data.summary, style: bodyStyle),
          ],



          // Experience
          buildSection('Experience', data.experiences),
          // Education
          buildSection('Education', data.education),
          // Certifications
          buildSection('Certifications', data.certifications),
          // Achievements
          buildSection('Achievements', data.achievements),


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
