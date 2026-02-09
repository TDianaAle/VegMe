import 'package:flutter/material.dart';

class AppTheme {
  //main colours
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF2E7D32);
  static const Color accentOrange = Color(0xFFFF9800);
  
  // text colours
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);

  //  Verde acqua 
  static const Color lightGreen = Color(0xFFD5F5ED); // Verde acqua chiaro
  static const Color backgroundColor = Color(0xFFE8F5F1); // Background ancora più chiaro
  
  // complete theme
  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: Colors.grey[50],
      
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: textLight,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}