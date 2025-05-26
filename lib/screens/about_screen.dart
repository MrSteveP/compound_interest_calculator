import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'About',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      )),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.info_outline,
                  size: 128, // Large size
                  color: Colors.grey // Or any color you like
                  ),
            ),
            const SizedBox(height: 22),
            Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: 400), // or any width you like
                child: const Text(
                  'Compound Interest Calculator',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8), // Adjust padding as needed
                  child: const Text(
                    'This app helps you create investment strategies and estimate compound interest growth over time.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Version: ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  child: const Text(
                    '1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Author: ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  child: const Text(
                    'Steven Palmer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'GitHub: ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  onTap: () => _launchUrl('https://github.com/MrSteveP'),
                  child: const Text(
                    'https://github.com/MrSteveP',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          Colors.blue, // Ensures underline is blue to match
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Website: ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  onTap: () => _launchUrl('https://www.mrstevenpalmer.com'),
                  child: const Text(
                    'https://www.mrstevenpalmer.com',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          Colors.blue, // Ensures underline is blue to match
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
