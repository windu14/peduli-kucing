import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.lexendTextTheme().copyWith(
      displayLarge: GoogleFonts.lexend(fontSize: 48, fontWeight: FontWeight.w800, letterSpacing: -0.02, color: AppColors.onSurface),
      headlineLarge: GoogleFonts.lexend(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.01, color: AppColors.onSurface),
      headlineMedium: GoogleFonts.lexend(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.onSurface),
      bodyLarge: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.w400, color: AppColors.onSurface),
      bodyMedium: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.onSurface),
      labelLarge: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.02, color: AppColors.onSurface),
      labelSmall: GoogleFonts.lexend(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryContainer, // Use the bright orange for primary UI elements
        onPrimary: AppColors.onPrimaryContainer,
        secondary: AppColors.electricBlue,
        onSecondary: AppColors.onSecondary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: AppColors.onError,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      
      // Card Theme (32px corners, soft shadow)
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        margin: const EdgeInsets.all(8),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.brightOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
        elevation: 8,
      ),

      // Button Theme (Pill shaped)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brightOrange,
          foregroundColor: Colors.white,
          elevation: 4,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Input Decoration Theme (32px corners, thick borders)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.softYellow.withValues(alpha: 0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: AppColors.electricBlue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
