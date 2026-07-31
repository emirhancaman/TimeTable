import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/utils/localization.dart';

void main() {
  testWidgets('renders Turkish strings for the Turkish locale', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        supportedLocales: const [Locale('en'), Locale('tr')],
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: Builder(
          builder: (context) => Scaffold(
            body: Text(AppLocalizations.of(context).get('my_plans')),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Planlarım'), findsOneWidget);
  });

  testWidgets('renders English strings for the English locale', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('tr')],
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: Builder(
          builder: (context) => Scaffold(
            body: Text(AppLocalizations.of(context).get('my_plans')),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('My Plans'), findsOneWidget);
  });
}
