import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';

/// Text style tokens for the SideQuest design system.
///
/// Uses the Inter font family for all styles. The type scale is
/// mobile-first with six named levels from hero (28px) to overline (12px).
///
/// Each style is available in light and dark variants via the
/// [light] and [dark] nested classes.
abstract final class AppTypography {
  /// Base font family used across the app.
  static const String fontFamily = 'Inter';

  /// Monospace font family for XP counts, leaderboard numbers, stats.
  static const String monoFontFamily = 'JetBrains Mono';

  // ---------------------------------------------------------------------------
  // Light Mode Styles
  // ---------------------------------------------------------------------------

  /// Hero / Title — 28px Bold, navy on light backgrounds.
  static const TextStyle hero = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.navy,
    height: 1.3,
  );

  /// Section Header — 22px SemiBold, navy on light backgrounds.
  static const TextStyle sectionHeader = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.navy,
    height: 1.3,
  );

  /// Card Title — 18px SemiBold, navy on light backgrounds.
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.navy,
    height: 1.4,
  );

  /// Body — 16px Regular, navy on light backgrounds.
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.navy,
    height: 1.5,
  );

  /// Caption / Label — 14px Regular, soft gray on light backgrounds.
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.softGray,
    height: 1.4,
  );

  /// Overline / Badge — 12px Medium, uppercase tracking, soft gray.
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.softGray,
    letterSpacing: 1.2,
    height: 1.4,
  );

  /// Monospace stat style — 16px Regular, navy, for XP and scores.
  static const TextStyle stat = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.navy,
    height: 1.4,
  );

  // ---------------------------------------------------------------------------
  // Dark Mode Styles
  // ---------------------------------------------------------------------------

  /// Hero / Title — 28px Bold, light text on dark backgrounds.
  static const TextStyle heroDark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.lightText,
    height: 1.3,
  );

  /// Section Header — 22px SemiBold, light text on dark backgrounds.
  static const TextStyle sectionHeaderDark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.lightText,
    height: 1.3,
  );

  /// Card Title — 18px SemiBold, light text on dark backgrounds.
  static const TextStyle cardTitleDark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.lightText,
    height: 1.4,
  );

  /// Body — 16px Regular, light text on dark backgrounds.
  static const TextStyle bodyDark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.lightText,
    height: 1.5,
  );

  /// Caption / Label — 14px Regular, muted text on dark backgrounds.
  static const TextStyle captionDark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedText,
    height: 1.4,
  );

  /// Overline / Badge — 12px Medium, muted text on dark backgrounds.
  static const TextStyle overlineDark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.mutedText,
    letterSpacing: 1.2,
    height: 1.4,
  );

  /// Monospace stat style — 16px Regular, light text on dark backgrounds.
  static const TextStyle statDark = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.lightText,
    height: 1.4,
  );
}
