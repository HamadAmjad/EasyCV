import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_data.dart';

Future<Uint8List> generateElegantTemplate(ResumeData data, PdfPageFormat format) async {
  final pdf = pw.Document();

  final headerStyle = pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold);
  final subHeaderStyle = pw.TextStyle(fontSize: 12, color: PdfColors.grey700);
  final sectionTitle = pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800);
  final bodyStyle = pw.TextStyle(fontSize: 11, color: PdfColors.grey800);

  pw.Widget buildSection(String title, List<String> items) {
    if (items.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),
        pw.Text(title, style: sectionTitle),
        pw.SizedBox(height: 6),
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
          pw.Center(child: pw.Text(data.name, style: headerStyle)),
          pw.SizedBox(height: 4),
          pw.Center(child: pw.Text('${data.email} | ${data.phone} | ${data.address}', style: subHeaderStyle)),
          pw.Divider(height: 20),

          // Summary
          if (data.summary.trim().isNotEmpty) ...[
            pw.Text('Professional Summary', style: sectionTitle),
            pw.SizedBox(height: 6),
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
            pw.SizedBox(height: 6),
            pw.Wrap(
              spacing: 6,
              runSpacing: 4,
              children: data.skills.map((s) => pw.Text('$s,', style: bodyStyle)).toList(),
            ),
          ],
          //buildSection('Skills', data.skills),



          // Languages
          if (data.languages.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text('Languages', style: sectionTitle),
            pw.SizedBox(height: 6),
            pw.Text(data.languages.join(', '), style: bodyStyle),
          ],

          // Hobbies
          if (data.hobbies.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text('Hobbies', style: sectionTitle),
            pw.SizedBox(height: 6),
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
