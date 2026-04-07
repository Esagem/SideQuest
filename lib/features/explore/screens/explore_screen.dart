import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_loading.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/explore/widgets/category_filter_bar.dart';
import 'package:sidequest/features/explore/widgets/explore_feed.dart';
import 'package:sidequest/features/explore/widgets/intent_filter_bar.dart';
import 'package:sidequest/features/explore/widgets/quest_search_bar.dart';
import 'package:sidequest/features/explore/widgets/trending_section.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/providers/auth_providers.dart';
import 'package:sidequest/providers/quest_providers.dart';
import 'package:sidequest/providers/user_quest_providers.dart';

/// The Explore screen with search, filters, trending, and quest feed.
///
/// Blends trending, new, and personalized quests into a single feed.
/// Supports category (single-select) and intent (multi-select) filtering,
/// and debounced prefix search.
class ExploreScreen extends ConsumerStatefulWidget {
  /// Creates an [ExploreScreen].
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String? _categoryFilter;
  final _intentFilters = <String>{};
  String? _searchQuery;

  void _onSearch(String query) => setState(() => _searchQuery = query);
  void _onClearSearch() => setState(() => _searchQuery = null);

  void _onCategoryChanged(String? category) =>
      setState(() => _categoryFilter = category);

  void _onIntentToggled(String intent) {
    setState(() {
      if (_intentFilters.contains(intent)) {
        _intentFilters.remove(intent);
      } else {
        _intentFilters.add(intent);
      }
    });
  }

  List<QuestModel> _applyFilters(List<QuestModel> quests) {
    var filtered = quests;

    if (_categoryFilter != null) {
      filtered = filtered.where((q) => q.category == _categoryFilter).toList();
    }

    if (_intentFilters.isNotEmpty) {
      filtered = filtered
          .where((q) => q.intent.any(_intentFilters.contains))
          .toList();
    }

    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      final query = _searchQuery!.toLowerCase();
      filtered = filtered
          .where((q) => q.title.toLowerCase().startsWith(query))
          .toList();
    }

    return filtered;
  }

  Future<void> _onAddToList(String questId) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    final activeQuests =
        ref.read(activeQuestsProvider).valueOrNull ?? [];
    try {
      await ref.read(questServiceProvider).addQuestToList(
            userId: user.uid,
            questId: questId,
            currentSortOrder: activeQuests.length,
          );
      if (mounted) {
        SQToast.success(context, 'Added to your quest list!');
      }
    } on Exception catch (e) {
      if (mounted) {
        SQToast.error(context, 'Failed to add quest: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final questsAsync = ref.watch(publicQuestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: QuestSearchBar(
              onSearch: _onSearch,
              onClear: _onClearSearch,
            ),
          ),
          // Category filters
          CategoryFilterBar(
            selected: _categoryFilter,
            onSelected: _onCategoryChanged,
          ),
          const SizedBox(height: AppSpacing.xxs),
          // Intent filters
          IntentFilterBar(
            selected: _intentFilters,
            onToggled: _onIntentToggled,
          ),
          const SizedBox(height: AppSpacing.xs),
          // Content
          Expanded(
            child: questsAsync.when(
              data: (quests) {
                final filtered = _applyFilters(quests);
                final trending = quests.take(5).toList();

                return CustomScrollView(
                  slivers: [
                    // Trending section (only when no search)
                    if (_searchQuery == null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.md,
                          ),
                          child: TrendingSection(
                            quests: trending,
                            onTap: (id) => context.push('/quest/$id'),
                            onAdd: _onAddToList,
                          ),
                        ),
                      ),
                    // Feed
                    SliverFillRemaining(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                _searchQuery != null
                                    ? 'No quests match "$_searchQuery"'
                                    : 'No quests found',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            )
                          : ExploreFeed(
                              quests: filtered,
                              onTap: (id) => context.push('/quest/$id'),
                              onAdd: _onAddToList,
                            ),
                    ),
                  ],
                );
              },
              loading: () => const SQLoading(),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
