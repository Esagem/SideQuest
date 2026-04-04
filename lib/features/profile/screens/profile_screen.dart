import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_avatar.dart';
import 'package:sidequest/core/components/sq_bottom_sheet.dart';
import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/components/sq_loading.dart';
import 'package:sidequest/core/constants/tiers.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/profile/widgets/badge_showcase.dart';
import 'package:sidequest/features/profile/widgets/intent_breakdown_chart.dart';
import 'package:sidequest/features/profile/widgets/profile_stats.dart';
import 'package:sidequest/features/profile/widgets/trophy_case.dart';
import 'package:sidequest/models/user_model.dart';
import 'package:sidequest/providers/user_providers.dart';

/// The current user's profile screen.
///
/// Shows avatar, name, badge showcase, tier, streak, intent breakdown,
/// stats, trophy case, and edit profile button.
class ProfileScreen extends ConsumerWidget {
  /// Creates a [ProfileScreen].
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('Not signed in'));
          return _ProfileBody(user: user);
        },
        loading: () => const SQLoading(),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final tier = Tier.fromXp(user.xp);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Column(
              children: [
                SQAvatar(
                  displayName: user.displayName,
                  imageUrl: user.avatarUrl,
                  size: AppSpacing.xxl * 2,
                  tierBadge: user.tier,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '@${user.username}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (user.bio != null && user.bio!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    user.bio!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Badge showcase
          if (user.badgeShowcase.isNotEmpty) ...[
            Center(child: BadgeShowcase(badgeIds: user.badgeShowcase)),
            const SizedBox(height: AppSpacing.md),
          ],

          // Tier + XP
          _TierDisplay(tier: tier, xp: user.xp),
          const SizedBox(height: AppSpacing.xs),

          // Streak
          if (user.currentStreak > 0) ...[
            _StreakDisplay(streak: user.currentStreak),
            const SizedBox(height: AppSpacing.md),
          ],

          // Stats
          ProfileStats(
            questsCompleted: user.questsCompleted,
            friendCount: user.friendCount,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Intent breakdown
          if (user.intentStats.isNotEmpty)
            IntentBreakdownChart(intentStats: user.intentStats),
          const SizedBox(height: AppSpacing.lg),

          // Trophy case placeholder — would need completed quest proofs
          const TrophyCase(proofUrls: []),
          const SizedBox(height: AppSpacing.lg),

          // Edit profile
          Center(
            child: SQButton.tertiary(
              label: 'Edit Profile',
              icon: Icons.edit,
              onPressed: () => _showEditSheet(context),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    SQBottomSheet.show<void>(
      context,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SQInput(label: 'Display Name', hint: 'Your name'),
            const SizedBox(height: AppSpacing.sm),
            const SQInput(label: 'Username', hint: '@username'),
            const SizedBox(height: AppSpacing.sm),
            const SQInput(label: 'Bio', hint: 'Tell us about yourself', maxLines: 3),
            const SizedBox(height: AppSpacing.md),
            SQButton.primary(
              label: 'Save',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TierDisplay extends StatelessWidget {
  const _TierDisplay({required this.tier, required this.xp});

  final Tier tier;
  final int xp;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(tier.icon, color: AppColors.warmYellow, size: AppSpacing.lg),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${tier.label} — $xp XP',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );
}

class _StreakDisplay extends StatelessWidget {
  const _StreakDisplay({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 20)),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$streak week streak',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );
}
