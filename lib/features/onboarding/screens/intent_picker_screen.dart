import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/constants/intents.dart' as intents;
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/core/theme/app_typography.dart';

/// Onboarding step 1: pick at least 2 intents that drive you.
class IntentPickerScreen extends StatefulWidget {
  /// Creates an [IntentPickerScreen].
  const IntentPickerScreen({super.key});

  @override
  State<IntentPickerScreen> createState() => _IntentPickerScreenState();
}

class _IntentPickerScreenState extends State<IntentPickerScreen> {
  final _selected = <String>{};

  static const _descriptions = {
    'growth': 'Level up your skills and knowledge',
    'connection': 'Build meaningful relationships',
    'fun': 'Pure joy and entertainment',
    'challenge': 'Push your limits and grow stronger',
    'explore': 'Discover new places and experiences',
    'create': 'Make and build something new',
  };

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                const Text('What drives you?', style: AppTypography.hero),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Pick at least 2',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.softGray,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 1.3,
                    children: intents.Intent.values.map((i) {
                      final isSelected = _selected.contains(i.name);
                      return _IntentCard(
                        emoji: i.emoji,
                        label: i.displayName,
                        description: _descriptions[i.name] ?? '',
                        color: i.color,
                        isSelected: isSelected,
                        onTap: () => setState(() {
                          if (isSelected) {
                            _selected.remove(i.name);
                          } else {
                            _selected.add(i.name);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                ),
                SQButton.primary(
                  label: 'Continue',
                  onPressed: _selected.length >= 2
                      ? () => context.go(
                            '/onboarding/categories',
                            extra: _selected.toList(),
                          )
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      );
}

class _IntentCard extends StatelessWidget {
  const _IntentCard({
    required this.emoji,
    required this.label,
    required this.description,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final String description;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              // ignore: deprecated_member_use
              ? color.withOpacity(0.15)
              : isDark
                  ? AppColors.cardNavy
                  : AppColors.white,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(
            color: isSelected ? color : AppColors.lightGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
