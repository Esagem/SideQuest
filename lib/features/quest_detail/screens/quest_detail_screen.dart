import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_avatar.dart';
import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/components/sq_loading.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/quest_detail/widgets/block_summary.dart';
import 'package:sidequest/features/quest_detail/widgets/quality_signal_bar.dart';
import 'package:sidequest/features/quest_detail/widgets/stage_progress_tracker.dart';
import 'package:sidequest/providers/quest_providers.dart';

/// Full quest detail screen with block breakdown, actions, and stats.
///
/// Accepts a [questId] path parameter and watches the quest in real-time.
class QuestDetailScreen extends ConsumerWidget {
  /// Creates a [QuestDetailScreen].
  const QuestDetailScreen({required this.questId, super.key});

  /// The quest document ID.
  final String questId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questAsync = ref.watch(questByIdProvider(questId));

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                context.push('/report/quest/$questId');
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'report', child: Text('Report Quest')),
            ],
          ),
        ],
      ),
      body: questAsync.when(
        data: (quest) {
          if (quest == null) {
            return const Center(child: Text('Quest not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero section
                Text(
                  quest.title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                if (quest.description.isNotEmpty) ...[
                  Text(
                    quest.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Creator info
                Row(
                  children: [
                    SQAvatar(
                      displayName: quest.creatorId == 'deleted'
                          ? 'SQ'
                          : quest.creatorId,
                      size: AppSpacing.xl,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      quest.creatorId == 'deleted'
                          ? 'SideQuest Community'
                          : 'Creator',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Chips
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
                const SizedBox(height: AppSpacing.lg),

                // Stats
                _StatsRow(
                  addedCount: quest.addedCount,
                  completedCount: quest.completedCount,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Block breakdown
                BlockSummary(blocks: quest.blocks),
                const SizedBox(height: AppSpacing.lg),

                // Stage tracker (if staged)
                if (quest.blocks.stages != null)
                  StageProgressTracker(
                    stages: quest.blocks.stages!.items,
                    progress: const [], // TODO(detail): Wire user's progress
                  ),

                const SizedBox(height: AppSpacing.lg),

                // Quality signals (shown if user completed)
                // TODO(detail): Check if user has completed, show signals
                QualitySignalBar(
                  worthItCount: quest.worthItCount,
                  needsWorkCount: quest.needsWorkCount,
                  onWorthIt: () =>
                      SQToast.success(context, 'Marked as Worth It!'),
                  onNeedsWork: () =>
                      SQToast.success(context, 'Feedback submitted.'),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Action buttons
                SQButton.primary(
                  label: 'Add to My List',
                  icon: Icons.add,
                  onPressed: () =>
                      SQToast.success(context, 'Added to your list!'),
                ),
                const SizedBox(height: AppSpacing.sm),
                SQButton.secondary(
                  label: 'Challenge a Friend',
                  icon: Icons.bolt,
                  onPressed: () =>
                      context.push('/challenge/$questId'),
                ),
                const SizedBox(height: AppSpacing.sm),
                SQButton.tertiary(
                  label: 'Share',
                  icon: Icons.share,
                  onPressed: () =>
                      SQToast.success(context, 'Share sheet coming soon.'),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
        loading: () => const SQLoading(),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.addedCount,
    required this.completedCount,
  });

  final int addedCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          _StatItem(
            icon: Icons.bookmark_outline,
            label: '$addedCount added',
          ),
          const SizedBox(width: AppSpacing.lg),
          _StatItem(
            icon: Icons.check_circle_outline,
            label: '$completedCount completed',
          ),
        ],
      );
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.lg, color: AppColors.softGray),
          const SizedBox(width: AppSpacing.xxs),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}
