import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_data.dart';

Future<Uint8List> generatePremiumTemplate(ResumeData data, PdfPageFormat format) async {
  final pdf = pw.Document();

  final baseColor = PdfColors.blueGrey800;
  final accentColor = PdfColors.teal600;

  final nameStyle = pw.TextStyle(
    fontSize: 24,
    fontWeight: pw.FontWeight.bold,
    color: accentColor,
  );

  final headingStyle = pw.TextStyle(
    fontSize: 16,
    fontWeight: pw.FontWeight.bold,
    color: accentColor,
  );

  final bodyStyle = pw.TextStyle(
    fontSize: 12.5,
    color: PdfColors.black,
  );

  pw.Widget buildSection(String title, List<String> items) {
    if (items.isEmpty) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: headingStyle),
        pw.SizedBox(height: 4),
        ...items.map((e) => pw.Bullet(text: e, style: bodyStyle)),
        pw.SizedBox(height: 12),
      ],
    );
  }

  pdf.addPage(
    pw.Page(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(24),
      build: (context) {
        return pw.Column(
          children: [
            // ---------- Header ----------
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(data.name, style: nameStyle),
                    pw.SizedBox(height: 6),
                    if (data.phone.isNotEmpty)
                      pw.Text(data.phone, style: bodyStyle),
                    if (data.email.isNotEmpty)
                      pw.Text(data.email, style: bodyStyle),
                    if (data.address.isNotEmpty)
                      pw.Text(data.address, style: bodyStyle),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 16),
            pw.Divider(color: PdfColors.grey400),

            pw.SizedBox(height: 12),

            // ---------- Body ----------
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // LEFT COLUMN
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (data.summary.isNotEmpty) ...[
                        pw.Text("Summary", style: headingStyle),
                        pw.SizedBox(height: 4),
                        pw.Text(data.summary, style: bodyStyle),
                        pw.SizedBox(height: 12),
                      ],
                      if (data.skills.isNotEmpty)
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Skills", style: headingStyle),
                            pw.SizedBox(height: 6),
                            pw.Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: data.skills
                                  .map((e) => pw.Container(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: pw.BoxDecoration(
                                  color: PdfColors.grey200,
                                  borderRadius: pw.BorderRadius.circular(4),
                                ),
                                child: pw.Text(e, style: bodyStyle),
                              ))
                                  .toList(),
                            ),
                            pw.SizedBox(height: 12),
                          ],
                        ),
                      if (data.hobbies.isNotEmpty)
                        buildSection("Hobbies", data.hobbies),
                    ],
                  ),
                ),

                // VERTICAL DIVIDER
                pw.Container(
                  width: 1,
                  height: 600, // Adjust as needed
                  color: PdfColors.grey400,
                  margin: const pw.EdgeInsets.symmetric(horizontal: 16),
                ),

                // RIGHT COLUMN
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (data.education.isNotEmpty)
                        buildSection("Education", data.education),

                      if (data.experiences.isNotEmpty)
                        buildSection("Experience", data.experiences),

                      if (data.certifications.isNotEmpty)
                        buildSection("Certifications", data.certifications),

                      if (data.achievements.isNotEmpty)
                        buildSection("Achievements", data.achievements),

                      if (data.languages.isNotEmpty)
                        buildSection("Languages", data.languages),


                      if (data.references.isNotEmpty)
                        buildSection("References", data.references),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  return Uint8List.fromList(await pdf.save());
}
