import 'package:flutter/material.dart';

/// All color tokens for the SideQuest design system.
///
/// Colors are organized by mode (light/dark), role (primary, accent,
/// supporting), and semantic category (intent tags, quest categories).
///
/// **Rule:** No raw hex values outside this file. Always reference
/// [AppColors] constants in widget code.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Light Mode — Primary
  // ---------------------------------------------------------------------------

  /// Primary text, headers, navigation bar backgrounds, key UI surfaces.
  static const Color navy = Color(0xFF1B2A4A);

  /// Page backgrounds, card backgrounds, input fields.
  static const Color white = Color(0xFFFFFFFF);

  /// Secondary backgrounds, grouped table views, subtle separation.
  static const Color offWhite = Color(0xFFF5F6F8);

  // ---------------------------------------------------------------------------
  // Light Mode — Accent (Sunset Gradient)
  // ---------------------------------------------------------------------------

  /// Streak indicators, XP displays, positive highlights, star ratings.
  static const Color warmYellow = Color(0xFFF5A623);

  /// Primary CTA buttons, badges, notification dots, active states.
  static const Color sunsetOrange = Color(0xFFE8734A);

  /// Challenges, legendary difficulty, urgent notifications, destructive actions.
  static const Color emberRed = Color(0xFFD94F4F);

  // ---------------------------------------------------------------------------
  // Light Mode — Supporting
  // ---------------------------------------------------------------------------

  /// Success states, completed quests, "Worth It" signals, Growth intent.
  static const Color oceanTeal = Color(0xFF2A9D8F);

  /// Secondary text, placeholders, disabled states, dividers.
  static const Color softGray = Color(0xFF8E99A4);

  /// Borders, card shadows, inactive toggle backgrounds.
  static const Color lightGray = Color(0xFFE8ECF0);

  // ---------------------------------------------------------------------------
  // Dark Mode — Primary
  // ---------------------------------------------------------------------------

  /// Page backgrounds in dark mode.
  static const Color deepNavy = Color(0xFF0D1B2A);

  /// Card backgrounds, elevated surfaces in dark mode.
  static const Color cardNavy = Color(0xFF1B2D45);

  /// Secondary backgrounds, input fields, grouped sections in dark mode.
  static const Color slate = Color(0xFF243447);

  // ---------------------------------------------------------------------------
  // Dark Mode — Accent (adjusted for dark background contrast)
  // ---------------------------------------------------------------------------

  /// Slightly warmer yellow for readability on dark backgrounds.
  static const Color warmYellowDark = Color(0xFFF5B041);

  /// Slightly lighter orange for contrast on dark backgrounds.
  static const Color sunsetOrangeDark = Color(0xFFEB7F56);

  /// Slightly lighter red for contrast on dark backgrounds.
  static const Color emberRedDark = Color(0xFFE05555);

  // ---------------------------------------------------------------------------
  // Dark Mode — Supporting
  // ---------------------------------------------------------------------------

  /// Slightly brighter teal for dark backgrounds.
  static const Color oceanTealDark = Color(0xFF34B3A3);

  /// Primary text on dark backgrounds.
  static const Color lightText = Color(0xFFE8ECF0);

  /// Secondary text on dark backgrounds (same as light mode soft gray).
  static const Color mutedText = Color(0xFF8E99A4);

  // ---------------------------------------------------------------------------
  // Intent Tag Colors
  // ---------------------------------------------------------------------------

  /// Growth intent — Ocean Teal.
  static const Color intentGrowth = oceanTeal;

  /// Connection intent — Sunset Orange.
  static const Color intentConnection = sunsetOrange;

  /// Fun intent — Warm Yellow.
  static const Color intentFun = warmYellow;

  /// Challenge intent — Ember Red.
  static const Color intentChallenge = emberRed;

  /// Explore intent — Navy.
  static const Color intentExplore = navy;

  /// Create intent — Purple (creative energy).
  static const Color intentCreate = Color(0xFF8B5CF6);

  // ---------------------------------------------------------------------------
  // Category Colors
  // ---------------------------------------------------------------------------

  /// Travel & Adventure category.
  static const Color categoryTravel = Color(0xFF2A9D8F);

  /// Food & Drink category.
  static const Color categoryFood = Color(0xFFE8734A);

  /// Fitness & Sports category.
  static const Color categoryFitness = Color(0xFFD94F4F);

  /// Creative & Arts category.
  static const Color categoryCreative = Color(0xFF8B5CF6);

  /// Social & Community category.
  static const Color categorySocial = Color(0xFFF5A623);

  /// Career & Learning category.
  static const Color categoryCareer = Color(0xFF1B2A4A);

  /// Thrill & Adrenaline category.
  static const Color categoryThrill = Color(0xFFE05555);

  /// Random / Wildcard category.
  static const Color categoryRandom = Color(0xFF8E99A4);

  // ---------------------------------------------------------------------------
  // Overlay
  // ---------------------------------------------------------------------------

  /// Black at 40% opacity for modal overlays.
  static const Color overlay = Color(0x66000000);

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Maps for lookup by key name.
  static const Map<String, Color> _categoryColors = {
    'travel': categoryTravel,
    'food': categoryFood,
    'fitness': categoryFitness,
    'creative': categoryCreative,
    'social': categorySocial,
    'career': categoryCareer,
    'thrill': categoryThrill,
    'random': categoryRandom,
  };

  static const Map<String, Color> _intentColors = {
    'growth': intentGrowth,
    'connection': intentConnection,
    'fun': intentFun,
    'challenge': intentChallenge,
    'explore': intentExplore,
    'create': intentCreate,
  };

  /// Returns the accent color for the given [category] key.
  ///
  /// Falls back to [softGray] if the category is not recognized.
  static Color categoryColor(String category) =>
      _categoryColors[category.toLowerCase()] ?? softGray;

  /// Returns the accent color for the given [intent] key.
  ///
  /// Falls back to [softGray] if the intent is not recognized.
  static Color intentColor(String intent) =>
      _intentColors[intent.toLowerCase()] ?? softGray;
}
