import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A grid gallery of quest completion proof thumbnails.
///
/// Displays proof photos in a grid layout. Tapping a thumbnail
/// calls [onTap] with the proof URL.
class ProofGallery extends StatelessWidget {
  /// Creates a [ProofGallery].
  const ProofGallery({
    required this.proofUrls,
    this.onTap,
    super.key,
  });

  /// List of proof image URLs to display.
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
        Text('Proof Gallery', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.xs,
            mainAxisSpacing: AppSpacing.xs,
          ),
          itemCount: proofUrls.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => onTap?.call(proofUrls[index]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.xs),
              child: Image.network(
                proofUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: AppColors.lightGray,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.softGray,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
