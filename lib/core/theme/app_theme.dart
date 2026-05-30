import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgBase,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.bgSurface,
      primary: AppColors.gold,
      secondary: AppColors.emerald,
      error: AppColors.crimson,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgBase,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppTypography.headingM,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.bgSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.borderSubtle,
      thickness: 1,
      space: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgInput,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.chip),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.chip),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.chip),
        borderSide: const BorderSide(color: AppColors.gold),
      ),
      labelStyle: AppTypography.bodyM,
      hintStyle: AppTypography.bodyM.copyWith(color: AppColors.textTertiary),
    ),
    textTheme: TextTheme(
      displayLarge:   AppTypography.displayXL,
      displayMedium:  AppTypography.displayL,
      displaySmall:   AppTypography.displayM,
      headlineLarge:  AppTypography.headingL,
      headlineMedium: AppTypography.headingM,
      titleLarge:     AppTypography.headingS,
      bodyLarge:      AppTypography.bodyL,
      bodyMedium:     AppTypography.bodyM,
      bodySmall:      AppTypography.bodyS,
      labelSmall:     AppTypography.label,
    ),
  );
}
