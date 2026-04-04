import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A horizontal row of emoji reactions for an activity card.
///
/// Shows preset emojis with tap-to-react behavior. Displays reaction
/// counts when > 0. Single reaction per user per activity.
class ReactionBar extends StatelessWidget {
  /// Creates a [ReactionBar].
  const ReactionBar({
    required this.reactions,
    required this.userReaction,
    required this.onReact,
    super.key,
  });

  /// Map of emoji to reaction count.
  final Map<String, int> reactions;

  /// The current user's reaction emoji, or null if none.
  final String? userReaction;

  /// Called with the emoji when tapped (null to remove).
  final ValueChanged<String?> onReact;

  /// The preset emoji options.
  static const presets = ['🔥', '💪', '🎉', '👏', '😮', '❤️'];

  @override
  Widget build(BuildContext context) => Row(
        children: presets.map((emoji) {
          final count = reactions[emoji] ?? 0;
          final isSelected = userReaction == emoji;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: GestureDetector(
              onTap: () => onReact(isSelected ? null : emoji),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.sunsetOrange.withAlpha(38)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.sunsetOrange
                        : AppColors.lightGray,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 16)),
                    if (count > 0) ...[
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        '$count',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
}
