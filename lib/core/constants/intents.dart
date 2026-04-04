import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';

/// Intent tags representing the motivation behind a quest.
///
/// Each intent has a display name, accent color, and emoji identifier.
enum Intent {
  /// Personal development and learning.
  growth('Growth', AppColors.intentGrowth, '🌱'),

  /// Building relationships and shared experiences.
  connection('Connection', AppColors.intentConnection, '🤝'),

  /// Pure enjoyment and entertainment.
  fun('Fun', AppColors.intentFun, '🎉'),

  /// Pushing limits and testing abilities.
  challenge('Challenge', AppColors.intentChallenge, '💪'),

  /// Discovering new places and experiences.
  explore('Explore', AppColors.intentExplore, '🌍'),

  /// Making or building something new.
  create('Create', AppColors.intentCreate, '🎨');

  const Intent(this.displayName, this.color, this.emoji);

  /// Human-readable intent name.
  final String displayName;

  /// The accent color for this intent.
  final Color color;

  /// The emoji representing this intent.
  final String emoji;
}
