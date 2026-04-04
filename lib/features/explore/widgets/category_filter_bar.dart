import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/constants/categories.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// Horizontal scrollable category filter chips.
///
/// Single-select: tap to filter, tap again to clear.
class CategoryFilterBar extends StatelessWidget {
  /// Creates a [CategoryFilterBar].
  const CategoryFilterBar({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// The currently selected category key, or null for "All".
  final String? selected;

  /// Called with the category key or null to clear.
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            SQChip(
              label: 'All',
              color: AppColors.softGray,
              isSelected: selected == null,
              onTap: () => onSelected(null),
            ),
            const SizedBox(width: AppSpacing.xs),
            ...Category.values.map(
              (c) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: SQChip(
                  label: c.displayName,
                  color: c.color,
                  isSelected: selected == c.name,
                  onTap: () => onSelected(
                    selected == c.name ? null : c.name,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
