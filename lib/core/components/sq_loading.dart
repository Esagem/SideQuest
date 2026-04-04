import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// Loading indicators for the SideQuest design system.
///
/// Provides a full-screen centered spinner via the default constructor
/// and a skeleton shimmer variant via [SQLoading.skeleton] for list
/// loading states.
class SQLoading extends StatelessWidget {
  /// Creates a full-screen centered loading spinner.
  const SQLoading({super.key}) : _variant = _LoadingVariant.spinner;

  /// Creates a skeleton shimmer placeholder for list loading.
  const SQLoading.skeleton({super.key}) : _variant = _LoadingVariant.skeleton;

  final _LoadingVariant _variant;

  @override
  Widget build(BuildContext context) => switch (_variant) {
        _LoadingVariant.spinner => const _Spinner(),
        _LoadingVariant.skeleton => const _Skeleton(),
      };
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: CircularProgressIndicator(
        color: isDark ? AppColors.sunsetOrangeDark : AppColors.sunsetOrange,
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.slate : AppColors.lightGray;
    final highlightColor = isDark ? AppColors.cardNavy : AppColors.offWhite;

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, __) => _SkeletonCard(
        baseColor: baseColor,
        highlightColor: highlightColor,
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({
    required this.baseColor,
    required this.highlightColor,
  });

  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) => Container(
        height: AppSpacing.xxl * 2,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: AppSpacing.md,
                width: AppSpacing.xxl * 4,
                decoration: BoxDecoration(
                  color: highlightColor,
                  borderRadius: BorderRadius.circular(AppSpacing.xxs),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                height: AppSpacing.sm,
                width: AppSpacing.xxl * 3,
                decoration: BoxDecoration(
                  color: highlightColor,
                  borderRadius: BorderRadius.circular(AppSpacing.xxs),
                ),
              ),
            ],
          ),
        ),
      );
}

enum _LoadingVariant { spinner, skeleton }
