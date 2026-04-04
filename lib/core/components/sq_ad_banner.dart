import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A placeholder banner ad widget.
///
/// In production this would wrap a Google Mobile Ads BannerAdWidget.
/// Hidden when [isPro] is true.
class SQAdBanner extends StatelessWidget {
  /// Creates an [SQAdBanner].
  const SQAdBanner({this.isPro = false, super.key});

  /// Whether the user is a Pro subscriber (hides the ad).
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    if (isPro) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: AppSpacing.xxl + AppSpacing.xs,
      color: AppColors.offWhite,
      alignment: Alignment.center,
      child: Text(
        'Ad Placeholder',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.softGray,
            ),
      ),
    );
  }
}
