
import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_avatar.dart';
import 'package:sidequest/core/components/sq_badge_icon.dart';
import 'package:sidequest/core/components/sq_card.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/activity/widgets/reaction_bar.dart';
import 'package:sidequest/features/activity/widgets/spot_check_prompt.dart';
import 'package:sidequest/models/activity_model.dart';

/// A card displaying a single activity feed item.
///
/// Renders differently based on [ActivityType]: quest completed,
/// stage completed, badge earned, streak milestone, or challenge completed.
class ActivityCard extends StatelessWidget {
  /// Creates an [ActivityCard].
  const ActivityCard({
    required this.activity,
    this.displayName = '',
    this.avatarUrl,
    this.reactions = const {},
    this.userReaction,
    this.onReact,
    this.showSpotCheck = false,
    this.onSpotCheckLegit,
    this.onSpotCheckHmm,
    this.spotCheckResponded = false,
    this.onTap,
    super.key,
  });

  /// The activity data.
  final ActivityModel activity;

  /// The display name of the activity's user.
  final String displayName;

  /// The avatar URL of the activity's user.
  final String? avatarUrl;

  /// Reaction counts by emoji.
  final Map<String, int> reactions;

  /// The current user's reaction emoji.
  final String? userReaction;

  /// Called when a reaction is tapped.
  final ValueChanged<String?>? onReact;

  /// Whether to show the spot-check prompt.
  final bool showSpotCheck;

  /// Called when "Legit" is tapped.
  final VoidCallback? onSpotCheckLegit;

  /// Called when "Hmm..." is tapped.
  final VoidCallback? onSpotCheckHmm;

  /// Whether the spot check has been responded to.
  final bool spotCheckResponded;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  String get _timeAgo {
    final diff = DateTime.now().difference(activity.createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) => SQCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: avatar + name + time
            Row(
              children: [
                SQAvatar(
                  displayName: displayName,
                  imageUrl: avatarUrl,
                  size: AppSpacing.xl,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        _timeAgo,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Content by type
            _ActivityContent(activity: activity),

            // Reactions
            if (onReact != null) ...[
              const SizedBox(height: AppSpacing.sm),
              ReactionBar(
                reactions: reactions,
                userReaction: userReaction,
                onReact: onReact!,
              ),
            ],

            // Spot check
            if (showSpotCheck && onSpotCheckLegit != null)
              SpotCheckPrompt(
                onLegit: onSpotCheckLegit!,
                onHmm: onSpotCheckHmm ?? () {},
                hasResponded: spotCheckResponded,
              ),
          ],
        ),
      );
}

class _ActivityContent extends StatelessWidget {
  const _ActivityContent({required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) => switch (activity.type) {
        ActivityType.questCompleted => _QuestCompleted(activity: activity),
        ActivityType.stageCompleted => _StageCompleted(activity: activity),
        ActivityType.badgeEarned => _BadgeEarned(activity: activity),
        ActivityType.streakMilestone => _StreakMilestone(activity: activity),
        ActivityType.challengeCompleted =>
          _ChallengeCompleted(activity: activity),
        _ => Text(
            activity.type.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
      };
}

class _QuestCompleted extends StatelessWidget {
  const _QuestCompleted({required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    final meta = activity.metadata;
    final xp = meta['xp'] as int? ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Completed a quest! 🎉',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (xp > 0)
          Text(
            '+$xp XP',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.warmYellow,
                  fontWeight: FontWeight.w600,
                ),
          ),
        if (activity.proofUrl != null) ...[
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            child: Image.network(
              activity.proofUrl!,
              height: AppSpacing.xxl * 3,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ],
      ],
    );
  }
}

class _StageCompleted extends StatelessWidget {
  const _StageCompleted({required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    final meta = activity.metadata;
    final stageId = meta['stageId'] as String? ?? '';
    final xp = meta['xp'] as int? ?? 0;

    return Text(
      'Completed stage "$stageId" (+$xp XP)',
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

class _BadgeEarned extends StatelessWidget {
  const _BadgeEarned({required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    final badgeId = activity.metadata['badgeId'] as String? ?? '';

    return Row(
      children: [
        SQBadgeIcon(badgeId: badgeId, size: AppSpacing.xxl),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'Earned a new badge! 🏅',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class _StreakMilestone extends StatelessWidget {
  const _StreakMilestone({required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    final streak = activity.metadata['streak'] as int? ?? 0;

    return Text(
      '🔥 $streak week streak!',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.sunsetOrange,
          ),
    );
  }
}

class _ChallengeCompleted extends StatelessWidget {
  const _ChallengeCompleted({required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) => Text(
        'Completed a challenge! ⚡',
        style: Theme.of(context).textTheme.bodyLarge,
      );
}
