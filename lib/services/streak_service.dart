import 'package:sidequest/models/user_model.dart';

/// Service for managing quest completion streaks.
///
/// Streaks use a 7-day rolling window: the user must complete at least
/// one quest per week to maintain their streak. A streak freeze can be
/// consumed to prevent a break.
abstract final class StreakService {
  /// The maximum days between completions before a streak breaks.
  static const int streakWindowDays = 7;

  /// Streak milestone weeks and their XP bonuses.
  static const Map<int, int> milestoneBonuses = {
    4: 50,
    12: 100,
    26: 200,
    52: 500,
  };

  /// Checks whether the user's streak is currently active.
  ///
  /// A streak is active if the user has completed a quest within the
  /// last [streakWindowDays] days.
  static bool isStreakActive(UserModel user, {DateTime? now}) {
    final currentTime = now ?? DateTime.now();
    if (user.lastCompletionDate == null) return false;
    final daysSince =
        currentTime.difference(user.lastCompletionDate!).inDays;
    return daysSince < streakWindowDays;
  }

  /// Determines what happens to a user's streak at the weekly check.
  ///
  /// Returns a [StreakCheckResult] indicating whether the streak
  /// continues, was saved by a freeze, or is broken.
  static StreakCheckResult checkStreak(UserModel user, {DateTime? now}) {
    if (isStreakActive(user, now: now)) {
      return StreakCheckResult.active(
        currentStreak: user.currentStreak,
      );
    }

    // Streak would break — check for available freeze
    if (user.streakFreezeAvailable > 0) {
      return StreakCheckResult.frozen(
        currentStreak: user.currentStreak,
        freezesRemaining: user.streakFreezeAvailable - 1,
      );
    }

    // Streak is broken
    return const StreakCheckResult.broken();
  }

  /// Calculates any milestone bonus for the given [streakWeeks].
  ///
  /// Returns 0 if the week count is not a milestone.
  static int calculateMilestone(int streakWeeks) =>
      milestoneBonuses[streakWeeks] ?? 0;

  /// Returns the number of streak freezes a user should have.
  ///
  /// Free users get 1 per month; Pro users get 3.
  static int monthlyFreezeAllocation({required bool isPro}) =>
      isPro ? 3 : 1;
}

/// The result of a streak check.
class StreakCheckResult {
  const StreakCheckResult._({
    required this.status,
    required this.currentStreak,
    this.freezesRemaining,
  });

  /// Streak is still active.
  const StreakCheckResult.active({required int currentStreak})
      : this._(
          status: StreakStatus.active,
          currentStreak: currentStreak,
        );

  /// Streak was saved by consuming a freeze.
  const StreakCheckResult.frozen({
    required int currentStreak,
    required int freezesRemaining,
  }) : this._(
          status: StreakStatus.frozen,
          currentStreak: currentStreak,
          freezesRemaining: freezesRemaining,
        );

  /// Streak is broken — resets to 0.
  const StreakCheckResult.broken()
      : this._(
          status: StreakStatus.broken,
          currentStreak: 0,
          freezesRemaining: null,
        );

  /// The status after the check.
  final StreakStatus status;

  /// The streak count after the check (0 if broken).
  final int currentStreak;

  /// Remaining freezes after consuming one (null if not frozen).
  final int? freezesRemaining;
}

/// Status outcomes of a streak check.
enum StreakStatus {
  /// Streak is active — completed within the window.
  active,

  /// Streak was about to break but a freeze was consumed.
  frozen,

  /// Streak broke — no completion and no freeze available.
  broken,
}
