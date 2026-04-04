import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';

/// Difficulty levels for quests with XP multiplier values.
///
/// Each level has a display label, multiplier applied to base XP,
/// and an accent color.
enum DifficultyLevel {
  /// Easy quests — 1.0x multiplier.
  easy('Easy', 1, AppColors.oceanTeal),

  /// Medium quests — 1.5x multiplier.
  medium('Medium', 1.5, AppColors.warmYellow),

  /// Hard quests — 2.0x multiplier.
  hard('Hard', 2, AppColors.sunsetOrange),

  /// Legendary quests — 3.0x multiplier.
  legendary('Legendary', 3, AppColors.emberRed);

  const DifficultyLevel(this.label, this.multiplier, this.color);

  /// Human-readable difficulty label.
  final String label;

  /// XP multiplier applied to [baseXp].
  final double multiplier;

  /// The accent color for this difficulty.
  final Color color;
}
