import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';

/// A badge definition with display metadata and unlock condition.
///
/// Badges are the primary achievement signal in SideQuest, displayed
/// prominently on profiles and leaderboard entries.
class Badge {
  /// Creates a [Badge].
  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlockCondition,
  });

  /// Unique identifier for this badge.
  final String id;

  /// Human-readable badge name.
  final String name;

  /// Description of how to earn this badge.
  final String description;

  /// The icon representing this badge.
  final IconData icon;

  /// The accent color for this badge.
  final Color color;

  /// Human-readable description of the unlock condition.
  final String unlockCondition;
}

/// All badges available in SideQuest.
///
/// Organized by category: milestone, category-specific, intent-specific,
/// social, and creator badges.
abstract final class Badges {
  // ---------------------------------------------------------------------------
  // Milestone Badges
  // ---------------------------------------------------------------------------

  /// Earned by completing your first quest.
  static const Badge firstQuest = Badge(
    id: 'first_quest',
    name: 'First Steps',
    description: 'Complete your first quest.',
    icon: Icons.flag_rounded,
    color: AppColors.oceanTeal,
    unlockCondition: 'Complete 1 quest',
  );

  /// Earned by completing 10 quests.
  static const Badge tenQuests = Badge(
    id: 'ten_quests',
    name: 'Getting Started',
    description: 'Complete 10 quests.',
    icon: Icons.emoji_events_rounded,
    color: AppColors.warmYellow,
    unlockCondition: 'Complete 10 quests',
  );

  /// Earned by completing 50 quests.
  static const Badge fiftyQuests = Badge(
    id: 'fifty_quests',
    name: 'Seasoned Quester',
    description: 'Complete 50 quests.',
    icon: Icons.emoji_events_rounded,
    color: AppColors.sunsetOrange,
    unlockCondition: 'Complete 50 quests',
  );

  /// Earned by completing 100 quests.
  static const Badge hundredQuests = Badge(
    id: 'hundred_quests',
    name: 'Century Club',
    description: 'Complete 100 quests.',
    icon: Icons.emoji_events_rounded,
    color: AppColors.emberRed,
    unlockCondition: 'Complete 100 quests',
  );

  // ---------------------------------------------------------------------------
  // Streak Badges
  // ---------------------------------------------------------------------------

  /// Earned by maintaining a 7-day streak.
  static const Badge streak7 = Badge(
    id: 'streak_7',
    name: 'Week Warrior',
    description: 'Maintain a 7-day streak.',
    icon: Icons.local_fire_department,
    color: AppColors.sunsetOrange,
    unlockCondition: '7-day streak',
  );

  /// Earned by maintaining a 30-day streak.
  static const Badge streak30 = Badge(
    id: 'streak_30',
    name: 'Monthly Legend',
    description: 'Maintain a 30-day streak.',
    icon: Icons.local_fire_department,
    color: AppColors.emberRed,
    unlockCondition: '30-day streak',
  );

  // ---------------------------------------------------------------------------
  // Category Badges
  // ---------------------------------------------------------------------------

  /// Earned by completing 10 Travel & Adventure quests.
  static const Badge globetrotter = Badge(
    id: 'globetrotter',
    name: 'Globetrotter',
    description: 'Complete 10 Travel & Adventure quests.',
    icon: Icons.flight_takeoff,
    color: AppColors.categoryTravel,
    unlockCondition: '10 Travel quests',
  );

  /// Earned by completing 10 Food & Drink quests.
  static const Badge foodie = Badge(
    id: 'foodie',
    name: 'Foodie',
    description: 'Complete 10 Food & Drink quests.',
    icon: Icons.restaurant,
    color: AppColors.categoryFood,
    unlockCondition: '10 Food quests',
  );

  /// Earned by completing 10 Fitness & Sports quests.
  static const Badge athlete = Badge(
    id: 'athlete',
    name: 'Athlete',
    description: 'Complete 10 Fitness & Sports quests.',
    icon: Icons.fitness_center,
    color: AppColors.categoryFitness,
    unlockCondition: '10 Fitness quests',
  );

  /// Earned by completing 10 Creative & Arts quests.
  static const Badge artist = Badge(
    id: 'artist',
    name: 'Artist',
    description: 'Complete 10 Creative & Arts quests.',
    icon: Icons.brush,
    color: AppColors.categoryCreative,
    unlockCondition: '10 Creative quests',
  );

  // ---------------------------------------------------------------------------
  // Intent Badges
  // ---------------------------------------------------------------------------

  /// Earned by completing 10 quests tagged with the Connection intent.
  static const Badge connector = Badge(
    id: 'connector',
    name: 'Connector',
    description: 'Complete 10 Connection-tagged quests.',
    icon: Icons.people_rounded,
    color: AppColors.intentConnection,
    unlockCondition: '10 Connection quests',
  );

  /// Earned by completing 10 quests tagged with the Growth intent.
  static const Badge grower = Badge(
    id: 'grower',
    name: 'Growth Seeker',
    description: 'Complete 10 Growth-tagged quests.',
    icon: Icons.eco,
    color: AppColors.intentGrowth,
    unlockCondition: '10 Growth quests',
  );

  // ---------------------------------------------------------------------------
  // Social Badges
  // ---------------------------------------------------------------------------

  /// Earned by challenging 5 friends.
  static const Badge challenger = Badge(
    id: 'challenger',
    name: 'Challenger',
    description: 'Challenge 5 friends to quests.',
    icon: Icons.bolt_rounded,
    color: AppColors.emberRed,
    unlockCondition: 'Challenge 5 friends',
  );

  /// Earned by completing 5 challenges from friends.
  static const Badge accepter = Badge(
    id: 'accepter',
    name: 'Challenge Accepted',
    description: 'Complete 5 challenges from friends.',
    icon: Icons.handshake,
    color: AppColors.warmYellow,
    unlockCondition: 'Complete 5 challenges',
  );

  // ---------------------------------------------------------------------------
  // Creator Badge
  // ---------------------------------------------------------------------------

  /// Earned when a quest you created is added by 50+ people.
  static const Badge builder = Badge(
    id: 'builder',
    name: 'Quest Builder',
    description: 'Create a quest that 50+ people added.',
    icon: Icons.construction_rounded,
    color: AppColors.navy,
    unlockCondition: 'Created quest with 50+ adds',
  );

  /// All badges in the system.
  static const List<Badge> all = [
    firstQuest,
    tenQuests,
    fiftyQuests,
    hundredQuests,
    streak7,
    streak30,
    globetrotter,
    foodie,
    athlete,
    artist,
    connector,
    grower,
    challenger,
    accepter,
    builder,
  ];
}
