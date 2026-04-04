import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_avatar.dart';
import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/constants/tiers.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/profile/widgets/badge_showcase.dart';
import 'package:sidequest/features/profile/widgets/profile_stats.dart';
import 'package:sidequest/models/user_model.dart';

/// A read-only profile screen for viewing another user's profile.
///
/// Shows the same layout as [ProfileScreen] but with friend action
/// buttons instead of edit controls.
class FriendProfileScreen extends StatelessWidget {
  /// Creates a [FriendProfileScreen].
  const FriendProfileScreen({
    required this.userId,
    this.user,
    this.isFriend = false,
    super.key,
  });

  /// The user ID to display.
  final String userId;

  /// The user data, if already loaded.
  final UserModel? user;

  /// Whether the current user is friends with this user.
  final bool isFriend;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('User not found')),
      );
    }
    final u = user!;
    final tier = Tier.fromXp(u.xp);

    return Scaffold(
      appBar: AppBar(
        title: Text(u.displayName),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // TODO(social): Handle block/report
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'block', child: Text('Block User')),
              PopupMenuItem(value: 'report', child: Text('Report User')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Avatar + name
            SQAvatar(
              displayName: u.displayName,
              imageUrl: u.avatarUrl,
              size: AppSpacing.xxl * 2,
              tierBadge: u.tier,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(u.displayName,
                style: Theme.of(context).textTheme.headlineMedium,),
            Text('@${u.username}',
                style: Theme.of(context).textTheme.bodySmall,),
            if (u.bio != null && u.bio!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(u.bio!, style: Theme.of(context).textTheme.bodyLarge),
            ],
            const SizedBox(height: AppSpacing.md),

            // Badges
            if (u.badgeShowcase.isNotEmpty) ...[
              BadgeShowcase(badgeIds: u.badgeShowcase),
              const SizedBox(height: AppSpacing.md),
            ],

            // Tier + streak
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tier.icon, color: AppColors.warmYellow),
                const SizedBox(width: AppSpacing.xxs),
                Text('${tier.label} — ${u.xp} XP'),
                if (u.currentStreak > 0) ...[
                  const SizedBox(width: AppSpacing.md),
                  Text('🔥 ${u.currentStreak}'),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Stats
            ProfileStats(
              questsCompleted: u.questsCompleted,
              friendCount: u.friendCount,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Actions
            if (isFriend)
              SQButton.secondary(
                label: 'Challenge',
                icon: Icons.bolt,
                onPressed: () {},
              )
            else
              SQButton.primary(
                label: 'Add Friend',
                icon: Icons.person_add,
                onPressed: () {},
              ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
