import 'package:flutter/material.dart';

class AppColors {
  // Colores del tema
  static const Color primaryColor = Color.fromARGB(255, 174, 147, 147);
  static const Color secondaryColor = Color.fromARGB(255, 233, 209, 209);
  static const Color backgroundColor = Color.fromARGB(255, 242, 110, 110);

  // Colores del texto
  static const Color textPrimaryColor = Color.fromARGB(255, 233, 228, 228);
  static const Color textSecundaryColor = Color.fromARGB(255, 29, 17, 17);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      textTheme: TextTheme(
        headlineMedium: TextStyle(color: AppColors.textSecundaryColor),
        bodyMedium: TextStyle(color: AppColors.textPrimaryColor),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
