import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A styled social authentication button for Google or Apple sign-in.
class SocialAuthButton extends StatelessWidget {
  /// Creates a Google sign-in button.
  const SocialAuthButton.google({
    required this.onPressed,
    super.key,
  })  : _label = 'Continue with Google',
        _icon = Icons.g_mobiledata;

  /// Creates an Apple sign-in button.
  const SocialAuthButton.apple({
    required this.onPressed,
    super.key,
  })  : _label = 'Continue with Apple',
        _icon = Icons.apple;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  final String _label;
  final IconData _icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: AppSpacing.xxl,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(_icon, size: AppSpacing.lg),
        label: Text(_label),
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.lightText : AppColors.navy,
          side: BorderSide(
            color: isDark ? AppColors.slate : AppColors.lightGray,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.smallRadius,
          ),
        ),
      ),
    );
  }
}
