import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/time_block.dart';

/// Content widget for selecting time constraint type.
class TimeBlockWidget extends StatefulWidget {
  /// Creates a [TimeBlockWidget].
  const TimeBlockWidget({required this.onConfigChanged, super.key});

  /// Called with a [TimeBlock] when the config changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<TimeBlockWidget> createState() => _TimeBlockWidgetState();
}

class _TimeBlockWidgetState extends State<TimeBlockWidget> {
  TimeType? _type;
  final _valueController = TextEditingController();

  static const _labels = {
    TimeType.deadline: 'Deadline',
    TimeType.duration: 'Duration',
    TimeType.timeOfDay: 'Time of Day',
    TimeType.open: 'Open',
  };

  bool get _needsInput => _type != null && _type != TimeType.open;

  @override
  void initState() {
    super.initState();
    _valueController.addListener(_emit);
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _emit() {
    if (_type == null) return;
    widget.onConfigChanged(TimeBlock(
      type: _type!,
      value: _needsInput ? _valueController.text : null,
    ),);
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: _labels.entries
                .map((e) => SQChip(
                      label: e.value,
                      color: AppColors.softGray,
                      isSelected: _type == e.key,
                      onTap: () {
                        setState(() => _type = e.key);
                        _emit();
                      },
                    ),)
                .toList(),
          ),
          if (_needsInput) ...[
            const SizedBox(height: AppSpacing.sm),
            SQInput(hint: 'Enter value', controller: _valueController),
          ],
        ],
      );
}
