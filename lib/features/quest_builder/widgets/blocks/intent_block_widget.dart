import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/constants/intents.dart' as intents;
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/intent_block.dart';

/// Content widget for selecting intent tags (multi-select, max 2).
class IntentBlockWidget extends StatefulWidget {
  /// Creates an [IntentBlockWidget].
  const IntentBlockWidget({required this.onConfigChanged, super.key});

  /// Called with an [IntentBlock] when selection changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<IntentBlockWidget> createState() => _IntentBlockWidgetState();
}

class _IntentBlockWidgetState extends State<IntentBlockWidget> {
  final _selected = <String>{};

  void _toggle(intents.Intent intent) {
    setState(() {
      if (_selected.contains(intent.name)) {
        _selected.remove(intent.name);
      } else if (_selected.length < 2) {
        _selected.add(intent.name);
      }
    });
    widget.onConfigChanged(IntentBlock(intents: _selected.toList()));
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select up to 2 intents',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.softGray,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: intents.Intent.values
                .map((i) => SQChip(
                      label: '${i.emoji} ${i.displayName}',
                      color: i.color,
                      isSelected: _selected.contains(i.name),
                      onTap: () => _toggle(i),
                    ),)
                .toList(),
          ),
        ],
      );
}
