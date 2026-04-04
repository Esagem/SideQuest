import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A themed toast/snackbar with success and error variants.
///
/// Navy background, white text, 12px radius, bottom-aligned.
/// Success shows an [AppColors.oceanTeal] left accent; error shows
/// an [AppColors.emberRed] left accent.
///
/// ```dart
/// SQToast.success(context, 'Quest completed!');
/// SQToast.error(context, 'Something went wrong.');
/// ```
abstract final class SQToast {
  /// Shows a success toast with an Ocean Teal left accent.
  static void success(BuildContext context, String message) =>
      _show(context, message: message, accentColor: AppColors.oceanTeal);

  /// Shows an error toast with an Ember Red left accent.
  static void error(BuildContext context, String message) =>
      _show(context, message: message, accentColor: AppColors.emberRed);

  static void _show(
    BuildContext context, {
    required String message,
    required Color accentColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                width: AppSpacing.xxs,
                height: AppSpacing.xl,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(AppSpacing.xxs),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.white,
                      ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.navy,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.smallRadius,
          ),
          margin: const EdgeInsets.all(AppSpacing.md),
        ),
      );
  }
}
