import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_card.dart';
import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// Data required to render a quest card.
///
/// This is a lightweight display model decoupled from the Freezed
/// [QuestModel] so the component can be built and tested independently.
/// Map from [QuestModel] at the call site.
class SQQuestCardData {
  /// Creates an [SQQuestCardData].
  const SQQuestCardData({
    required this.title,
    required this.category,
    this.intents = const [],
    this.difficulty,
    this.completionCount = 0,
    this.proofThumbnailUrl,
  });

  /// The quest title.
  final String title;

  /// Category key (e.g. 'travel', 'food') for accent color.
  final String category;

  /// Intent tag keys (e.g. ['growth', 'fun']).
  final List<String> intents;

  /// Difficulty label (e.g. 'Easy', 'Legendary').
  final String? difficulty;

  /// Number of completions.
  final int completionCount;

  /// URL of the featured proof thumbnail.
  final String? proofThumbnailUrl;
}

/// A quest card used in Home, Explore, and Activity feeds.
///
/// Built on [SQCard] with a category-colored left border. Displays
/// the quest title, category chip, intent chips, difficulty badge,
/// completion count, and an optional proof thumbnail.
class SQQuestCard extends StatelessWidget {
  /// Creates an [SQQuestCard].
  const SQQuestCard({
    required this.quest,
    this.onTap,
    this.onAddToList,
    this.showAddButton = false,
    super.key,
  });

  /// The quest data to display.
  final SQQuestCardData quest;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  /// Called when the add-to-list button is tapped.
  final VoidCallback? onAddToList;

  /// Whether to show the add-to-list button.
  final bool showAddButton;

  @override
  Widget build(BuildContext context) => SQCard(
        categoryAccent: quest.category,
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildContent(context)),
            if (quest.proofThumbnailUrl != null) ...[
              const SizedBox(width: AppSpacing.sm),
              _buildThumbnail(),
            ],
          ],
        ),
      );

  Widget _buildContent(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            quest.title,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xxs,
            runSpacing: AppSpacing.xxs,
            children: [
              SQChip(
                label: quest.category,
                color: AppColors.categoryColor(quest.category),
              ),
              ...quest.intents.map(
                (intent) => SQChip(
                  label: intent,
                  color: AppColors.intentColor(intent),
                ),
              ),
              if (quest.difficulty != null)
                SQChip(
                  label: quest.difficulty!,
                  color: AppColors.softGray,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: AppSpacing.md,
                color: AppColors.softGray,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${quest.completionCount}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (showAddButton) ...[
                const Spacer(),
                GestureDetector(
                  onTap: onAddToList,
                  child: const Icon(
                    Icons.add_circle_outline,
                    size: AppSpacing.lg,
                    color: AppColors.sunsetOrange,
                  ),
                ),
              ],
            ],
          ),
        ],
      );

  Widget _buildThumbnail() => ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.xs),
        child: Image.network(
          quest.proofThumbnailUrl!,
          width: AppSpacing.xxl * 1.5,
          height: AppSpacing.xxl * 1.5,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: AppSpacing.xxl * 1.5,
            height: AppSpacing.xxl * 1.5,
            color: AppColors.lightGray,
            child: const Icon(
              Icons.image_outlined,
              color: AppColors.softGray,
              size: AppSpacing.lg,
            ),
          ),
        ),
      );
}
