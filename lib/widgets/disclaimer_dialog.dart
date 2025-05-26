import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../utils/disclaimer_prefs.dart';

class DisclaimerDialog extends StatelessWidget {
  const DisclaimerDialog({super.key});

  Future<String> loadDisclaimerHtml() async {
    return await rootBundle.loadString('assets/disclaimer.html');
  }

  @override
  Widget build(BuildContext context) {
    final double dialogHeight = MediaQuery.of(context).size.height * 0.8;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 24), // Reduce dialog margin to screen edge
      contentPadding: const EdgeInsets.fromLTRB(
          16, 16, 16, 0), // Reduce padding inside the dialog
      title: const Text('Disclaimer & Terms',
          textAlign: TextAlign.center),
      content: SizedBox(
        height: dialogHeight,
        child: FutureBuilder<String>(
          future: loadDisclaimerHtml(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Text('Failed to load disclaimer.');
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Html(
                      data: snapshot.data ?? '',
                      style: {
                        "body": Style(
                            fontSize: FontSize(16),
                            textAlign: TextAlign.justify),
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Add space before the buttons
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await DisclaimerPrefs.setAgreed();
            Navigator.of(context).pop(true);
          },
          child: const Text('Agree'),
        ),
      ],
    );
  }
}
