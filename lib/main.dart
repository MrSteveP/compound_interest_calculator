import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //// await clearPrefs(); // <-- Call this once to clear preferences
  runApp(const CompoundInterestApp());
}

// Add this function
Future<void> clearPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

class CompoundInterestApp extends StatelessWidget {
  const CompoundInterestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compound Interest Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}