import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_data.dart';

Future<Uint8List> generateCreativeTemplate(ResumeData data, PdfPageFormat format) async {
  final pdf = pw.Document();

  final headerTextStyle = pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.white);
  final sectionTitleStyle = pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold);
  final bodyTextStyle = pw.TextStyle(fontSize: 12);

  pw.Widget buildSection(String title, List<String> items) {
    if (items.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: sectionTitleStyle),
        pw.SizedBox(height: 4),
        ...items.map((e) => pw.Bullet(text: e, style: bodyTextStyle)),
        pw.SizedBox(height: 12),
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
          // Header
          pw.Container(
            width: double.infinity,
            color: PdfColors.blueGrey800,
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(data.name, style: headerTextStyle),
                pw.SizedBox(height: 4),
                pw.Text(data.email, style: pw.TextStyle(color: PdfColors.grey100)),
                pw.Text(data.phone, style: pw.TextStyle(color: PdfColors.grey100)),
                pw.Text(data.address, style: pw.TextStyle(color: PdfColors.grey100)),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // Profile
          if (data.summary.trim().isNotEmpty) ...[
            pw.Text('Profile', style: sectionTitleStyle),
            pw.SizedBox(height: 4),
            pw.Text(data.summary, style: bodyTextStyle),
            pw.SizedBox(height: 12),
          ],

          // Skills
          if (data.skills.isNotEmpty) ...[
            pw.Text('Skills', style: sectionTitleStyle),
            pw.SizedBox(height: 4),
            pw.Wrap(
              spacing: 8,
              runSpacing: 4,
              children: data.skills.map((skill) => pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blueGrey100,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(skill, style: bodyTextStyle),
              )).toList(),
            ),
            pw.SizedBox(height: 12),
          ],

          // Experience
          buildSection('Experience', data.experiences),

          // Education
          buildSection('Education', data.education),
          // Achievements
          buildSection('Achievements', data.achievements),


          // Certifications
          buildSection('Certifications', data.certifications),

          // Languages
          //buildSection('Languages', data.languages),
          if (data.languages.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text('Languages', style: sectionTitleStyle),
            pw.SizedBox(height: 4),
            pw.Text(data.languages.join(' , '), style: bodyTextStyle),
          ],

          // Hobbies
          //buildSection('Hobbies', data.hobbies),
          if (data.hobbies.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text('Hobbies', style: sectionTitleStyle),
            pw.SizedBox(height: 4),
            pw.Text(data.hobbies.join(' , '), style: bodyTextStyle),
          ],

          pw.SizedBox(height: 12),
          // References
          buildSection('References', data.references),
        ],
      ),
    ),
  );

  return Uint8List.fromList(await pdf.save());
}
