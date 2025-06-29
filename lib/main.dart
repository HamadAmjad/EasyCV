import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'pages/onboarding_screen.dart'; 
import 'pages/resume_form_page.dart';
import 'pages/pdf_preview_page.dart';
import 'models/resume_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required before SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(ResumeApp(showOnboarding: !hasSeenOnboarding));
}
class ResumeApp extends StatelessWidget {
  final bool showOnboarding;
  const ResumeApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Builder',
      debugShowCheckedModeBanner: false,
      home: showOnboarding ? const OnboardingScreen() : HomePage(),
      onGenerateRoute: (settings) {
        if (settings.name == '/preview') {
          final args = settings.arguments as Map<String, dynamic>;
          final ResumeData data = args['data'];
          final String template = args['template'];
          return MaterialPageRoute(
            builder: (_) => PdfPreviewPage(data: data, template: template),
          );
        }
        return null;
      },
    );
  }
}
