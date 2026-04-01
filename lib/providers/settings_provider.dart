import 'package:flutter/material.dart';
import '../services/database_service.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('tr');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    final box = DatabaseService.settingsBox;

    // Load Theme
    final themeIndex = box.get('themeMode', defaultValue: 0) as int;
    _themeMode = ThemeMode.values[themeIndex];

    // Load Language
    final langCode = box.get('languageCode', defaultValue: 'tr') as String;
    _locale = Locale(langCode);

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final box = DatabaseService.settingsBox;
    await box.put('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final box = DatabaseService.settingsBox;
    await box.put('languageCode', locale.languageCode);
    notifyListeners();
  }
}
