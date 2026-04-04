import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A pill-shaped chip for category and intent tags.
///
/// Unselected: 15% opacity background with full-color text.
/// Selected: full-color background with white text.
/// 20px corner radius, 32px height.
class SQChip extends StatelessWidget {
  /// Creates an [SQChip].
  const SQChip({
    required this.label,
    required this.color,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  /// The chip label text.
  final String label;

  /// The accent color for the chip.
  final Color color;

  /// Whether the chip is in selected state.
  final bool isSelected;

  /// Called when the chip is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: AppSpacing.xl,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: isSelected ? color : color.withOpacity(0.15),
            borderRadius: AppRadius.chipRadius,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected ? AppColors.white : color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      );
}
