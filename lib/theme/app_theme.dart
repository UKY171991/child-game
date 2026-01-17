import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFFC107); // Amber/Yellow
  static const Color secondaryColor = Color(0xFF4CAF50); // Green
  static const Color accentColor = Color(0xFF2196F3); // Blue
  static const Color errorColor = Color(0xFFF44336); // Red
  static const Color backgroundColor = Color(0xFFE3F2FD); // Light Blue

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      textTheme: GoogleFonts.bubblegumSansTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
