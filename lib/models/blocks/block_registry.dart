import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/models/blocks/block_meta.dart';

/// Registry of all available quest block types.
///
/// Provides [coreBlocks] (8 blocks) and [flavorBlocks] (7 blocks) used
/// by the block tray and builder to display and instantiate blocks.
abstract final class BlockRegistry {
  /// The 8 core block types — Title and Proof are required.
  static final List<BlockMeta> coreBlocks = [
    const BlockMeta(
      id: 'title',
      label: 'Title',
      emoji: '📝',
      color: AppColors.navy,
      isRequired: true,
    ),
    const BlockMeta(
      id: 'proof',
      label: 'Proof',
      emoji: '📸',
      color: AppColors.sunsetOrange,
      isRequired: true,
    ),
    const BlockMeta(
      id: 'location',
      label: 'Location',
      emoji: '📍',
      color: AppColors.oceanTeal,
    ),
    const BlockMeta(
      id: 'people',
      label: 'People',
      emoji: '👥',
      color: AppColors.warmYellow,
    ),
    const BlockMeta(
      id: 'time',
      label: 'Time',
      emoji: '⏱️',
      color: AppColors.softGray,
    ),
    const BlockMeta(
      id: 'category',
      label: 'Category',
      emoji: '🏷️',
      color: AppColors.navy,
    ),
    const BlockMeta(
      id: 'difficulty',
      label: 'Difficulty',
      emoji: '🎯',
      color: AppColors.emberRed,
    ),
    const BlockMeta(
      id: 'stages',
      label: 'Stages',
      emoji: '🪜',
      color: AppColors.oceanTeal,
    ),
  ];

  /// The 7 flavor block types — all optional enhancements.
  static final List<BlockMeta> flavorBlocks = [
    const BlockMeta(
      id: 'wildcard',
      label: 'Wildcard',
      emoji: '🎲',
      color: AppColors.warmYellow,
      isCoreBlock: false,
    ),
    const BlockMeta(
      id: 'prompt',
      label: 'Prompt',
      emoji: '💬',
      color: AppColors.sunsetOrange,
      isCoreBlock: false,
    ),
    const BlockMeta(
      id: 'chain',
      label: 'Chain',
      emoji: '🔗',
      color: AppColors.navy,
      isCoreBlock: false,
    ),
    const BlockMeta(
      id: 'bonus',
      label: 'Bonus',
      emoji: '🏅',
      color: AppColors.warmYellow,
      isCoreBlock: false,
    ),
    const BlockMeta(
      id: 'constraint',
      label: 'Constraint',
      emoji: '🚫',
      color: AppColors.emberRed,
      isCoreBlock: false,
    ),
    const BlockMeta(
      id: 'intent',
      label: 'Intent',
      emoji: '🎭',
      color: AppColors.sunsetOrange,
      isCoreBlock: false,
    ),
    const BlockMeta(
      id: 'repeat',
      label: 'Repeat',
      emoji: '🔄',
      color: AppColors.oceanTeal,
      isCoreBlock: false,
    ),
  ];

  /// All blocks combined (core + flavor).
  static List<BlockMeta> get allBlocks => [...coreBlocks, ...flavorBlocks];
}
