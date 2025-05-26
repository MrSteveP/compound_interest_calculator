import 'package:shared_preferences/shared_preferences.dart';

class DisclaimerPrefs {
  static const _agreedKey = 'disclaimer_agreed';
  static const _agreedAtKey = 'disclaimer_agreed_at';

  static Future<bool> hasAgreed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_agreedKey) ?? false;
  }

  static Future<DateTime?> getAgreedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt(_agreedAtKey);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  static Future<void> setAgreed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_agreedKey, true);
    await prefs.setInt(_agreedAtKey, DateTime.now().millisecondsSinceEpoch);
  }
}