import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A themed text input field with focus and error states.
///
/// Off-White background (Slate in dark mode), 12px radius, 1px border.
/// Focus state shows a 2px Sunset Orange border; error state shows
/// a 2px Ember Red border with error text below.
class SQInput extends StatelessWidget {
  /// Creates an [SQInput].
  const SQInput({
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.errorText,
    this.maxLines = 1,
    this.maxLength,
    this.obscureText = false,
    super.key,
  });

  /// Optional label displayed above the input.
  final String? label;

  /// Placeholder text shown when the input is empty.
  final String? hint;

  /// Controller for reading and writing text.
  final TextEditingController? controller;

  /// Validation function for form integration.
  final String? Function(String?)? validator;

  /// Explicit error text displayed below the input.
  final String? errorText;

  /// Maximum number of lines. Defaults to 1.
  final int maxLines;

  /// Maximum character length.
  final int? maxLength;

  /// Whether to obscure text (for passwords).
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          maxLength: maxLength,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            filled: true,
            fillColor: isDark ? AppColors.slate : AppColors.offWhite,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            border: const OutlineInputBorder(
              borderRadius: AppRadius.smallRadius,
              borderSide: BorderSide(color: AppColors.lightGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.smallRadius,
              borderSide: BorderSide(
                color: isDark ? AppColors.slate : AppColors.lightGray,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.smallRadius,
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.sunsetOrangeDark
                    : AppColors.sunsetOrange,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.smallRadius,
              borderSide: BorderSide(
                color: isDark ? AppColors.emberRedDark : AppColors.emberRed,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.smallRadius,
              borderSide: BorderSide(
                color: isDark ? AppColors.emberRedDark : AppColors.emberRed,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
