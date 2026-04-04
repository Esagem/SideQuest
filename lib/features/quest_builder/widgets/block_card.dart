import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_shadows.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/block_meta.dart';

/// Base card wrapping every block in the build area.
///
/// Shows emoji + label, a drag handle on the left, expand/collapse
/// chevron on the right, and an optional remove button. The left
/// border is colored to match [meta.color]. Expands with a smooth
/// 250 ms height animation.
class BlockCard extends StatelessWidget {
  /// Creates a [BlockCard].
  const BlockCard({
    required this.meta,
    required this.isExpanded,
    required this.onTap,
    this.onRemove,
    this.summary,
    this.child,
    super.key,
  });

  /// Block display metadata.
  final BlockMeta meta;

  /// Whether the block is expanded to show options.
  final bool isExpanded;

  /// Called when the card header is tapped.
  final VoidCallback onTap;

  /// Called when the remove button is tapped. Null hides the button.
  final VoidCallback? onRemove;

  /// Short text summary of current config (shown when collapsed).
  final String? summary;

  /// Expanded content widget (block-specific options).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardNavy : AppColors.white,
        borderRadius: AppRadius.cardRadius,
        boxShadow: isExpanded ? AppShadows.elevatedShadow : AppShadows.cardShadow,
        border: Border(
          left: BorderSide(color: meta.color, width: 3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(
            meta: meta,
            isExpanded: isExpanded,
            onTap: onTap,
            onRemove: onRemove,
            summary: summary,
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: child != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: child,
                  )
                : const SizedBox.shrink(),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.meta,
    required this.isExpanded,
    required this.onTap,
    this.onRemove,
    this.summary,
  });

  final BlockMeta meta;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final String? summary;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.drag_handle,
                color: AppColors.softGray,
                size: AppSpacing.lg,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(meta.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meta.label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (summary != null && !isExpanded)
                      Text(
                        summary!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (onRemove != null)
                GestureDetector(
                  onTap: onRemove,
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.xxs),
                    child: Icon(
                      Icons.close,
                      color: AppColors.softGray,
                      size: AppSpacing.lg - 4,
                    ),
                  ),
                ),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: const Icon(
                  Icons.expand_more,
                  color: AppColors.softGray,
                ),
              ),
            ],
          ),
        ),
      );
}
