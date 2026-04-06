import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_avatar.dart';
import 'package:sidequest/core/components/sq_badge_icon.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/leaderboard_entry_model.dart';

/// A single row in the leaderboard showing rank, avatar, stats, and badges.
///
/// Ranks 1–3 receive gold/silver/bronze accent styling. Tapping
/// navigates to the user's profile.
class LeaderboardEntry extends StatelessWidget {
  /// Creates a [LeaderboardEntry].
  const LeaderboardEntry({
    required this.entry,
    this.isCurrentUser = false,
    super.key,
  });

  /// The leaderboard entry data.
  final LeaderboardEntryModel entry;

  /// Whether this entry is the current user (highlighted).
  final bool isCurrentUser;

  Color get _rankColor => switch (entry.rank) {
        1 => AppColors.warmYellow,
        2 => AppColors.softGray,
        3 => AppColors.sunsetOrange,
        _ => Colors.transparent,
      };

  bool get _isTopThree => entry.rank <= 3;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push('/profile/${entry.userId}'),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? AppColors.sunsetOrange.withAlpha(26)
              : isDark
                  ? AppColors.cardNavy
                  : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: AppSpacing.xl,
              child: _isTopThree
                  ? CircleAvatar(
                      radius: AppSpacing.sm,
                      backgroundColor: _rankColor,
                      child: Text(
                        '${entry.rank}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : Text(
                      '${entry.rank}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Avatar
            SQAvatar(
              displayName: entry.displayName,
              imageUrl: entry.avatarUrl,
              size: AppSpacing.xxl,
            ),
            const SizedBox(width: AppSpacing.sm),
            // Name + username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          entry.displayName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrentUser)
                        Padding(
                          padding: const EdgeInsets.only(left: AppSpacing.xxs),
                          child: Text(
                            '(You)',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.sunsetOrange,
                                ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    '@${entry.username}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            // Mini badge showcase
            if (entry.badgeShowcase.isNotEmpty)
              Flexible(
                flex: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final badgeId in entry.badgeShowcase.take(3))
                      Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.xxs),
                        child: SQBadgeIcon(
                          badgeId: badgeId,
                          size: AppSpacing.lg,
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            // XP
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.xp}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  'XP',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
