import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/bonus_block.dart';

/// Content widget for configuring a bonus XP condition.
class BonusBlockWidget extends StatefulWidget {
  /// Creates a [BonusBlockWidget].
  const BonusBlockWidget({required this.onConfigChanged, super.key});

  /// Called with a [BonusBlock] when the config changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<BonusBlockWidget> createState() => _BonusBlockWidgetState();
}

class _BonusBlockWidgetState extends State<BonusBlockWidget> {
  final _conditionController = TextEditingController();
  final _xpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _conditionController.addListener(_emit);
    _xpController.addListener(_emit);
  }

  @override
  void dispose() {
    _conditionController.dispose();
    _xpController.dispose();
    super.dispose();
  }

  void _emit() {
    widget.onConfigChanged(BonusBlock(
      condition: _conditionController.text,
      xpBonus: int.tryParse(_xpController.text) ?? 0,
    ),);
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SQInput(
            label: 'Bonus Condition',
            hint: 'e.g., Complete in under 5 minutes',
            controller: _conditionController,
          ),
          const SizedBox(height: AppSpacing.sm),
          SQInput(
            label: 'Bonus XP',
            hint: '50',
            controller: _xpController,
          ),
        ],
      );
}
