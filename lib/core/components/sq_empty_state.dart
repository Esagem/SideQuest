import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A centered empty state with icon placeholder, title, message, and CTA.
///
/// Used when a list or screen has no content to display.
class SQEmptyState extends StatelessWidget {
  /// Creates an [SQEmptyState].
  const SQEmptyState({
    required this.title,
    required this.message,
    this.ctaLabel,
    this.onCta,
    this.icon = Icons.explore_outlined,
    super.key,
  });

  /// The heading text.
  final String title;

  /// The descriptive message below the title.
  final String message;

  /// Optional CTA button label. Button is hidden when null.
  final String? ctaLabel;

  /// Called when the CTA button is tapped.
  final VoidCallback? onCta;

  /// Illustration placeholder icon. Defaults to explore.
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppSpacing.xxl * 2,
                color: AppColors.softGray,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                message,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              if (ctaLabel != null) ...[
                const SizedBox(height: AppSpacing.lg),
                SQButton.primary(label: ctaLabel!, onPressed: onCta),
              ],
            ],
          ),
        ),
      );
}
