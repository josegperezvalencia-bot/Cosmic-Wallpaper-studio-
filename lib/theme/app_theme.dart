import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppConstants.neonBlue,
        secondary: AppConstants.neonPurple,
        tertiary: AppConstants.neonCyan,
        surface: AppConstants.darkBg,
        error: AppConstants.hudRed,
      ),
      scaffoldBackgroundColor: AppConstants.darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.darkBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppConstants.neonBlue,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        iconTheme: IconThemeData(color: AppConstants.neonBlue),
      ),
      cardTheme: CardTheme(
        color: AppConstants.darkCard,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: AppConstants.neonBlue,
            width: 0.5,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.darkBg,
        selectedItemColor: AppConstants.neonBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppConstants.neonBlue,
        inactiveTrackColor: AppConstants.neonBlue.withAlpha(51),
        thumbColor: AppConstants.neonBlue,
        overlayColor: AppConstants.neonBlue.withAlpha(26),
        trackHeight: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppConstants.neonBlue,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppConstants.neonBlue.withAlpha(77),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppConstants.neonBlue,
            width: 1.5,
          ),
        ),
        labelStyle: const TextStyle(color: AppConstants.neonBlue),
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
      dividerTheme: DividerThemeData(
        color: AppConstants.neonBlue.withAlpha(51),
        thickness: 0.5,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppConstants.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppConstants.neonBlue,
            width: 0.5,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        titleLarge: TextStyle(
          color: AppConstants.neonBlue,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.white60, fontSize: 14),
        labelLarge: TextStyle(
          color: AppConstants.neonBlue,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppConstants.neonBlue,
        foregroundColor: Colors.black,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppConstants.neonBlue;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppConstants.neonBlue.withAlpha(77);
          }
          return Colors.grey.withAlpha(51);
        }),
      ),
    );
  }
}
