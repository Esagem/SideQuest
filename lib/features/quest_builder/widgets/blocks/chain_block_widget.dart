import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/chain_block.dart';

/// Content widget for configuring quest chain/series.
class ChainBlockWidget extends StatefulWidget {
  /// Creates a [ChainBlockWidget].
  const ChainBlockWidget({required this.onConfigChanged, super.key});

  /// Called with a [ChainBlock] when the config changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<ChainBlockWidget> createState() => _ChainBlockWidgetState();
}

class _ChainBlockWidgetState extends State<ChainBlockWidget> {
  final _questIdController = TextEditingController();
  final _indexController = TextEditingController();
  final _totalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (final c in [_questIdController, _indexController, _totalController]) {
      c.addListener(_emit);
    }
  }

  @override
  void dispose() {
    _questIdController.dispose();
    _indexController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _emit() {
    widget.onConfigChanged(ChainBlock(
      prerequisiteQuestId: _questIdController.text.isEmpty
          ? null
          : _questIdController.text,
      seriesIndex: int.tryParse(_indexController.text),
      seriesTotal: int.tryParse(_totalController.text),
    ),);
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SQInput(
            label: 'Prerequisite Quest ID',
            hint: 'Quest that must be completed first',
            controller: _questIdController,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: SQInput(
                  label: 'Series #',
                  hint: '1',
                  controller: _indexController,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SQInput(
                  label: 'of Total',
                  hint: '5',
                  controller: _totalController,
                ),
              ),
            ],
          ),
        ],
      );
}
