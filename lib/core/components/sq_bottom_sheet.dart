import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A themed modal bottom sheet with drag handle and rounded top corners.
///
/// 24px top corner radius, drag handle indicator, overlay at 40% black.
///
/// ```dart
/// SQBottomSheet.show(context, child: MyContent());
/// ```
abstract final class SQBottomSheet {
  /// Shows a modal bottom sheet with theming and drag handle.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: AppColors.overlay,
        isScrollControlled: true,
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return DecoratedBox(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardNavy : AppColors.white,
              borderRadius: AppRadius.sheetRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppSpacing.sm),
                _DragHandle(isDark: isDark),
                const SizedBox(height: AppSpacing.md),
                Flexible(child: child),
              ],
            ),
          );
        },
      );
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) => Container(
        width: AppSpacing.xl,
        height: AppSpacing.xxs,
        decoration: BoxDecoration(
          color: isDark ? AppColors.mutedText : AppColors.lightGray,
          borderRadius: BorderRadius.circular(AppSpacing.xxs),
        ),
      );
}
