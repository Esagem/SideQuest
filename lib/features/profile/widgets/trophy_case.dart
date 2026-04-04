import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A grid of completed quest proof thumbnails.
///
/// Tapping a thumbnail can navigate to the full proof view.
class TrophyCase extends StatelessWidget {
  /// Creates a [TrophyCase].
  const TrophyCase({
    required this.proofUrls,
    this.onTap,
    super.key,
  });

  /// The proof image URLs to display.
  final List<String> proofUrls;

  /// Called with the proof URL when a thumbnail is tapped.
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    if (proofUrls.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Trophy Case', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.xxs,
            mainAxisSpacing: AppSpacing.xxs,
          ),
          itemCount: proofUrls.length,
          itemBuilder: (_, index) => GestureDetector(
            onTap: () => onTap?.call(proofUrls[index]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.xs),
              child: Image.network(
                proofUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: AppColors.lightGray,
                  child: Icon(Icons.image_outlined, color: AppColors.softGray),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
