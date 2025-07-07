import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- COLORS ---
  static const Color background = Color(0xFF101010);
  static const Color button = Color(0xFF6F6F6F);
  static const Color inactive = Color(0xFF6F6F6F);
  static const Color active = Color(0xFFB2FF59);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFD3D3D3);

  // --- THEME ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    primaryColor: active,
    fontFamily: GoogleFonts.cairo().fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: active,
      secondary: button,
      surface: background,
      error: Colors.redAccent,
      onPrimary: Colors.black,
      onSecondary: primaryText,
      onSurface: primaryText,
      onError: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      iconTheme: const IconThemeData(color: primaryText),
      titleTextStyle: TextStyle(
        fontFamily: GoogleFonts.cairo().fontFamily,
        color: primaryText,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: primaryText, height: 1.4),
      bodyMedium: TextStyle(color: secondaryText, height: 1.4),
      titleLarge: TextStyle(color: primaryText, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: primaryText),
      titleSmall: TextStyle(color: secondaryText),
    ).apply(
      fontFamily: GoogleFonts.cairo().fontFamily,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: active,
      foregroundColor: Colors.black,
    ),
    unselectedWidgetColor: inactive,
    // Add text form field theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
      labelStyle: const TextStyle(color: secondaryText),
      hintStyle: TextStyle(color: secondaryText.withOpacity(0.8)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: active, width: 2),
      ),
    ),
  );
}
