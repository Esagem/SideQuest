import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/people_block.dart';

/// Content widget for selecting people type and group count.
class PeopleBlockWidget extends StatefulWidget {
  /// Creates a [PeopleBlockWidget].
  const PeopleBlockWidget({required this.onConfigChanged, super.key});

  /// Called with a [PeopleBlock] when the config changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<PeopleBlockWidget> createState() => _PeopleBlockWidgetState();
}

class _PeopleBlockWidgetState extends State<PeopleBlockWidget> {
  PeopleType? _type;
  final _countController = TextEditingController();

  static const _labels = {
    PeopleType.solo: 'Solo',
    PeopleType.withFriend: 'With 1 Friend',
    PeopleType.group: 'Group',
    PeopleType.stranger: 'Stranger',
  };

  @override
  void initState() {
    super.initState();
    _countController.addListener(_emit);
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  void _emit() {
    if (_type == null) return;
    widget.onConfigChanged(PeopleBlock(
      type: _type!,
      minCount: _type == PeopleType.group
          ? int.tryParse(_countController.text)
          : null,
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
                      color: AppColors.warmYellow,
                      isSelected: _type == e.key,
                      onTap: () {
                        setState(() => _type = e.key);
                        _emit();
                      },
                    ),)
                .toList(),
          ),
          if (_type == PeopleType.group) ...[
            const SizedBox(height: AppSpacing.sm),
            SQInput(hint: 'Min people', controller: _countController),
          ],
        ],
      );
}
