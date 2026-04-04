import 'dart:io';

import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A preview of the captured proof image(s).
///
/// For Before & After proof type, shows two images side by side.
/// For single photos, shows one large preview.
class ProofPreview extends StatelessWidget {
  /// Creates a [ProofPreview].
  const ProofPreview({
    this.primaryImage,
    this.secondaryImage,
    this.isBeforeAfter = false,
    super.key,
  });

  /// The main proof image file.
  final File? primaryImage;

  /// The "after" image for Before & After proof types.
  final File? secondaryImage;

  /// Whether this is a Before & After proof type.
  final bool isBeforeAfter;

  @override
  Widget build(BuildContext context) {
    if (!isBeforeAfter) {
      return _singlePreview(primaryImage);
    }

    return Row(
      children: [
        Expanded(child: _singlePreview(primaryImage, label: 'Before')),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: _singlePreview(secondaryImage, label: 'After')),
      ],
    );
  }

  Widget _singlePreview(File? file, {String? label}) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
              child: Text(label),
            ),
          Container(
            height: AppSpacing.xxl * 3,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: AppRadius.cardRadius,
              image: file != null
                  ? DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: file == null
                ? const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: AppColors.softGray,
                      size: AppSpacing.xxl,
                    ),
                  )
                : null,
          ),
        ],
      );
}
