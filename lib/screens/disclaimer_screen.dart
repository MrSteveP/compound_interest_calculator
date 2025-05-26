import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../utils/disclaimer_prefs.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  Future<String> loadDisclaimerHtml() async {
    return await rootBundle.loadString('assets/disclaimer.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Legal Disclaimer',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            Center(
              child: Icon(
                Icons.gavel,
                size: 128,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: const Text(
                  'Disclaimer & Terms',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: FutureBuilder<String>(
                  future: loadDisclaimerHtml(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Text('Failed to load disclaimer.');
                    }
                    return Html(
                      data: snapshot.data ?? '',
                      style: {
                        "body": Style(
                          fontSize: FontSize(16),
                          textAlign: TextAlign.justify,
                        ),
                      },
                    );
                  },
                ),
              ),
            ),
            FutureBuilder<DateTime?>(
              future: DisclaimerPrefs.getAgreedAt(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final dt = DateFormat.yMMMd().add_jm().format(snapshot.data!);
                  return Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Center(
                      child: Text(
                        'You agreed to these terms on $dt',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}