import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_data.dart';

Future<Uint8List> generateClassicTemplate(ResumeData data, PdfPageFormat format) async {
  final pdf = pw.Document();

  final nameStyle = pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold);
  final contactStyle = pw.TextStyle(fontSize: 14, color: PdfColors.grey700);
  final sectionTitleStyle = pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.black);
  final bodyStyle = pw.TextStyle(fontSize: 11);

  pw.Widget buildSection(String title, List<String> items) {
    if (items.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: sectionTitleStyle),
        pw.SizedBox(height: 4),
        ...items.map((e) => pw.Bullet(text: e, style: bodyStyle)),
        pw.SizedBox(height: 12),
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
          pw.Text(data.name, style: nameStyle),
          pw.SizedBox(height: 4),
          pw.Text('${data.email} | ${data.phone} | ${data.address}', style: contactStyle),
          pw.SizedBox(height: 12),
          pw.Divider(),

          // Summary
          if (data.summary.trim().isNotEmpty) ...[
            pw.Text('Professional Summary', style: sectionTitleStyle),
            pw.SizedBox(height: 4),
            pw.Text(data.summary, style: bodyStyle),
            pw.SizedBox(height: 12),
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
            pw.Text('Skills', style: sectionTitleStyle),
            pw.SizedBox(height: 4),
            pw.Text(data.skills.join(', '), style: bodyStyle),
            pw.SizedBox(height: 12),
          ],


          // Languages
          //buildSection('Languages', data.languages),
          if (data.languages.isNotEmpty) ...[
            pw.Text('Languages', style: sectionTitleStyle),
            pw.SizedBox(height: 4),
            pw.Text(data.languages.join(', '), style: bodyStyle),
            pw.SizedBox(height: 12),
          ],
          // Hobbies
          //buildSection('Hobbies', data.hobbies),
          if (data.hobbies.isNotEmpty) ...[
            pw.Text('Hobbies', style: sectionTitleStyle),
            pw.SizedBox(height: 4),
            pw.Text(data.hobbies.join(', '), style: bodyStyle),
            pw.SizedBox(height: 12),
          ],


          // References
          //buildSection('References', data.references),
          if (data.references.isNotEmpty) ...[
            pw.Text('References', style: sectionTitleStyle),
            pw.SizedBox(height: 4),
            pw.Text(data.references.join(', '), style: bodyStyle),
            pw.SizedBox(height: 12),
          ],
        ],
      ),
    ),
  );

  return Uint8List.fromList(await pdf.save());
}
