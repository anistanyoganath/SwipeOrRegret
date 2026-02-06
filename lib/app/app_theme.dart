import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Get appropriate Google Font based on locale
  static String _getGoogleFontFamily(Locale locale) {
    switch (locale.languageCode) {
      case 'si': // Sinhala
        return 'Noto Sans Sinhala';
      case 'ta': // Tamil
        return 'Noto Sans Tamil';
      default: // English and others
        return 'Inter';
    }
  }

  // Get TextStyle with appropriate font
  static TextStyle getTextStyle({
    required Locale locale,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    final fontFamily = _getGoogleFontFamily(locale);

    switch (fontFamily) {
      case 'Noto Sans Sinhala':
        return GoogleFonts.notoSansSinhala(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      case 'Noto Sans Tamil':
        return GoogleFonts.notoSansTamil(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      default: // 'Inter' and fallback
        return GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
    }
  }

  // Theme data with dynamic fonts - Material 3 enabled
  static ThemeData getLightTheme(Locale locale) {
    final colorScheme = const ColorScheme.light(
      primary: Colors.deepPurple,
      secondary: Colors.purple,
      surface: Colors.white,
      background: Color(0xFFF5F5F5),
      error: Color(0xFFB00020),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1C1B1F),
      onBackground: Color(0xFF1C1B1F),
      onError: Colors.white,
      brightness: Brightness.light,
    );

    final textTheme = TextTheme(
      displayLarge: getTextStyle(
        locale: locale,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: getTextStyle(
        locale: locale,
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: getTextStyle(
        locale: locale,
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: getTextStyle(
        locale: locale,
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: getTextStyle(
        locale: locale,
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: getTextStyle(
        locale: locale,
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: getTextStyle(
        locale: locale,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: getTextStyle(
        locale: locale,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: getTextStyle(
        locale: locale,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyLarge: getTextStyle(
        locale: locale,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: getTextStyle(
        locale: locale,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: getTextStyle(
        locale: locale,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      labelLarge: getTextStyle(
        locale: locale,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: getTextStyle(
        locale: locale,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: getTextStyle(
        locale: locale,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );

    return ThemeData(
      useMaterial3: true, // Enable Material 3
      colorScheme: colorScheme,
      fontFamily: _getGoogleFontFamily(locale),
      textTheme: textTheme,

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        surfaceTintColor: Colors.transparent,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  static ThemeData getDarkTheme(Locale locale) {
    final colorScheme = const ColorScheme.dark(
      primary: Colors.deepPurpleAccent,
      secondary: Colors.purpleAccent,
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      error: Color(0xFFCF6679),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    );

    final textTheme = TextTheme(
      displayLarge: getTextStyle(
        locale: locale,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: Colors.white,
      ),
      displayMedium: getTextStyle(
        locale: locale,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      displaySmall: getTextStyle(
        locale: locale,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      headlineLarge: getTextStyle(
        locale: locale,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      headlineMedium: getTextStyle(
        locale: locale,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      headlineSmall: getTextStyle(
        locale: locale,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      titleLarge: getTextStyle(
        locale: locale,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      titleMedium: getTextStyle(
        locale: locale,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: Colors.white,
      ),
      titleSmall: getTextStyle(
        locale: locale,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: Colors.white,
      ),
      bodyLarge: getTextStyle(
        locale: locale,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: Colors.white.withOpacity(0.87),
      ),
      bodyMedium: getTextStyle(
        locale: locale,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: Colors.white.withOpacity(0.87),
      ),
      bodySmall: getTextStyle(
        locale: locale,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: Colors.white.withOpacity(0.6),
      ),
      labelLarge: getTextStyle(
        locale: locale,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: Colors.white,
      ),
      labelMedium: getTextStyle(
        locale: locale,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: Colors.white,
      ),
      labelSmall: getTextStyle(
        locale: locale,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: Colors.white.withOpacity(0.6),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      fontFamily: _getGoogleFontFamily(locale),
      textTheme: textTheme,

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        surfaceTintColor: Colors.transparent,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.3),
        thickness: 1,
        space: 1,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  // Static themes for backward compatibility (default to English)
  static final ThemeData lightTheme = getLightTheme(const Locale('en'));
  static final ThemeData darkTheme = getDarkTheme(const Locale('en'));
}
