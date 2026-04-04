import 'package:sidequest/models/user_model.dart';

/// Service for checking badge eligibility.
///
/// Evaluates a user's stats against badge unlock conditions and
/// returns any newly earned badge IDs.
abstract final class BadgeService {
  /// Checks all badge conditions against the user's current stats.
  ///
  /// Returns a list of badge IDs the user has newly earned (not
  /// already in [user.badges]).
  static List<String> checkEligibility({
    required UserModel user,
    int categoryCompletions = 0,
    String? completedCategory,
    int challengesSent = 0,
    int challengesCompleted = 0,
    int questAddedCount = 0,
  }) {
    final earned = <String>[];
    final existing = user.badges.toSet();

    void award(String id) {
      if (!existing.contains(id)) earned.add(id);
    }

    // Milestone badges
    if (user.questsCompleted >= 1) award('first_quest');
    if (user.questsCompleted >= 10) award('ten_quests');
    if (user.questsCompleted >= 50) award('fifty_quests');
    if (user.questsCompleted >= 100) award('hundred_quests');

    // Streak badges
    if (user.currentStreak >= 7) award('streak_7');
    if (user.currentStreak >= 30) award('streak_30');

    // Category badges — check if 10+ completions in specific category
    if (completedCategory != null && categoryCompletions >= 10) {
      final categoryBadge = _categoryBadges[completedCategory];
      if (categoryBadge != null) award(categoryBadge);
    }

    // Intent badges — check intentStats
    final intentStats = user.intentStats;
    if ((intentStats['connection'] ?? 0) >= 10) award('connector');
    if ((intentStats['growth'] ?? 0) >= 10) award('grower');

    // Social badges
    if (challengesSent >= 5) award('challenger');
    if (challengesCompleted >= 5) award('accepter');

    // Creator badge
    if (questAddedCount >= 50) award('builder');

    return earned;
  }

  /// Maps category keys to their badge IDs.
  static const _categoryBadges = {
    'travel': 'globetrotter',
    'food': 'foodie',
    'fitness': 'athlete',
    'creative': 'artist',
  };
}
