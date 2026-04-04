import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';

/// Predefined quest categories with display metadata.
///
/// Each category has a name, accent color from [AppColors], and
/// a representative icon.
enum Category {
  /// Travel & Adventure quests.
  travel('Travel & Adventure', AppColors.categoryTravel, Icons.flight_takeoff),

  /// Food & Drink quests.
  food('Food & Drink', AppColors.categoryFood, Icons.restaurant),

  /// Fitness & Sports quests.
  fitness('Fitness & Sports', AppColors.categoryFitness, Icons.fitness_center),

  /// Creative & Arts quests.
  creative('Creative & Arts', AppColors.categoryCreative, Icons.brush),

  /// Social & Community quests.
  social('Social & Community', AppColors.categorySocial, Icons.people),

  /// Career & Learning quests.
  career('Career & Learning', AppColors.categoryCareer, Icons.school),

  /// Thrill & Adrenaline quests.
  thrill('Thrill & Adrenaline', AppColors.categoryThrill, Icons.bolt),

  /// Random / Wildcard quests.
  random('Random / Wildcard', AppColors.categoryRandom, Icons.casino);

  const Category(this.displayName, this.color, this.icon);

  /// Human-readable category name.
  final String displayName;

  /// The accent color for this category.
  final Color color;

  /// The representative icon for this category.
  final IconData icon;
}
