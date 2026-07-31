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
    final storedThemeIndex = box.get('themeMode', defaultValue: 0);
    if (storedThemeIndex is int &&
        storedThemeIndex >= 0 &&
        storedThemeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[storedThemeIndex];
    }

    // Load Language
    final storedLanguage = box.get('languageCode', defaultValue: 'tr');
    final languageCode =
        storedLanguage is String && const {'tr', 'en'}.contains(storedLanguage)
        ? storedLanguage
        : 'tr';
    _locale = Locale(languageCode);

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
