import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation.dart';
import 'dart:convert';

class StorageService {
  static const String _key = 'saved_calculations';

  Future<List<Calculation>> loadCalculations() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => Calculation.fromJson(jsonDecode(e))).toList();
  }

  Future<void> saveCalculation(Calculation calc) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    data.add(jsonEncode(calc.toJson()));
    await prefs.setStringList(_key, data);
  }

  Future<void> deleteCalculation(Calculation calc) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    data.removeWhere((e) {
      final c = Calculation.fromJson(jsonDecode(e));
      return c.name == calc.name && c.timestamp == calc.timestamp;
    });
    await prefs.setStringList(_key, data);
  }
}