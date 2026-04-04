import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A row of stat cards showing total completed, friends, and challenges.
class ProfileStats extends StatelessWidget {
  /// Creates a [ProfileStats].
  const ProfileStats({
    required this.questsCompleted,
    required this.friendCount,
    this.challengesSent = 0,
    super.key,
  });

  /// Total quests completed.
  final int questsCompleted;

  /// Number of friends.
  final int friendCount;

  /// Number of challenges sent.
  final int challengesSent;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: _StatCard(
              value: questsCompleted,
              label: 'Completed',
              icon: Icons.check_circle_outline,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: _StatCard(
              value: friendCount,
              label: 'Friends',
              icon: Icons.people_outline,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: _StatCard(
              value: challengesSent,
              label: 'Challenges',
              icon: Icons.bolt,
            ),
          ),
        ],
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final int value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate : AppColors.offWhite,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.softGray, size: AppSpacing.lg),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '$value',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
