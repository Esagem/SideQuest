import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/components/sq_empty_state.dart';
import 'package:sidequest/core/components/sq_loading.dart';
import 'package:sidequest/core/constants/categories.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/leaderboard/widgets/leaderboard_list.dart';
import 'package:sidequest/features/leaderboard/widgets/leaderboard_tab_bar.dart';
import 'package:sidequest/models/leaderboard_entry_model.dart';
import 'package:sidequest/providers/auth_providers.dart';

/// Provider for fetching leaderboard data by type.
///
/// In production this would call [LeaderboardRepository]. For now it
/// returns an empty list as placeholder.
final leaderboardProvider =
    FutureProvider.family<List<LeaderboardEntryModel>, String>(
  (ref, type) async => <LeaderboardEntryModel>[],
);

/// The leaderboard screen with Weekly, Friends, Category, and Global tabs.
///
/// Weekly is the default tab (shown first) to drive re-engagement.
class LeaderboardScreen extends ConsumerStatefulWidget {
  /// Creates a [LeaderboardScreen].
  const LeaderboardScreen({this.initialTab = 0, super.key});

  /// The initial tab index (0 = Weekly).
  final int initialTab;

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String? _categoryFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authStateProvider).valueOrNull?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        bottom: LeaderboardTabBar(controller: _tabController),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Weekly
          _LeaderboardTab(type: 'weekly', currentUserId: userId),
          // Friends
          _FriendsTab(currentUserId: userId),
          // Category
          _CategoryTab(
            categoryFilter: _categoryFilter,
            onCategoryChanged: (c) => setState(() => _categoryFilter = c),
            currentUserId: userId,
          ),
          // Global
          _LeaderboardTab(type: 'global', currentUserId: userId),
        ],
      ),
    );
  }
}

class _LeaderboardTab extends ConsumerWidget {
  const _LeaderboardTab({required this.type, this.currentUserId});

  final String type;
  final String? currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEntries = ref.watch(leaderboardProvider(type));

    return asyncEntries.when(
      data: (entries) => LeaderboardList(
        entries: entries,
        currentUserId: currentUserId,
      ),
      loading: () => const SQLoading(),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _FriendsTab extends ConsumerWidget {
  const _FriendsTab({this.currentUserId});

  final String? currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEntries = ref.watch(leaderboardProvider('friends'));

    return asyncEntries.when(
      data: (entries) {
        if (entries.length < 3) {
          return const SQEmptyState(
            title: 'Not enough friends',
            message: 'Add more friends to see your ranking!',
            icon: Icons.people_outline,
          );
        }
        return LeaderboardList(
          entries: entries,
          currentUserId: currentUserId,
        );
      },
      loading: () => const SQLoading(),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _CategoryTab extends ConsumerWidget {
  const _CategoryTab({
    required this.categoryFilter,
    required this.onCategoryChanged,
    this.currentUserId,
  });

  final String? categoryFilter;
  final ValueChanged<String?> onCategoryChanged;
  final String? currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = categoryFilter != null
        ? 'category_$categoryFilter'
        : 'category';
    final asyncEntries = ref.watch(leaderboardProvider(type));

    return Column(
      children: [
        // Category chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: Category.values.map(
              (c) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: SQChip(
                  label: c.displayName,
                  color: c.color,
                  isSelected: categoryFilter == c.name,
                  onTap: () => onCategoryChanged(
                    categoryFilter == c.name ? null : c.name,
                  ),
                ),
              ),
            ).toList(),
          ),
        ),
        // List
        Expanded(
          child: asyncEntries.when(
            data: (entries) => LeaderboardList(
              entries: entries,
              currentUserId: currentUserId,
            ),
            loading: () => const SQLoading(),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}
