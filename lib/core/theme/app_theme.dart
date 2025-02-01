import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.navyBlue,
        onPrimary: Colors.white,
        secondary: AppColors.burgundy,
        onSecondary: Colors.white,
        tertiary: AppColors.crimsonRed,
        onTertiary: Colors.white,
        error: AppColors.coral,
        onError: Colors.white,
        background: Colors.white,
        onBackground: AppColors.navyBlue,
        surface: Colors.white,
        onSurface: AppColors.navyBlue,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navyBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.navyBlue),
        bodyMedium: TextStyle(color: AppColors.navyBlue),
        titleLarge: TextStyle(color: AppColors.navyBlue),
        titleMedium: TextStyle(color: AppColors.navyBlue),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.burgundy,
        onPrimary: Colors.white,
        secondary: AppColors.crimsonRed,
        onSecondary: Colors.white,
        tertiary: AppColors.coral,
        onTertiary: Colors.white,
        error: AppColors.coral,
        onError: Colors.white,
        background: AppColors.darkBackground,
        onBackground: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.burgundy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
      ),
      useMaterial3: true,
    );
  }
} 
