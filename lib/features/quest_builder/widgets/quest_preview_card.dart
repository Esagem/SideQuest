import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_shadows.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/providers/builder_providers.dart';

/// Mini quest card preview that updates in real-time as the builder
/// state changes. Collapsible via tap.
class QuestPreviewCard extends StatefulWidget {
  /// Creates a [QuestPreviewCard].
  const QuestPreviewCard({required this.state, super.key});

  /// The current builder state to preview.
  final BuilderStateData state;

  @override
  State<QuestPreviewCard> createState() => _QuestPreviewCardState();
}

class _QuestPreviewCardState extends State<QuestPreviewCard> {
  bool _isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = widget.state.title.isEmpty ? 'Untitled Quest' : widget.state.title;

    return GestureDetector(
      onTap: () => setState(() => _isCollapsed = !_isCollapsed),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardNavy : AppColors.white,
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.cardShadow,
          border: widget.state.category.isNotEmpty
              ? Border(
                  left: BorderSide(
                    color: AppColors.categoryColor(widget.state.category),
                    width: 3,
                  ),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.preview,
                  size: AppSpacing.md,
                  color: AppColors.softGray,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  'Preview',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isCollapsed ? 0 : 0.5,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(
                    Icons.expand_more,
                    color: AppColors.softGray,
                    size: AppSpacing.lg,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _ExpandedPreview(
                title: title,
                category: widget.state.category,
                difficulty: widget.state.difficulty,
                blockCount: widget.state.blocks.length,
              ),
              crossFadeState: _isCollapsed
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 250),
              sizeCurve: Curves.easeOut,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedPreview extends StatelessWidget {
  const _ExpandedPreview({
    required this.title,
    required this.category,
    required this.difficulty,
    required this.blockCount,
  });

  final String title;
  final String category;
  final Difficulty difficulty;
  final int blockCount;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xxs,
              runSpacing: AppSpacing.xxs,
              children: [
                if (category.isNotEmpty)
                  SQChip(
                    label: category,
                    color: AppColors.categoryColor(category),
                  ),
                SQChip(
                  label: difficulty.name,
                  color: AppColors.softGray,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '$blockCount blocks',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
}
