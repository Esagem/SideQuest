import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/block_meta.dart';
import 'package:sidequest/models/blocks/block_registry.dart';

/// Horizontal tray showing available blocks to add to the builder.
///
/// Divided into "Core" and "Flavor" sections. Blocks already placed
/// are dimmed. Tapping a block adds it to the build area.
class BlockTray extends StatelessWidget {
  /// Creates a [BlockTray].
  const BlockTray({
    required this.placedBlockIds,
    required this.onBlockTap,
    super.key,
  });

  /// IDs of blocks already placed in the builder.
  final Set<String> placedBlockIds;

  /// Called when a block in the tray is tapped.
  final ValueChanged<BlockMeta> onBlockTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepNavy : AppColors.offWhite,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.slate : AppColors.lightGray,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              ..._buildSection(context, 'Core', BlockRegistry.coreBlocks),
              _Divider(isDark: isDark),
              ..._buildSection(context, 'Flavor', BlockRegistry.flavorBlocks),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSection(
    BuildContext context,
    String label,
    List<BlockMeta> blocks,
  ) =>
      [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.xs),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.softGray,
                ),
          ),
        ),
        ...blocks.map(
          (meta) => Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: _TrayItem(
              meta: meta,
              isPlaced: placedBlockIds.contains(meta.id),
              onTap: () {
                HapticFeedback.lightImpact();
                onBlockTap(meta);
              },
            ),
          ),
        ),
      ];
}

class _Divider extends StatelessWidget {
  const _Divider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: AppSpacing.xl,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        color: isDark ? AppColors.slate : AppColors.lightGray,
      );
}

class _TrayItem extends StatelessWidget {
  const _TrayItem({
    required this.meta,
    required this.isPlaced,
    required this.onTap,
  });

  final BlockMeta meta;
  final bool isPlaced;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dimmed = isPlaced && meta.maxInstances == 1;

    return GestureDetector(
      onTap: dimmed ? null : onTap,
      child: AnimatedOpacity(
        opacity: dimmed ? 0.4 : 1,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardNavy : AppColors.white,
            borderRadius: AppRadius.smallRadius,
            border: Border.all(
              color: isDark ? AppColors.slate : AppColors.lightGray,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(meta.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                meta.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
