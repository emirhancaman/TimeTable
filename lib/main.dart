import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/database_service.dart';
import 'providers/plan_provider.dart';
import 'providers/settings_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'utils/localization.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Turkish
  await initializeDateFormatting('tr_TR', null);

  // Initialize database
  await DatabaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setRefreshRate();
  }

  Future<void> _setRefreshRate() async {
    if (Platform.isAndroid) {
      try {
        final modes = await FlutterDisplayMode.supported;
        // Find a mode close to 60Hz
        final mode = modes.firstWhere(
          (m) => (m.refreshRate - 60).abs() < 2,
          orElse: () => DisplayMode.auto,
        );
        if (mode != DisplayMode.auto) {
          await FlutterDisplayMode.setPreferredMode(mode);
        }
      } catch (_) {
        // Fail silently if not supported
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlanProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'TimeEW',
            debugShowCheckedModeBanner: false,
            // Localization
            locale: settings.locale,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              ...GlobalMaterialLocalizations.delegates,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
            // Theme
            themeMode: settings.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
