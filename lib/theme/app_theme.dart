import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color primaryNavy = Color(0xFF172554);
  static const Color primaryBlue = Color(0xFF4F7CFF);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentGold = Color(0xFFFBBF24);
  static const Color successMint = Color(0xFF22C55E);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color warningYellow = Color(0xFFF59E0B);

  static const Color darkBackground = Color(0xFF080D18);
  static const Color darkSurface = Color(0xFF101827);
  static const Color darkCard = Color(0xFF121C2F);
  static const Color darkCardLight = Color(0xFF1D2A42);

  static const Color lightBackground = Color(0xFFF6F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardAlt = Color(0xFFEDF1F7);

  static const Color textPrimary = Color(0xFFF7F9FC);
  static const Color textSecondary = Color(0xFFB6C0D2);
  static const Color textMuted = Color(0xFF7D8AA3);
  static const Color lightTextPrimary = Color(0xFF17213A);
  static const Color lightTextSecondary = Color(0xFF536078);
  static const Color lightTextMuted = Color(0xFF7A869C);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryNavy, Color(0xFF29408B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [primaryBlue, Color(0xFF7899FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentAmber, accentGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.07),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: primaryBlue.withValues(alpha: 0.24),
      blurRadius: 20,
      spreadRadius: -4,
    ),
  ];

  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 24;

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark ? darkBackground : lightBackground;
    final surface = isDark ? darkSurface : lightSurface;
    final card = isDark ? darkCard : lightCard;
    final onSurface = isDark ? textPrimary : lightTextPrimary;
    final muted = isDark ? textSecondary : lightTextSecondary;
    final primary = isDark ? primaryBlue : primaryNavy;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: primaryBlue,
          brightness: brightness,
          surface: surface,
        ).copyWith(
          primary: primary,
          secondary: accentAmber,
          error: errorRed,
          onPrimary: Colors.white,
          onSecondary: const Color(0xFF241600),
          onSurface: onSurface,
          outline: muted.withValues(alpha: 0.35),
          surfaceContainerHighest: isDark ? darkCardLight : lightCardAlt,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      visualDensity: VisualDensity.standard,
    );

    final textTheme = base.textTheme.apply(
      bodyColor: onSurface,
      displayColor: onSurface,
    );

    final roundedBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLarge),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: roundedBorder.copyWith(
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.22)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        focusElevation: 3,
        hoverElevation: 4,
        shape: roundedBorder,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkCard : lightCardAlt,
        hintStyle: TextStyle(color: muted),
        labelStyle: TextStyle(color: muted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: primaryBlue, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        selectedColor: primaryBlue,
        labelStyle: textTheme.labelLarge?.copyWith(color: muted),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: background,
        modalBackgroundColor: background,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? darkCardLight : lightTextPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: roundedBorder,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.18),
        thickness: 1,
      ),
    );
  }

  static Color getPriorityColor(int priority) {
    return switch (priority) {
      1 => const Color(0xFF22C55E),
      2 => const Color(0xFFF59E0B),
      3 => const Color(0xFFEF4444),
      _ => textMuted,
    };
  }
}
