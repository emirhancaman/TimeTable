import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../utils/localization.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        ),
        title: Text(loc.get('settings_title')),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        loc.get('preferences'),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.55),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          _SettingsTile(
                            icon: Icons.brightness_6_rounded,
                            title: loc.get('theme_label'),
                            value: _themeName(loc, settings.themeMode),
                            onTap: () =>
                                _showThemeDialog(context, settings, loc),
                          ),
                          const Divider(height: 1, indent: 68),
                          _SettingsTile(
                            icon: Icons.language_rounded,
                            title: loc.get('language_label'),
                            value: settings.locale.languageCode == 'tr'
                                ? 'Türkçe'
                                : 'English',
                            onTap: () =>
                                _showLanguageDialog(context, settings, loc),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'TimeTable · v1.0.0',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _themeName(AppLocalizations loc, ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => loc.get('theme_system'),
      ThemeMode.light => loc.get('theme_light'),
      ThemeMode.dark => loc.get('theme_dark'),
    };
  }

  void _showThemeDialog(
    BuildContext context,
    SettingsProvider settings,
    AppLocalizations loc,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.get('select_theme')),
        content: RadioGroup<ThemeMode>(
          groupValue: settings.themeMode,
          onChanged: (value) {
            if (value == null) return;
            settings.setThemeMode(value);
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogRadio(
                value: ThemeMode.system,
                label: loc.get('theme_system'),
              ),
              _DialogRadio(
                value: ThemeMode.light,
                label: loc.get('theme_light'),
              ),
              _DialogRadio(value: ThemeMode.dark, label: loc.get('theme_dark')),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    SettingsProvider settings,
    AppLocalizations loc,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.get('select_language')),
        content: RadioGroup<String>(
          groupValue: settings.locale.languageCode,
          onChanged: (value) {
            if (value == null) return;
            settings.setLocale(Locale(value));
            Navigator.pop(context);
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogRadio(value: 'tr', label: 'Türkçe'),
              _DialogRadio(value: 'en', label: 'English'),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, size: 20),
        ],
      ),
    );
  }
}

class _DialogRadio<T> extends StatelessWidget {
  const _DialogRadio({required this.value, required this.label});

  final T value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      title: Text(label),
      contentPadding: EdgeInsets.zero,
    );
  }
}
