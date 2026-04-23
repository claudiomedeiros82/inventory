import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF00FF41);
  static const Color backgroundColor = Color(0xFF1A1A1A);
  static const Color screenBackgroundColor = Colors.black;
  static const Color bezelColor = Color(0xFF2A2A2A);
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
