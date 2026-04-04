import 'package:flutter/material.dart';

import 'package:sidequest/models/blocks/block_meta.dart';

/// Contract that every quest block widget must implement.
///
/// This interface enables the builder to work with any block type
/// uniformly, supporting expand/collapse, config changes, and removal.
abstract class QuestBlockWidget extends StatelessWidget {
  /// Creates a [QuestBlockWidget].
  const QuestBlockWidget({
    required this.isExpanded,
    required this.onConfigChanged,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  /// The block's display metadata.
  BlockMeta get meta;

  /// Whether the block is currently expanded (showing options).
  final bool isExpanded;

  /// Callback when the block's configuration changes.
  final ValueChanged<dynamic> onConfigChanged;

  /// Callback when the block is tapped (expand/collapse).
  final VoidCallback onTap;

  /// Callback when the block is removed from the builder.
  final VoidCallback onRemove;
}
