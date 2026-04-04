import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/core/theme/app_typography.dart';

/// Empty state shown when the user has no quests on their list.
///
/// Displays a motivational message with CTAs to create a quest
/// or explore popular quests.
class HomeEmptyState extends StatelessWidget {
  /// Creates a [HomeEmptyState].
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.map_outlined,
                size: AppSpacing.xxl * 2,
                color: AppColors.softGray,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Your quest list is empty',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'What have you always wanted to do?',
                style: AppTypography.caption,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              SQButton.primary(
                label: 'Create Your First Quest',
                icon: Icons.add,
                onPressed: () => context.push('/builder'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => context.go('/explore'),
                child: Text(
                  'Or explore popular quests',
                  style: AppTypography.body.copyWith(
                    color: AppColors.sunsetOrange,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
