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

class AppFactorWidth {
  // Ancho de pantalla usada
  static const double widthFactorComputer = 0.8;  
  static const double widthFactorTablet = 0.85;  
  static const double widthFactorMobile = 0.9;  

  // Tamaño de iconos
  static const double iconSizeComputer = 40;
  static const double iconSizeTablet = 40;
  static const double iconSizeMobile = 40;

}

class AppTheme {
  static ThemeData getTheme(BuildContext context) {
    // Detectar el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      // Tema para móviles
      return ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: TextTheme(
          headlineMedium: TextStyle(color: AppColors.textSecundaryColor, fontSize: 18),
          bodyMedium: TextStyle(color: AppColors.textPrimaryColor, fontSize: 14),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
      );
    } else if (screenWidth < 1024) {
      // Tema para tablets
      return ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: TextTheme(
          headlineMedium: TextStyle(color: AppColors.textSecundaryColor, fontSize: 22),
          bodyMedium: TextStyle(color: AppColors.textPrimaryColor, fontSize: 16),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
      );
    } else {
      // Tema para ordenadores
      return ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: TextTheme(
          headlineMedium: TextStyle(color: AppColors.textSecundaryColor, fontSize: 26),
          bodyMedium: TextStyle(color: AppColors.textPrimaryColor, fontSize: 18),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
      );
    }
  }
}