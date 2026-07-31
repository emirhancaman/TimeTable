import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/theme/app_theme.dart';

void main() {
  test('themes use Material 3 and the expected brightness', () {
    expect(AppTheme.lightTheme.useMaterial3, isTrue);
    expect(AppTheme.lightTheme.brightness, Brightness.light);
    expect(AppTheme.darkTheme.useMaterial3, isTrue);
    expect(AppTheme.darkTheme.brightness, Brightness.dark);
  });
}
