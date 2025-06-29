import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../models/resume_data.dart';
import '../templates/classic_template.dart';
import '../templates/modern_template.dart';
import '../templates/elegant_template.dart';
import '../templates/professional_template.dart';
import '../templates/creative_template.dart';
import '../templates/minimal_template.dart';
import '../templates/premiumtemplate.dart';

class FormPage extends StatefulWidget {
  final String selectedTemplate;

  const FormPage({super.key, required this.selectedTemplate});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final summaryController = TextEditingController();

  List<TextEditingController> skillsControllers = [TextEditingController()];
  List<TextEditingController> educationControllers = [TextEditingController()];
  List<TextEditingController> experienceControllers = [TextEditingController()];
  List<TextEditingController> certificationsControllers = [TextEditingController()];
  List<TextEditingController> languagesControllers = [TextEditingController()];
  List<TextEditingController> achievementsControllers = [TextEditingController()];
  List<TextEditingController> hobbiesControllers = [TextEditingController()];
  List<TextEditingController> referencesControllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Enter Resume Details', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: _generatePdf,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("Required Fields", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
            _buildTextField(nameController, "Full Name", true),
            _buildTextField(emailController, "Email", true),
            _buildTextField(phoneController, "Phone", true),
            _buildTextField(addressController, "Address", true),
            _buildTextField(summaryController, "Professional Summary", true, maxLines: 3),

            const SizedBox(height: 16),
            _buildDynamicListSection("Skills", skillsControllers),
            _buildDynamicListSection("Education", educationControllers),
            _buildDynamicListSection("Experience", experienceControllers),

            const SizedBox(height: 20),
            const Text("Optional Fields", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
            _buildDynamicListSection("Certifications", certificationsControllers, required: false),
            _buildDynamicListSection("Languages", languagesControllers, required: false),
            _buildDynamicListSection("Achievements", achievementsControllers, required: false),
            _buildDynamicListSection("Hobbies", hobbiesControllers, required: false),
            _buildDynamicListSection("References", referencesControllers, required: false),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: _generatePdf,
              child: const Text("Generate PDF", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool required, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (value) => value == null || value.trim().isEmpty ? 'This field is required' : null
            : null,
      ),
    );
  }

  Widget _buildDynamicListSection(String title, List<TextEditingController> controllers, {bool required = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                setState(() {
                  controllers.add(TextEditingController());
                });
              },
            ),
          ],
        ),
        ...controllers.map((controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Enter item",
                border: OutlineInputBorder(),
              ),
              validator: required
                  ? (value) => value == null || value.trim().isEmpty ? 'This field is required' : null
                  : null,
            ),
          );
        }).toList(),
      ],
    );
  }

  void _generatePdf() {
    if (_formKey.currentState!.validate()) {
      final resumeData = ResumeData(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
        summary: summaryController.text,
        skills: _extractValues(skillsControllers),
        education: _extractValues(educationControllers),
        experiences: _extractValues(experienceControllers),
        certifications: _extractValues(certificationsControllers),
        languages: _extractValues(languagesControllers),
        achievements: _extractValues(achievementsControllers),
        hobbies: _extractValues(hobbiesControllers),
        references: _extractValues(referencesControllers),
      );

      Printing.layoutPdf(
        onLayout: (format) => _generateTemplate(widget.selectedTemplate, resumeData, format),
      );
    }
  }

  List<String> _extractValues(List<TextEditingController> controllers) {
    return controllers.map((c) => c.text.trim()).where((text) => text.isNotEmpty).toList();
  }

  Future<Uint8List> _generateTemplate(String name, ResumeData data, PdfPageFormat format) {
    switch (name.toLowerCase()) {
      case 'classic':
        return generateClassicTemplate(data, format);
      case 'modern':
        return generateModernTemplate(data, format);
      case 'elegant':
        return generateElegantTemplate(data, format);
      case 'professional':
        return generateProfessionalTemplate(data, format);
      case 'creative':
        return generateCreativeTemplate(data, format);
      case 'minimal':
        return generateMinimalTemplate(data, format);
      case 'premium':
        return generatePremiumTemplate(data, format);
      default:
        return generateClassicTemplate(data, format);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    summaryController.dispose();
    for (var list in [
      skillsControllers,
      educationControllers,
      experienceControllers,
      certificationsControllers,
      languagesControllers,
      achievementsControllers,
      hobbiesControllers,
      referencesControllers,
    ]) {
      for (var c in list) {
        c.dispose();
      }
    }
    super.dispose();
  }
}
