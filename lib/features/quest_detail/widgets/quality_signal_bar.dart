import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A bar with "Worth It" and "Needs Work" quality signal buttons.
///
/// Shown after a user has completed a quest so they can rate it.
class QualitySignalBar extends StatelessWidget {
  /// Creates a [QualitySignalBar].
  const QualitySignalBar({
    required this.worthItCount,
    required this.needsWorkCount,
    required this.onWorthIt,
    required this.onNeedsWork,
    this.hasSignaled = false,
    super.key,
  });

  /// Total "Worth It" signals for this quest.
  final int worthItCount;

  /// Total "Needs Work" signals for this quest.
  final int needsWorkCount;

  /// Called when the user taps "Worth It".
  final VoidCallback onWorthIt;

  /// Called when the user taps "Needs Work".
  final VoidCallback onNeedsWork;

  /// Whether the current user has already signaled.
  final bool hasSignaled;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'How was this quest?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _SignalButton(
                  label: 'Worth It',
                  count: worthItCount,
                  icon: Icons.thumb_up_outlined,
                  color: AppColors.oceanTeal,
                  onTap: hasSignaled ? null : onWorthIt,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SignalButton(
                  label: 'Needs Work',
                  count: needsWorkCount,
                  icon: Icons.thumb_down_outlined,
                  color: AppColors.softGray,
                  onTap: hasSignaled ? null : onNeedsWork,
                ),
              ),
            ],
          ),
          if (hasSignaled)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                'Thanks for your feedback!',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.softGray,
                    ),
              ),
            ),
        ],
      );
}

class _SignalButton extends StatelessWidget {
  const _SignalButton({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String label;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SQButton.tertiary(
        label: '$label ($count)',
        icon: icon,
        onPressed: onTap,
      );
}
