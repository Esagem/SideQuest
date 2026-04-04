import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_quest_card.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/core/theme/app_typography.dart';

/// Onboarding step 3: show 3 starter quests auto-generated from preferences.
class StarterQuestsScreen extends StatelessWidget {
  /// Creates a [StarterQuestsScreen].
  const StarterQuestsScreen({super.key});

  /// Seed quest data for onboarding preview.
  static const _starterQuests = [
    SQQuestCardData(
      title: "Visit a place you've never been",
      category: 'travel',
      intents: ['explore'],
      difficulty: 'Easy',
    ),
    SQQuestCardData(
      title: "Try a cuisine you've never tasted",
      category: 'food',
      intents: ['fun'],
      difficulty: 'Easy',
    ),
    SQQuestCardData(
      title: 'Teach someone a skill you know',
      category: 'social',
      intents: ['connection', 'growth'],
      difficulty: 'Medium',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                const Text(
                  'Here are your first quests',
                  style: AppTypography.hero,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  "We've added these to your list to get you started.",
                  style: AppTypography.caption.copyWith(
                    color: AppColors.softGray,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: ListView.separated(
                    itemCount: _starterQuests.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (_, index) => Stack(
                      children: [
                        SQQuestCard(quest: _starterQuests[index]),
                        const Positioned(
                          top: AppSpacing.xs,
                          right: AppSpacing.xs,
                          child: Icon(
                            Icons.check_circle,
                            color: AppColors.oceanTeal,
                            size: AppSpacing.lg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SQButton.primary(
                  label: "Let's Go!",
                  onPressed: () {
                    // TODO(onboarding): Save preferences + create UserQuests
                    context.go('/');
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      );
}
