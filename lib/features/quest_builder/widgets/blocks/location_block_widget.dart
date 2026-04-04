import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/location_block.dart';

/// Content widget for selecting location type and entering a value.
class LocationBlockWidget extends StatefulWidget {
  /// Creates a [LocationBlockWidget].
  const LocationBlockWidget({required this.onConfigChanged, super.key});

  /// Called with a [LocationBlock] when the config changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<LocationBlockWidget> createState() => _LocationBlockWidgetState();
}

class _LocationBlockWidgetState extends State<LocationBlockWidget> {
  LocationType? _type;
  final _valueController = TextEditingController();

  static const _labels = {
    LocationType.specific: 'Specific Place',
    LocationType.city: 'City/Region',
    LocationType.category: 'Category',
    LocationType.anywhere: 'Anywhere',
  };

  bool get _needsInput => _type != null && _type != LocationType.anywhere;

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
    widget.onConfigChanged(LocationBlock(
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
                      color: AppColors.oceanTeal,
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
            SQInput(hint: 'Enter location', controller: _valueController),
          ],
        ],
      );
}
