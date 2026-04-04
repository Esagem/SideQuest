import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A personality summary label based on the user's dominant intent.
class QuesterTypeSummary extends StatelessWidget {
  /// Creates a [QuesterTypeSummary].
  const QuesterTypeSummary({required this.dominantIntent, super.key});

  /// The dominant intent key (e.g. 'growth', 'fun').
  final String dominantIntent;

  String get _label => switch (dominantIntent) {
        'growth' => '🌱 Growth Seeker',
        'connection' => '🤝 The Connector',
        'fun' => '🎉 Fun Lover',
        'challenge' => '💪 The Challenger',
        'explore' => '🌍 Explorer at Heart',
        'create' => '🎨 Creative Spirit',
        _ => '⭐ Balanced Quester',
      };

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.sunsetOrange.withAlpha(26),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Text(
          _label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.sunsetOrange,
              ),
        ),
      );
}
