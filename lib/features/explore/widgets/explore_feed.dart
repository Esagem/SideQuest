import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_quest_card.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/quest_model.dart';

/// The main feed of quest cards in the Explore screen.
///
/// Displays a vertical list of [SQQuestCard]s with an "Add" button.
class ExploreFeed extends StatelessWidget {
  /// Creates an [ExploreFeed].
  const ExploreFeed({
    required this.quests,
    required this.onTap,
    required this.onAdd,
    this.addedQuestIds = const {},
    super.key,
  });

  /// The quests to display.
  final List<QuestModel> quests;

  /// Called when a quest card is tapped.
  final void Function(String questId) onTap;

  /// Called when the add button is tapped.
  final void Function(String questId) onAdd;

  /// Quest IDs already on the user's list (shows checkmark instead).
  final Set<String> addedQuestIds;

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: quests.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, index) {
          final q = quests[index];
          final alreadyAdded = addedQuestIds.contains(q.id);

          return SQQuestCard(
            quest: SQQuestCardData(
              title: q.title,
              category: q.category,
              intents: q.intent,
              difficulty: q.difficulty.name,
              completionCount: q.completedCount,
            ),
            showAddButton: !alreadyAdded,
            onTap: () => onTap(q.id),
            onAddToList: alreadyAdded ? null : () => onAdd(q.id),
          );
        },
      );
}
