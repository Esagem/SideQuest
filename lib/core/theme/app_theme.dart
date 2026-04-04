import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/core/theme/app_typography.dart';

/// Composed [ThemeData] for the SideQuest application.
///
/// Provides [lightTheme] and [darkTheme] built entirely from design
/// tokens defined in the other `app_*.dart` files. Material component
/// themes (AppBar, BottomNavigationBar, InputDecoration, ElevatedButton)
/// are configured here so that default Material widgets match the
/// SideQuest design system out of the box.
abstract final class AppTheme {
  // ---------------------------------------------------------------------------
  // Light Theme
  // ---------------------------------------------------------------------------

  /// The complete light [ThemeData] for the SideQuest app.
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: AppTypography.fontFamily,
        brightness: Brightness.light,
        colorScheme: _lightColorScheme,
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: _lightAppBarTheme,
        bottomNavigationBarTheme: _lightBottomNavTheme,
        inputDecorationTheme: _lightInputTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        textTheme: _lightTextTheme,
      );

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.sunsetOrange,
    onPrimary: AppColors.white,
    secondary: AppColors.navy,
    onSecondary: AppColors.white,
    error: AppColors.emberRed,
    onError: AppColors.white,
    surface: AppColors.white,
    onSurface: AppColors.navy,
    surfaceContainerHighest: AppColors.offWhite,
    outline: AppColors.lightGray,
  );

  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.navy,
    foregroundColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTypography.cardTitle,
  );

  static const BottomNavigationBarThemeData _lightBottomNavTheme =
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.navy,
    selectedItemColor: AppColors.sunsetOrange,
    unselectedItemColor: AppColors.softGray,
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
  );

  static final InputDecorationTheme _lightInputTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.offWhite,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    border: const OutlineInputBorder(
      borderRadius: AppRadius.smallRadius,
      borderSide: BorderSide(color: AppColors.lightGray),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: AppRadius.smallRadius,
      borderSide: BorderSide(color: AppColors.lightGray),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: AppRadius.smallRadius,
      borderSide: BorderSide(
        color: AppColors.sunsetOrange,
        width: 2,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: AppRadius.smallRadius,
      borderSide: BorderSide(
        color: AppColors.emberRed,
        width: 2,
      ),
    ),
    hintStyle: AppTypography.body.copyWith(color: AppColors.softGray),
  );

  static const TextTheme _lightTextTheme = TextTheme(
    headlineLarge: AppTypography.hero,
    headlineMedium: AppTypography.sectionHeader,
    titleMedium: AppTypography.cardTitle,
    bodyLarge: AppTypography.body,
    bodySmall: AppTypography.caption,
    labelSmall: AppTypography.overline,
  );

  // ---------------------------------------------------------------------------
  // Dark Theme
  // ---------------------------------------------------------------------------

  /// The complete dark [ThemeData] for the SideQuest app.
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        fontFamily: AppTypography.fontFamily,
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme,
        scaffoldBackgroundColor: AppColors.deepNavy,
        appBarTheme: _darkAppBarTheme,
        bottomNavigationBarTheme: _darkBottomNavTheme,
        inputDecorationTheme: _darkInputTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        textTheme: _darkTextTheme,
      );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.sunsetOrangeDark,
    onPrimary: AppColors.white,
    secondary: AppColors.lightText,
    onSecondary: AppColors.deepNavy,
    error: AppColors.emberRedDark,
    onError: AppColors.white,
    surface: AppColors.cardNavy,
    onSurface: AppColors.lightText,
    surfaceContainerHighest: AppColors.slate,
    outline: AppColors.slate,
  );

  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.deepNavy,
    foregroundColor: AppColors.lightText,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTypography.cardTitleDark,
  );

  static const BottomNavigationBarThemeData _darkBottomNavTheme =
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.deepNavy,
    selectedItemColor: AppColors.sunsetOrangeDark,
    unselectedItemColor: AppColors.mutedText,
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
  );

  static final InputDecorationTheme _darkInputTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.slate,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    border: const OutlineInputBorder(
      borderRadius: AppRadius.smallRadius,
      borderSide: BorderSide(color: AppColors.slate),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: AppRadius.smallRadius,
      borderSide: BorderSide(color: AppColors.slate),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: AppRadius.smallRadius,
      borderSide: BorderSide(
        color: AppColors.sunsetOrangeDark,
        width: 2,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: AppRadius.smallRadius,
      borderSide: BorderSide(
        color: AppColors.emberRedDark,
        width: 2,
      ),
    ),
    hintStyle: AppTypography.bodyDark.copyWith(color: AppColors.mutedText),
  );

  static const TextTheme _darkTextTheme = TextTheme(
    headlineLarge: AppTypography.heroDark,
    headlineMedium: AppTypography.sectionHeaderDark,
    titleMedium: AppTypography.cardTitleDark,
    bodyLarge: AppTypography.bodyDark,
    bodySmall: AppTypography.captionDark,
    labelSmall: AppTypography.overlineDark,
  );

  // ---------------------------------------------------------------------------
  // Shared Component Themes
  // ---------------------------------------------------------------------------

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.smallRadius,
      ),
      textStyle: AppTypography.body.copyWith(
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
