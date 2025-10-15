import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {

  /// -------------------------------
  /// Light Theme
  /// -------------------------------
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Roboto',

    // SnackBar Style
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.primary,
      contentTextStyle: TextStyle(color: Colors.white),
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.secondBackground,
      hintStyle: const TextStyle(
        color: Color(0xffA7A7A7),
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),

    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.adminPrimary,
        elevation: 4,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500,fontFamily: 'Roboto'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),


      )
        ,
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      bodyLarge: const TextStyle(
          fontFamily: 'Roboto',
          color: AppColors.textLight),
      bodyMedium: const TextStyle(
        fontFamily: 'Roboto',
        color: AppColors.textLight,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: const TextStyle(
        fontFamily: 'Roboto',
        color: AppColors.textLight,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      // ---------filter secend filter ----------
      displayMedium: const TextStyle(
        fontFamily: 'Roboto',
        color: AppColors.textLight,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      displaySmall: const TextStyle(
        fontFamily: 'Roboto',
        color: AppColors.textLight,
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),

      titleLarge:const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppColors.primary,
      ),
      // ------------filter product -----------
      titleMedium: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: AppColors.textLight,
      ),
      titleSmall: const TextStyle(
          fontFamily: 'Roboto',fontSize: 15, color: AppColors.textLight),
      labelLarge:const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.black87,
      ),
    ),
  );

  /// -------------------------------
  /// Dark Theme
  /// -------------------------------
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: 'Roboto',

    // SnackBar Style
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.grey,
      contentTextStyle: TextStyle(color: Colors.white),
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSecondBackground,
      hintStyle: const TextStyle(
        color: Color(0xffA7A7A7),
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),

    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      bodyLarge: const TextStyle(
          fontFamily: 'Roboto',
          color: AppColors.textDark),
      bodyMedium:const  TextStyle(
        fontFamily: 'Roboto',
        color: AppColors.textDark,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: const TextStyle(
        fontFamily: 'Roboto',
        color: AppColors.textDark,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      displayMedium: const TextStyle(
        fontFamily: 'Roboto',
        color: AppColors.textDark,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      displaySmall: const TextStyle(
        fontFamily: 'Roboto',
        color: AppColors.textDark,
        fontSize: 16,
      ),
      titleLarge:const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppColors.primary,
      ),
      titleMedium: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppColors.textDark,
      ),

      //-------------------uses in product cart title ---------------------
      titleSmall:const   TextStyle(
        fontFamily: 'Roboto',fontSize: 15, color: AppColors.textDark,  fontWeight: FontWeight.bold,),


      labelLarge:
      TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: AppColors.textDark.withValues(alpha: 0.7),
      ),
    ),
  );
}
