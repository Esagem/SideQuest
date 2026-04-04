import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/constants/categories.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// Content widget for selecting a quest category.
class CategoryBlockWidget extends StatefulWidget {
  /// Creates a [CategoryBlockWidget].
  const CategoryBlockWidget({required this.onConfigChanged, super.key});

  /// Called with the category key string when selection changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<CategoryBlockWidget> createState() => _CategoryBlockWidgetState();
}

class _CategoryBlockWidgetState extends State<CategoryBlockWidget> {
  String? _selected;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: Category.values
            .map((c) => SQChip(
                  label: c.displayName,
                  color: c.color,
                  isSelected: _selected == c.name,
                  onTap: () {
                    setState(() => _selected = c.name);
                    widget.onConfigChanged(c.name);
                  },
                ),)
            .toList(),
      );
}
