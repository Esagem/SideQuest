import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_shadows.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A themed button with primary, secondary, tertiary, and destructive variants.
///
/// Uses [AppColors] for all color values and [AppRadius] / [AppSpacing]
/// for dimensions. Supports loading and disabled states.
///
/// ```dart
/// SQButton.primary(label: 'Complete Quest', onPressed: () {})
/// SQButton.secondary(label: 'Challenge', icon: Icons.bolt, onPressed: () {})
/// ```
class SQButton extends StatelessWidget {
  /// Creates a primary CTA button (Sunset Orange background, white text).
  const SQButton.primary({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  })  : _variant = _SQButtonVariant.primary;

  /// Creates a secondary button (Navy background, white text).
  const SQButton.secondary({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  })  : _variant = _SQButtonVariant.secondary;

  /// Creates a tertiary/ghost button (transparent, Navy text, Navy border).
  const SQButton.tertiary({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  })  : _variant = _SQButtonVariant.tertiary;

  /// Creates a destructive button (Ember Red background, white text).
  const SQButton.destructive({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  })  : _variant = _SQButtonVariant.destructive;

  /// The button label text.
  final String label;

  /// Called when the button is tapped. Null disables the button.
  final VoidCallback? onPressed;

  /// Whether to show a loading spinner instead of the label.
  final bool isLoading;

  /// Optional leading icon.
  final IconData? icon;

  final _SQButtonVariant _variant;

  bool get _isDisabled => onPressed == null && !isLoading;

  Color get _backgroundColor {
    if (_isDisabled) return AppColors.lightGray;
    return switch (_variant) {
      _SQButtonVariant.primary => AppColors.sunsetOrange,
      _SQButtonVariant.secondary => AppColors.navy,
      _SQButtonVariant.tertiary => Colors.transparent,
      _SQButtonVariant.destructive => AppColors.emberRed,
    };
  }

  Color get _foregroundColor {
    if (_isDisabled) return AppColors.softGray;
    return switch (_variant) {
      _SQButtonVariant.tertiary => AppColors.navy,
      _ => AppColors.white,
    };
  }

  BorderSide? get _borderSide {
    if (_variant == _SQButtonVariant.tertiary && !_isDisabled) {
      return const BorderSide(color: AppColors.navy);
    }
    if (_variant == _SQButtonVariant.tertiary && _isDisabled) {
      return const BorderSide(color: AppColors.lightGray);
    }
    return BorderSide.none;
  }

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: _backgroundColor,
      foregroundColor: _foregroundColor,
      disabledBackgroundColor: AppColors.lightGray,
      disabledForegroundColor: AppColors.softGray,
      minimumSize: const Size.fromHeight(AppSpacing.xxl),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.smallRadius,
        side: _borderSide ?? BorderSide.none,
      ),
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );

    final child = isLoading
        ? SizedBox(
            height: AppSpacing.lg,
            width: AppSpacing.lg,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _foregroundColor,
            ),
          )
        : _buildLabel();

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: _isDisabled || _variant == _SQButtonVariant.tertiary
            ? const []
            : AppShadows.buttonShadow,
        borderRadius: AppRadius.smallRadius,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: child,
      ),
    );
  }

  Widget _buildLabel() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.lg),
          const SizedBox(width: AppSpacing.xs),
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      );
    }
    return Text(label, overflow: TextOverflow.ellipsis);
  }
}

enum _SQButtonVariant { primary, secondary, tertiary, destructive }
