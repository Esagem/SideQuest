import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_card.dart';
import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/block_config.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/models/user_quest_model.dart';

/// A quest card for the home screen showing quest details and progress.
///
/// Displays title, category chip, intent chips, difficulty badge,
/// block summary icons, and stage progress if applicable.
class QuestCardHome extends StatelessWidget {
  /// Creates a [QuestCardHome].
  const QuestCardHome({
    required this.quest,
    required this.userQuest,
    this.onTap,
    super.key,
  });

  /// The quest definition data.
  final QuestModel quest;

  /// The user's personal quest data (status, progress).
  final UserQuestModel userQuest;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SQCard(
        categoryAccent: quest.category,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quest.title,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            // Chips row
            Wrap(
              spacing: AppSpacing.xxs,
              runSpacing: AppSpacing.xxs,
              children: [
                SQChip(
                  label: quest.category,
                  color: AppColors.categoryColor(quest.category),
                ),
                ...quest.intent.map(
                  (i) => SQChip(
                    label: i,
                    color: AppColors.intentColor(i),
                  ),
                ),
                SQChip(
                  label: quest.difficulty.name,
                  color: AppColors.softGray,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            // Block summary icons
            _BlockSummaryIcons(blocks: quest.blocks),
            // Stage progress
            if (quest.blocks.stages != null &&
                userQuest.stageProgress.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              _StageProgressBar(
                total: quest.blocks.stages!.items.length,
                completed: userQuest.stageProgress
                    .where((s) => s.status == StageStatus.completed)
                    .length,
              ),
            ],
          ],
        ),
      );
}

/// Row of small emoji icons summarizing which blocks are present.
class _BlockSummaryIcons extends StatelessWidget {
  const _BlockSummaryIcons({required this.blocks});

  final QuestBlocks blocks;

  @override
  Widget build(BuildContext context) {
    final icons = <String>[];
    if (blocks.location != null) icons.add('📍');
    if (blocks.people != null) icons.add('👥');
    if (blocks.time != null) icons.add('⏱️');
    if (blocks.stages != null) icons.add('🪜');
    if (blocks.wildcard != null) icons.add('🎲');
    if (blocks.prompt != null) icons.add('💬');
    if (blocks.bonus != null) icons.add('🏅');
    if (blocks.constraint != null) icons.add('🚫');
    if (icons.isEmpty) return const SizedBox.shrink();

    return Row(
      children: icons
          .map((e) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xxs),
                child: Text(e, style: const TextStyle(fontSize: 14)),
              ),)
          .toList(),
    );
  }
}

/// A simple linear progress bar for multi-stage quests.
class _StageProgressBar extends StatelessWidget {
  const _StageProgressBar({
    required this.total,
    required this.completed,
  });

  final int total;
  final int completed;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xxs),
            child: LinearProgressIndicator(
              value: total > 0 ? completed / total : 0,
              minHeight: AppSpacing.xxs,
              backgroundColor: AppColors.lightGray,
              color: AppColors.oceanTeal,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '$completed / $total stages',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      );
}
