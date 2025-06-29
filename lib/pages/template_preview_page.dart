import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:myid_pdf_generator/templates/premiumtemplate.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../models/resume_data.dart';
import '../templates/classic_template.dart';
import '../templates/modern_template.dart';
import '../templates/elegant_template.dart';
import '../templates/professional_template.dart';
import '../templates/creative_template.dart';
import '../templates/minimal_template.dart';

class PreviewPage extends StatelessWidget {
  final String templateName;

  const PreviewPage({super.key, required this.templateName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal, title: Text("Preview - $templateName", style: TextStyle(color: Colors.white),),),
      body: PdfPreview(actionBarTheme: PdfActionBarTheme(backgroundColor: Colors.teal),
        build: (format) => _generateTemplate(templateName, format),
      ),
    );
  }

  Future<Uint8List> _generateTemplate(String name, PdfPageFormat format) {
    final dummyData = ResumeData(
      name: 'John Doe',
      email: 'john@example.com',
      phone: '123-456-7890',
      summary: 'Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged',
      skills: ['Flutter', 'Dart', 'Firebase', 'Git'],
      experiences: ['Flutter Developer at XYZ Corp', 'Intern at ABC Inc'],
      education: ['B.Sc in Computer Science - XYZ University'],
      certifications: ['Flutter Certified Developer'],
      languages: ['English', 'Spanish'],
      achievements: ['Gold Medalist in Coding Competition'],
      hobbies: ['Football', 'Coding', 'Movies'],
      references: ['None'],
      address: 'Manchester, England ',
    );

    switch (name) {
      case 'Classic':
        return generateClassicTemplate(dummyData, format);
      case 'Modern':
        return generateModernTemplate(dummyData, format);
      case 'Elegant':
        return generateElegantTemplate(dummyData, format);
      case 'Professional':
        return generateProfessionalTemplate(dummyData, format);
      case 'Creative':
        return generateCreativeTemplate(dummyData, format);
      case 'Minimal':
        return generateMinimalTemplate(dummyData, format);
      case 'Premium':
        return generatePremiumTemplate(dummyData, format);
      default:
        return generateClassicTemplate(dummyData, format);
    }
  }
}
