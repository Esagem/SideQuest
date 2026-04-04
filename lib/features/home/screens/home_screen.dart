import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/components/sq_loading.dart';
import 'package:sidequest/core/constants/categories.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/home/widgets/home_empty_state.dart';
import 'package:sidequest/features/home/widgets/quest_list.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/models/user_quest_model.dart';
import 'package:sidequest/providers/quest_providers.dart';
import 'package:sidequest/providers/user_quest_providers.dart';

/// The home screen displaying the user's personal quest list.
///
/// Shows active quests in a reorderable list with filter chips,
/// pull-to-refresh, swipe actions, and an empty state.
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _filter = 'all';
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final activeAsync = ref.watch(activeQuestsProvider);
    final completedAsync = ref.watch(completedQuestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/builder'),
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            selectedFilter: _filter,
            showCompleted: _showCompleted,
            onFilterChanged: (f) => setState(() => _filter = f),
            onCompletedToggled: () =>
                setState(() => _showCompleted = !_showCompleted),
          ),
          Expanded(
            child: _showCompleted
                ? _buildQuestList(completedAsync)
                : _buildQuestList(activeAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestList(AsyncValue<List<UserQuestModel>> asyncQuests) =>
      asyncQuests.when(
        data: (quests) {
          final filtered = _applyFilter(quests);
          if (filtered.isEmpty) return const HomeEmptyState();

          return RefreshIndicator(
            onRefresh: () async {
              ref
                ..invalidate(activeQuestsProvider)
                ..invalidate(completedQuestsProvider);
            },
            child: QuestList(
              userQuests: filtered,
              questLookup: _lookupQuest,
              onReorder: _onReorder,
              onTap: (questId) => context.push('/quest/$questId'),
              onSwipeComplete: _onSwipeComplete,
              onSwipeRemove: _onSwipeRemove,
            ),
          );
        },
        loading: () => const SQLoading(),
        error: (e, _) => Center(child: Text('Error: $e')),
      );

  List<UserQuestModel> _applyFilter(List<UserQuestModel> quests) {
    if (_filter == 'all') return quests;
    // Filter by category — requires quest lookup
    return quests.where((uq) {
      final quest = _lookupQuest(uq.questId);
      return quest?.category == _filter;
    }).toList();
  }

  QuestModel? _lookupQuest(String questId) =>
      ref.read(questByIdProvider(questId)).valueOrNull;

  void _onReorder(int oldIndex, int newIndex) {
    // TODO(home): Persist reorder via UserQuestRepository
  }

  void _onSwipeComplete(UserQuestModel uq) {
    context.push('/proof/${uq.id}');
  }

  void _onSwipeRemove(UserQuestModel uq) {
    // TODO(home): Remove via QuestService.removeQuestFromList
  }
}

/// Filter chips bar at the top of the home screen.
class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.selectedFilter,
    required this.showCompleted,
    required this.onFilterChanged,
    required this.onCompletedToggled,
  });

  final String selectedFilter;
  final bool showCompleted;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onCompletedToggled;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            // Status toggle
            SQChip(
              label: showCompleted ? 'Completed' : 'Active',
              color: AppColors.navy,
              isSelected: true,
              onTap: onCompletedToggled,
            ),
            const SizedBox(width: AppSpacing.xs),
            // All filter
            SQChip(
              label: 'All',
              color: AppColors.softGray,
              isSelected: selectedFilter == 'all',
              onTap: () => onFilterChanged('all'),
            ),
            const SizedBox(width: AppSpacing.xs),
            // Category filters
            ...Category.values.map(
              (c) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: SQChip(
                  label: c.displayName,
                  color: c.color,
                  isSelected: selectedFilter == c.name,
                  onTap: () => onFilterChanged(c.name),
                ),
              ),
            ),
          ],
        ),
      );
}
