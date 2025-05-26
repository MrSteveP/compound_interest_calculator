import 'dart:io';
import 'package:flutter/material.dart';
/// import 'package:flutter/services.dart';
import '../models/calculation.dart';
import '../screens/about_screen.dart';
import '../screens/disclaimer_screen.dart';
import '../screens/saved_calculations_screen.dart';

typedef OnLoadStrategy = void Function(Calculation calc);

class AppPopupMenu extends StatelessWidget {
  final VoidCallback onNew;
  final OnLoadStrategy onLoadStrategy;

  const AppPopupMenu({
    super.key,
    required this.onNew,
    required this.onLoadStrategy,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'new') {
          onNew();
        } else if (value == 'load') {
          final loadedCalc = await Navigator.push<Calculation>(
            context,
            MaterialPageRoute(
              builder: (_) => const SavedCalculationsScreen(),
            ),
          );
          if (loadedCalc != null) {
            onLoadStrategy(loadedCalc);
          }
        } else if (value == 'disclaimer') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DisclaimerScreen()),
          );
        } else if (value == 'about') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AboutScreen()),
          );
        } else if (value == 'exit') {
          /// Strangely, having a force quit button is discouraged by developers misinterpreting the Apple/Google guidelines. There is
          /// nothing in either Apple or Google's guidelines outlawing force quit. Especially when the quit is initiated by the user.
          /// However, if there are any issues, then simply comment out "exit(0);" and uncomment the SystemNavigator.pop() line below
          /// to allow minimize instead of exit, or remove the Exit option from the menu entirely.
          /// SystemNavigator.pop(); // Also need to uncomment "import 'package:flutter/services.dart';" above.
          exit(0);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'new',
          child: Row(
            children: const [
              Icon(Icons.add_circle_outline, size: 16),
              SizedBox(width: 8),
              Text('New Investment Strategy'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'load',
          child: Row(
            children: const [
              Icon(Icons.folder_open, size: 16),
              SizedBox(width: 8),
              Text('Load/Delete Strategies'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'disclaimer',
          child: Row(
            children: const [
              Icon(Icons.gavel, size: 16),
              SizedBox(width: 8),
              Text('Legal Disclaimer'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'about',
          child: Row(
            children: const [
              Icon(Icons.info_outline, size: 16),
              SizedBox(width: 8),
              Text('About'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'exit',
          child: Row(
            children: const [
              Icon(Icons.exit_to_app, size: 16),
              SizedBox(width: 8),
              Text('Exit'),
            ],
          ),
        ),
      ],
    );
  }
}