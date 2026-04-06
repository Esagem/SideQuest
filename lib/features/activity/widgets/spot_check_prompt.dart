import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A subtle spot-check prompt shown on ~10% of quest completions.
///
/// Asks "Legit?" with two playful buttons. Results are stored for
/// moderation review if multiple "Hmm" flags accumulate.
class SpotCheckPrompt extends StatelessWidget {
  /// Creates a [SpotCheckPrompt].
  const SpotCheckPrompt({
    required this.onLegit,
    required this.onHmm,
    this.hasResponded = false,
    super.key,
  });

  /// Called when the user taps "Legit ✓".
  final VoidCallback onLegit;

  /// Called when the user taps "Hmm... 🤔".
  final VoidCallback onHmm;

  /// Whether the user has already responded.
  final bool hasResponded;

  @override
  Widget build(BuildContext context) {
    if (hasResponded) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xs),
        child: Text(
          'Thanks for checking!',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.softGray,
              ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Wrap(
        spacing: AppSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Legit?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.softGray,
                ),
          ),
          _SpotButton(
            label: 'Legit ✓',
            color: AppColors.oceanTeal,
            onTap: onLegit,
          ),
          _SpotButton(
            label: 'Hmm... 🤔',
            color: AppColors.softGray,
            onTap: onHmm,
          ),
        ],
      ),
    );
  }
}

class _SpotButton extends StatelessWidget {
  const _SpotButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                ),
          ),
        ),
      );
}
