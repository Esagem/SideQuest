import 'package:flutter/material.dart';

/// Border radius constants for the SideQuest design system.
///
/// Provides named radius values and pre-built [BorderRadius] instances
/// for consistent corner rounding across all UI components.
abstract final class AppRadius {
  // ---------------------------------------------------------------------------
  // Raw Values
  // ---------------------------------------------------------------------------

  /// Small radius — 8px. Used for buttons, text inputs.
  static const double small = 8;

  /// Card radius — 16px. Used for cards, quest blocks.
  static const double card = 16;

  /// Chip radius — 20px. Used for pill-shaped chips and tags.
  static const double chip = 20;

  /// Sheet radius — 24px. Used for bottom sheets and modals.
  static const double sheet = 24;

  // ---------------------------------------------------------------------------
  // BorderRadius Helpers
  // ---------------------------------------------------------------------------

  /// [BorderRadius] with [small] (8px) on all corners.
  static const BorderRadius smallRadius = BorderRadius.all(
    Radius.circular(small),
  );

  /// [BorderRadius] with [card] (16px) on all corners.
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(card),
  );

  /// [BorderRadius] with [chip] (20px) on all corners.
  static const BorderRadius chipRadius = BorderRadius.all(
    Radius.circular(chip),
  );

  /// [BorderRadius] with [sheet] (24px) on top corners only.
  static const BorderRadius sheetRadius = BorderRadius.only(
    topLeft: Radius.circular(sheet),
    topRight: Radius.circular(sheet),
  );
}
