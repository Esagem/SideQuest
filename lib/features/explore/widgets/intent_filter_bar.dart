import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/constants/intents.dart' as intents;
import 'package:sidequest/core/theme/app_spacing.dart';

/// Horizontal scrollable intent filter chips.
///
/// Multi-select: tap to toggle.
class IntentFilterBar extends StatelessWidget {
  /// Creates an [IntentFilterBar].
  const IntentFilterBar({
    required this.selected,
    required this.onToggled,
    super.key,
  });

  /// The set of currently selected intent keys.
  final Set<String> selected;

  /// Called when an intent is toggled.
  final ValueChanged<String> onToggled;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: intents.Intent.values
              .map(
                (i) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: SQChip(
                    label: '${i.emoji} ${i.displayName}',
                    color: i.color,
                    isSelected: selected.contains(i.name),
                    onTap: () => onToggled(i.name),
                  ),
                ),
              )
              .toList(),
        ),
      );
}
