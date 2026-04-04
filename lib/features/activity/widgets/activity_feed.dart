import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/activity/widgets/activity_card.dart';
import 'package:sidequest/models/activity_model.dart';

/// A scrollable feed of [ActivityCard] widgets.
class ActivityFeed extends StatelessWidget {
  /// Creates an [ActivityFeed].
  const ActivityFeed({
    required this.activities,
    this.onReact,
    super.key,
  });

  /// The activities to display.
  final List<ActivityModel> activities;

  /// Called when a reaction is tapped on any card.
  final void Function(String activityId, String? emoji)? onReact;

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Center(
        child: Text(
          'No activity yet. Complete a quest to get started!',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: activities.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, index) {
        final activity = activities[index];
        // Show spot check on ~10% of quest completions
        final showSpot = activity.type == ActivityType.questCompleted &&
            index.hashCode % 10 == 0;

        return ActivityCard(
          activity: activity,
          displayName: activity.userId,
          showSpotCheck: showSpot,
          onReact: onReact != null
              ? (emoji) => onReact!(activity.id, emoji)
              : null,
          onSpotCheckLegit: () {},
          onSpotCheckHmm: () {},
        );
      },
    );
  }
}
