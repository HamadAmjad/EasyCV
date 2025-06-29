import 'package:flutter/material.dart';
import 'package:myid_pdf_generator/pages/resume_form_page.dart';
import 'package:myid_pdf_generator/pages/template_preview_page.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPremiumUser = false;

  final List<Map<String, dynamic>> templates = [
    {'name': 'Classic', 'file': 'Classic', 'image': 'assets/Templates/Classic.jpg', 'isPremium': false},
    {'name': 'Modern', 'file': 'Modern', 'image': 'assets/Templates/Modern.jpg', 'isPremium': false},
    {'name': 'Elegant', 'file': 'Elegant', 'image': 'assets/Templates/Elegant.jpg', 'isPremium': false},
    {'name': 'Professional', 'file': 'Professional', 'image': 'assets/Templates/Professional.jpg', 'isPremium': false},
    {'name': 'Creative', 'file': 'Creative', 'image': 'assets/Templates/Creative.jpg', 'isPremium': false},
    {'name': 'Minimal', 'file': 'Minimal', 'image': 'assets/Templates/Minimal.jpg', 'isPremium': false},
    {'name': 'Premium', 'file': 'Premium', 'image': 'assets/Templates/Premium.jpg', 'isPremium': false},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        /*actions: [
          IconButton(
            icon: Icon(
              isPremiumUser ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
            tooltip: isPremiumUser ? "Premium User" : "Upgrade",
            onPressed: () {
              setState(() {
                isPremiumUser = !isPremiumUser;
              });
            },
          )
        ],*/

        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'EasyCV',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: templates.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.48, // Adjust this to control card height
          ),
          itemBuilder: (context, index) {
            final template = templates[index];
            final isPremium = template['isPremium'] == true;

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: InteractiveViewer(
                              child: Image.asset(template['image'], fit: BoxFit.contain),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            template['image'],
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      template['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isPremium)
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      isPremium ? "Premium template" : "Free template",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye, size: 20),
                          tooltip: "Preview",
                          onPressed: () {
                            if (isPremium && !isPremiumUser) {
                              _showUpgradeDialog();
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PreviewPage(templateName: template['file']),
                                ),
                              );
                            }
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text("Edit", style: TextStyle(fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            if (isPremium && !isPremiumUser) {
                              _showUpgradeDialog();
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FormPage(selectedTemplate: template['file']),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Upgrade to Premium"),
            content: const Text(
                "This is a premium template. Upgrade to unlock all templates."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel",style: TextStyle(color: Colors.teal),),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  setState(() {
                    isPremiumUser = true; // Simulate upgrade
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Upgraded to Premium!"),
                      backgroundColor: Colors.teal,
                    ),
                  );
                },
                child: const Text("Upgrade",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
    );
  }
}