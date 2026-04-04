import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/constants/difficulties.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/services/xp_service.dart';

/// Content widget for selecting quest difficulty with XP preview.
class DifficultyBlockWidget extends StatefulWidget {
  /// Creates a [DifficultyBlockWidget].
  const DifficultyBlockWidget({required this.onConfigChanged, super.key});

  /// Called with a [Difficulty] when selection changes.
  final ValueChanged<Difficulty> onConfigChanged;

  @override
  State<DifficultyBlockWidget> createState() => _DifficultyBlockWidgetState();
}

class _DifficultyBlockWidgetState extends State<DifficultyBlockWidget> {
  Difficulty _selected = Difficulty.easy;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: DifficultyLevel.values
                .map((d) {
                  final difficulty = Difficulty.values.byName(d.name);
                  return SQChip(
                    label: '${d.label} (${d.multiplier}x)',
                    color: d.color,
                    isSelected: _selected == difficulty,
                    onTap: () {
                      setState(() => _selected = difficulty);
                      widget.onConfigChanged(difficulty);
                    },
                  );
                })
                .toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Base XP: ${(XpService.baseXp * XpService.difficultyMultipliers[_selected]!).round()}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
}
