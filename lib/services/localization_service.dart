import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const _key = 'app_language_code'; // 'en' or 'ro'

  Future<String> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? 'en';
  }

  Future<void> save(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }
}
