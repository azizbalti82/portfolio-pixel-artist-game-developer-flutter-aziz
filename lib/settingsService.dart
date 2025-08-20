import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final Future<SharedPreferences> _prefs = SharedPreferences
      .getInstance();

  static Future<void> saveIsDark(bool value) async {
    (await _prefs).setBool('is_dark_mode', value);
  }

  static Future<bool> getIsDark() async {
    return (await _prefs).getBool('is_dark_mode') ?? true;
  }
}