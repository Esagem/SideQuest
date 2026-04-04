import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sidequest/core/components/sq_loading.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/activity/widgets/activity_feed.dart';
import 'package:sidequest/models/activity_model.dart';

/// Provider placeholder for the activity feed.
///
/// In production this would stream from [ActivityRepository].
final activityFeedProvider = StreamProvider<List<ActivityModel>>(
  (ref) => Stream.value(<ActivityModel>[]),
);

/// The activity feed screen showing friend completions and social events.
///
/// Supports pull-to-refresh, infinite scroll, and feed settings.
class ActivityScreen extends ConsumerStatefulWidget {
  /// Creates an [ActivityScreen].
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  bool _friendsOnly = true;

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(activityFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'filter') {
                setState(() => _friendsOnly = !_friendsOnly);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'filter',
                child: Text(
                  _friendsOnly ? 'Show Friends + Public' : 'Friends Only',
                ),
              ),
            ],
          ),
        ],
      ),
      body: feedAsync.when(
        data: (activities) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(activityFeedProvider),
          child: activities.isEmpty
              ? _EmptyActivity()
              : ActivityFeed(
                  activities: activities,
                  onReact: _handleReaction,
                ),
        ),
        loading: () => const SQLoading(),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _handleReaction(String activityId, String? emoji) {
    // TODO(activity): Persist reaction via repository
  }
}

class _EmptyActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
        children: [
          const SizedBox(height: AppSpacing.xxl * 3),
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.notifications_none,
                  size: AppSpacing.xxl * 2,
                  color: AppColors.softGray,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No activity yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Complete a quest or add friends to see their activity.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
}
