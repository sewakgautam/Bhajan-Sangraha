import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Warm devotional palette: saffron (primary), maroon (secondary), gold (tertiary).
  static const Color _saffron = Color(0xFFBF5B04);
  static const Color _saffronLight = Color(0xFFFFA85C);
  static const Color _maroon = Color(0xFF7A2048);
  static const Color _maroonLight = Color(0xFFE8A6C4);
  static const Color _gold = Color(0xFFA9821C);
  static const Color _goldLight = Color(0xFFE0C46A);

  static const Color _lightBackground = Color(0xFFFFF8F0);
  static const Color _lightSurface = Color(0xFFFFFCF8);
  static const Color _lightOnSurface = Color(0xFF2A1B10);

  static const Color darkBackground = Color(0xFF14100C);
  static const Color _darkSurface = Color(0xFF1E1712);
  static const Color darkText = Color(0xFFF3E9DD);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _saffron,
      brightness: Brightness.light,
    ).copyWith(
      primary: _saffron,
      secondary: _maroon,
      tertiary: _gold,
      surface: _lightSurface,
      onSurface: _lightOnSurface,
    );
    return _themeFrom(colorScheme, background: _lightBackground);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _saffron,
      brightness: Brightness.dark,
    ).copyWith(
      primary: _saffronLight,
      secondary: _maroonLight,
      tertiary: _goldLight,
      surface: _darkSurface,
      onSurface: darkText,
    );
    return _themeFrom(colorScheme, background: darkBackground);
  }

  static ThemeData _themeFrom(ColorScheme colorScheme, {required Color background}) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
    );
    final poppinsTextTheme = GoogleFonts.poppinsTextTheme(base.textTheme);
    final textTheme = colorScheme.brightness == Brightness.dark
        ? poppinsTextTheme.apply(bodyColor: darkText, displayColor: darkText)
        : poppinsTextTheme;

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
        side: BorderSide.none,
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        indicatorColor: colorScheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w400,
            color: states.contains(WidgetState.selected)
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// Devanagari-specific text styles, applied only where Devanagari text is
  /// rendered — Poppins (the app's default) has no Devanagari glyphs.
  static TextTheme devanagariTextTheme(TextTheme base) =>
      GoogleFonts.notoSansDevanagariTextTheme(base);
}
