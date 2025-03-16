import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const primaryColor = Color(0xFF1E88E5);
  static const secondaryColor = Color(0xFFFFA726);
  static const backgroundColor = Color(0xFFF5F6FA);
  static const textColor = Color(0xFF424242);

  // Additional Colors
  static const successColor = Color(0xFF4CAF50);
  static const errorColor = Color(0xFFE53935);
  static const warningColor = Color(0xFFFFB74D);
  static const surfaceColor = Colors.white;

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
    letterSpacing: 1.2,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF757575),
    letterSpacing: 0.5,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  // Decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // Input Decoration
  static InputDecoration inputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: primaryColor),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      floatingLabelStyle: TextStyle(color: primaryColor),
      filled: true,
      fillColor: surfaceColor,
    );
  }

  // Button Style
  static ButtonStyle get elevatedButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2,
      );

  // App Bar Theme
  static AppBarTheme get appBarTheme => const AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      );
}
