import 'package:flutter/material.dart';

/// Display metadata for a quest block type.
///
/// Used by the block tray to show available blocks, and by the
/// builder to render block cards. Every block widget exposes
/// a [BlockMeta] describing itself.
class BlockMeta {
  /// Creates a [BlockMeta].
  const BlockMeta({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
    this.isRequired = false,
    this.isCoreBlock = true,
    this.maxInstances = 1,
  });

  /// Unique identifier (e.g. 'proof', 'location', 'stages').
  final String id;

  /// Human-readable label (e.g. 'Proof', 'Location', 'Stages').
  final String label;

  /// Emoji representing this block (e.g. '📸', '📍', '🪜').
  final String emoji;

  /// Block accent color.
  final Color color;

  /// Whether this block is required (Title and Proof are required).
  final bool isRequired;

  /// Whether this is a core block (true) or a flavor block (false).
  final bool isCoreBlock;

  /// Maximum number of instances allowed (1 for most blocks).
  final int maxInstances;
}
