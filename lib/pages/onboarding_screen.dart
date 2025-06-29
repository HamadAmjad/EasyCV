import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Welcome!',
      'description': 'Easily create professional resumes with multiple templates.',
    },
    {
      'title': 'Multiple Templates',
      'description': 'Choose from beautifully designed resume layouts.',
    },
    {
      'title': 'Download and Share',
      'description': 'Generate PDF CVs and share them anywhere instantly.',
    },
  ];

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        Text(
                          pages[index]['title']!.replaceAll('EasyCV', '').trim(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (index == 0) ...[
                          const SizedBox(height: 6),
                          const Text(
                            'EasyCV',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ],
                    ),


                    const SizedBox(height: 16),
                    Text(
                      pages[index]['description']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: _currentPage == index ? 20 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.teal : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text("Skip",style: TextStyle(color: Colors.teal),),
                  onPressed: _finishOnboarding,
                ),
                ElevatedButton(
                  child: Text(_currentPage == pages.length - 1 ? "Start" : "Next",style: TextStyle(color: Colors.teal),),
                  onPressed: () {
                    if (_currentPage == pages.length - 1) {
                      _finishOnboarding();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
