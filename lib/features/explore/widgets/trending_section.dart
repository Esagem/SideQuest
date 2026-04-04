import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_quest_card.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/quest_model.dart';

/// A horizontal scrollable row of trending quest cards.
///
/// Shows the top 5 most-added public quests.
class TrendingSection extends StatelessWidget {
  /// Creates a [TrendingSection].
  const TrendingSection({
    required this.quests,
    required this.onTap,
    required this.onAdd,
    super.key,
  });

  /// The trending quests to display.
  final List<QuestModel> quests;

  /// Called when a quest card is tapped.
  final void Function(String questId) onTap;

  /// Called when the add button on a card is tapped.
  final void Function(String questId) onAdd;

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'Trending',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: AppSpacing.xxl * 3.5,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: quests.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, index) {
              final q = quests[index];
              return SizedBox(
                width: AppSpacing.xxl * 5,
                child: SQQuestCard(
                  quest: SQQuestCardData(
                    title: q.title,
                    category: q.category,
                    intents: q.intent,
                    difficulty: q.difficulty.name,
                    completionCount: q.completedCount,
                  ),
                  showAddButton: true,
                  onTap: () => onTap(q.id),
                  onAddToList: () => onAdd(q.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
