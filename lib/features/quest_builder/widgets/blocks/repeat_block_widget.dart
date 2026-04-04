import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/repeat_block.dart';

/// Content widget for selecting one-time or repeatable.
class RepeatBlockWidget extends StatefulWidget {
  /// Creates a [RepeatBlockWidget].
  const RepeatBlockWidget({required this.onConfigChanged, super.key});

  /// Called with a [RepeatBlock] when selection changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<RepeatBlockWidget> createState() => _RepeatBlockWidgetState();
}

class _RepeatBlockWidgetState extends State<RepeatBlockWidget> {
  RepeatType _selected = RepeatType.oneTime;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: AppSpacing.xs,
        children: [
          SQChip(
            label: 'One-time',
            color: AppColors.oceanTeal,
            isSelected: _selected == RepeatType.oneTime,
            onTap: () {
              setState(() => _selected = RepeatType.oneTime);
              widget.onConfigChanged(const RepeatBlock(type: RepeatType.oneTime));
            },
          ),
          SQChip(
            label: 'Repeatable',
            color: AppColors.oceanTeal,
            isSelected: _selected == RepeatType.repeatable,
            onTap: () {
              setState(() => _selected = RepeatType.repeatable);
              widget.onConfigChanged(const RepeatBlock(type: RepeatType.repeatable));
            },
          ),
        ],
      );
}
