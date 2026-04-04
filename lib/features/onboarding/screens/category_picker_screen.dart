import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/constants/categories.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/core/theme/app_typography.dart';

/// Onboarding step 2: pick at least 3 categories.
class CategoryPickerScreen extends StatefulWidget {
  /// Creates a [CategoryPickerScreen].
  const CategoryPickerScreen({super.key});

  @override
  State<CategoryPickerScreen> createState() => _CategoryPickerScreenState();
}

class _CategoryPickerScreenState extends State<CategoryPickerScreen> {
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                const Text(
                  'Pick your playgrounds',
                  style: AppTypography.hero,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Choose at least 3 categories',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.softGray,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: Category.values.map((c) {
                      final isSelected = _selected.contains(c.name);
                      return SQChip(
                        label: c.displayName,
                        color: c.color,
                        isSelected: isSelected,
                        onTap: () => setState(() {
                          if (isSelected) {
                            _selected.remove(c.name);
                          } else {
                            _selected.add(c.name);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                ),
                SQButton.primary(
                  label: 'Continue',
                  onPressed: _selected.length >= 3
                      ? () => context.go('/onboarding/starter')
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      );
}
