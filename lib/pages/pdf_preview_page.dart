import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../models/resume_data.dart';

// Import each template file
import '../templates/classic_template.dart';
import '../templates/modern_template.dart';
import '../templates/elegant_template.dart';
import '../templates/premiumtemplate.dart';
import '../templates/professional_template.dart';
import '../templates/creative_template.dart';
import '../templates/minimal_template.dart';

class PdfPreviewPage extends StatelessWidget {
  final ResumeData data;
  final String template;

  const PdfPreviewPage({super.key, required this.data, required this.template});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$template Preview')),
      body: PdfPreview(
        build: (format) => generateTemplate(data, format, template),
      ),
    );
  }

  Future<Uint8List> generateTemplate(
      ResumeData data, PdfPageFormat format, String template) {
    switch (template.toLowerCase()) {
      case 'Classic':
        return generateClassicTemplate(data, format);
      case 'Modern':
        return generateModernTemplate(data, format);
      case 'Elegant':
        return generateElegantTemplate(data, format);
      case 'Professional':
        return generateProfessionalTemplate(data, format);
      case 'Creative':
        return generateCreativeTemplate(data, format);
      case 'Minimal':
        return generateMinimalTemplate(data, format);
      case 'Premium':
        return generatePremiumTemplate(data, format);
      default:
        return generateClassicTemplate(data, format);
    }
  }
}
