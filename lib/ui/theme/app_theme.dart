import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF00FF41);
  static const Color backgroundColor = Color(0xFF060608);
  static const Color screenBackgroundColor = Colors.black;

  // Monitor body colors (military olive-gray CRT terminal)
  static const Color bezelColor = Color(0xFF242418);
  static const Color bezelHighlight = Color(0xFF3C3C2A);  // top-left light catch
  static const Color bezelShadow = Color(0xFF0C0C09);     // bottom-right in shadow
  static const Color bezelBorderInner = Color(0xFF181812);
  static final Color bezelBorderColor = Colors.grey[800]!;

  static TextStyle get terminalStyle => GoogleFonts.robotoMono(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 10,
            color: primaryColor.withAlpha(150),
          ),
        ],
      );

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          bodyLarge: terminalStyle,
          bodyMedium: terminalStyle,
        ),
      );
}
