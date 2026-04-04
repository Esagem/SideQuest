import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A user avatar that shows a network image or initials fallback.
///
/// Optionally displays a tier badge overlay at the bottom-right corner.
class SQAvatar extends StatelessWidget {
  /// Creates an [SQAvatar].
  const SQAvatar({
    required this.displayName,
    this.imageUrl,
    this.size = 40,
    this.tierBadge,
    super.key,
  });

  /// URL of the user's profile image. Shows initials when null.
  final String? imageUrl;

  /// The user's display name, used to derive initials.
  final String displayName;

  /// Diameter of the avatar in logical pixels.
  final double size;

  /// Optional tier badge key to overlay at the bottom-right.
  final String? tierBadge;

  String get _initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final avatar = imageUrl != null
        ? CircleAvatar(
            radius: size / 2,
            backgroundImage: NetworkImage(imageUrl!),
            backgroundColor: AppColors.lightGray,
          )
        : CircleAvatar(
            radius: size / 2,
            backgroundColor: AppColors.navy,
            child: Text(
              _initials,
              style: TextStyle(
                color: AppColors.white,
                fontSize: size * 0.36,
                fontWeight: FontWeight.w600,
              ),
            ),
          );

    if (tierBadge == null) return avatar;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.35,
              height: size * 0.35,
              decoration: BoxDecoration(
                color: AppColors.warmYellow,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: AppSpacing.xxs / 2,
                ),
              ),
              child: Icon(
                Icons.star_rounded,
                size: size * 0.2,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
