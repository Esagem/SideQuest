import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_badge_icon.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// Displays the user's top 3 badges in a horizontal row.
///
/// Tapping the row opens the full badge detail view.
class BadgeShowcase extends StatelessWidget {
  /// Creates a [BadgeShowcase].
  const BadgeShowcase({
    required this.badgeIds,
    this.onTap,
    super.key,
  });

  /// The badge IDs to display (up to 3).
  final List<String> badgeIds;

  /// Called when the showcase is tapped to view all badges.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (badgeIds.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < badgeIds.length && i < 3; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            SQBadgeIcon(badgeId: badgeIds[i], size: AppSpacing.xxl),
          ],
        ],
      ),
    );
  }
}
