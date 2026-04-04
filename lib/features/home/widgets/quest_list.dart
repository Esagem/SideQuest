import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/home/widgets/quest_card_home.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/models/user_quest_model.dart';

/// A reorderable list of quest cards for the home screen.
///
/// Supports drag-to-reorder with sort order persistence, and
/// swipe-to-dismiss (right = complete, left = remove).
class QuestList extends StatelessWidget {
  /// Creates a [QuestList].
  const QuestList({
    required this.userQuests,
    required this.questLookup,
    required this.onReorder,
    required this.onTap,
    required this.onSwipeComplete,
    required this.onSwipeRemove,
    super.key,
  });

  /// The user's quests in display order.
  final List<UserQuestModel> userQuests;

  /// Lookup function to get a [QuestModel] by quest ID.
  final QuestModel? Function(String questId) questLookup;

  /// Called when quests are reordered.
  final void Function(int oldIndex, int newIndex) onReorder;

  /// Called when a quest card is tapped.
  final void Function(String questId) onTap;

  /// Called when a quest is swiped right to complete.
  final void Function(UserQuestModel userQuest) onSwipeComplete;

  /// Called when a quest is swiped left to remove.
  final void Function(UserQuestModel userQuest) onSwipeRemove;

  @override
  Widget build(BuildContext context) => ReorderableListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: userQuests.length,
        onReorder: onReorder,
        itemBuilder: (context, index) {
          final uq = userQuests[index];
          final quest = questLookup(uq.questId);
          if (quest == null) return SizedBox(key: ValueKey(uq.id));

          return Dismissible(
            key: ValueKey(uq.id),
            background: const _SwipeBackground(
              color: AppColors.oceanTeal,
              icon: Icons.check_circle,
              alignment: Alignment.centerLeft,
            ),
            secondaryBackground: const _SwipeBackground(
              color: AppColors.emberRed,
              icon: Icons.delete_outline,
              alignment: Alignment.centerRight,
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                onSwipeComplete(uq);
                return false; // Don't actually dismiss — navigate to proof
              }
              return _confirmRemove(context);
            },
            onDismissed: (_) => onSwipeRemove(uq),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: QuestCardHome(
                quest: quest,
                userQuest: uq,
                onTap: () => onTap(uq.questId),
              ),
            ),
          );
        },
      );

  Future<bool> _confirmRemove(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Quest'),
        content: const Text(
          'Remove this quest from your list? You can always add it back later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.color,
    required this.icon,
    required this.alignment,
  });

  final Color color;
  final IconData icon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Icon(icon, color: AppColors.white, size: AppSpacing.xl),
      );
}
