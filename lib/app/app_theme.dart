import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Get appropriate Google Font based on locale
  static String _getGoogleFontFamily(Locale locale) {
    switch (locale.languageCode) {
      case 'si': // Sinhala
        return 'Noto Sans Sinhala';
      case 'ta': // Tamil
        return 'Noto Sans Tamil'; // Google Fonts name
      default: // English and others
        return 'Inter'; // Google Fonts name
    }
  }

  // Get TextStyle with appropriate font
  static TextStyle getTextStyle({
    required Locale locale,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    final fontFamily = _getGoogleFontFamily(locale);

    // Create Google Fonts TextStyle
    switch (fontFamily) {
      case 'Noto Sans Sinhala':
        return GoogleFonts.notoSansSinhala(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      case 'Noto Sans Tamil':
        return GoogleFonts.notoSansTamil(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
      default: // 'Inter' and fallback
        return GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );
    }
  }

  // Theme data with dynamic fonts
  static ThemeData getLightTheme(Locale locale) {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        titleTextStyle: getTextStyle(
          locale: locale,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: getTextStyle(
          locale: locale,
          fontSize: 96,
          fontWeight: FontWeight.w300,
        ),
        displayMedium: getTextStyle(
          locale: locale,
          fontSize: 60,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: getTextStyle(
          locale: locale,
          fontSize: 48,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: getTextStyle(
          locale: locale,
          fontSize: 34,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: getTextStyle(
          locale: locale,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: getTextStyle(
          locale: locale,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: getTextStyle(
          locale: locale,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: getTextStyle(
          locale: locale,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: getTextStyle(
          locale: locale,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: getTextStyle(
          locale: locale,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: getTextStyle(
          locale: locale,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: getTextStyle(
          locale: locale,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: getTextStyle(
          locale: locale,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  static ThemeData getDarkTheme(Locale locale) {
    final lightTheme = getLightTheme(locale);

    return lightTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 1,
        titleTextStyle: getTextStyle(
          locale: locale,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: getTextStyle(
          locale: locale,
          fontSize: 96,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        displayMedium: getTextStyle(
          locale: locale,
          fontSize: 60,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        displaySmall: getTextStyle(
          locale: locale,
          fontSize: 48,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        headlineMedium: getTextStyle(
          locale: locale,
          fontSize: 34,
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
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleMedium: getTextStyle(
          locale: locale,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleSmall: getTextStyle(
          locale: locale,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: getTextStyle(
          locale: locale,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
        bodyMedium: getTextStyle(
          locale: locale,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
        bodySmall: getTextStyle(
          locale: locale,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.white60,
        ),
        labelLarge: getTextStyle(
          locale: locale,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelSmall: getTextStyle(
          locale: locale,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: Colors.white60,
        ),
      ),
    );
  }

  // Static themes for backward compatibility (default to English)
  static final ThemeData lightTheme = getLightTheme(const Locale('en'));
  static final ThemeData darkTheme = getDarkTheme(const Locale('en'));
}
