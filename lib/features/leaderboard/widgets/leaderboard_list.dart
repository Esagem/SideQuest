import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/leaderboard/widgets/leaderboard_entry.dart';
import 'package:sidequest/models/leaderboard_entry_model.dart';

/// A scrollable list of [LeaderboardEntry] widgets.
class LeaderboardList extends StatelessWidget {
  /// Creates a [LeaderboardList].
  const LeaderboardList({
    required this.entries,
    this.currentUserId,
    super.key,
  });

  /// The leaderboard entries to display.
  final List<LeaderboardEntryModel> entries;

  /// The current user's ID, used to highlight their entry.
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No rankings yet.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, index) => LeaderboardEntry(
        entry: entries[index],
        isCurrentUser: entries[index].userId == currentUserId,
      ),
    );
  }
}
