import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_shadows.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A themed card surface with optional category-colored left border.
///
/// Uses white background in light mode, [AppColors.cardNavy] in dark mode,
/// 16px radius, card shadow, and 16px internal padding.
///
/// ```dart
/// SQCard(
///   categoryAccent: 'travel',
///   child: Text('My quest'),
/// )
/// ```
class SQCard extends StatelessWidget {
  /// Creates an [SQCard].
  const SQCard({
    required this.child,
    this.categoryAccent,
    this.onTap,
    super.key,
  });

  /// The card content.
  final Widget child;

  /// Optional category key to show a colored left border accent.
  ///
  /// Uses [AppColors.categoryColor] to resolve the color.
  final String? categoryAccent;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = categoryAccent != null
        ? AppColors.categoryColor(categoryAccent!)
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardNavy : AppColors.white,
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.cardShadow,
          border: accentColor != null
              ? Border(left: BorderSide(color: accentColor, width: 3))
              : null,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: child,
      ),
    );
  }
}
