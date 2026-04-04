import 'package:flutter/material.dart';

/// Spacing constants for the SideQuest design system.
///
/// Provides a consistent 4-point grid scale used for padding, margins,
/// and gaps throughout the app. Use these constants instead of raw numbers.
abstract final class AppSpacing {
  /// 4 logical pixels.
  static const double xxs = 4;

  /// 8 logical pixels.
  static const double xs = 8;

  /// 12 logical pixels.
  static const double sm = 12;

  /// 16 logical pixels — the default spacing unit.
  static const double md = 16;

  /// 24 logical pixels.
  static const double lg = 24;

  /// 32 logical pixels.
  static const double xl = 32;

  /// 48 logical pixels.
  static const double xxl = 48;

  // ---------------------------------------------------------------------------
  // EdgeInsets Helpers
  // ---------------------------------------------------------------------------

  /// Uniform padding of [size] on all sides.
  static EdgeInsets paddingAll(double size) => EdgeInsets.all(size);

  /// Symmetric horizontal padding of [size].
  static EdgeInsets paddingH(double size) =>
      EdgeInsets.symmetric(horizontal: size);

  /// Symmetric vertical padding of [size].
  static EdgeInsets paddingV(double size) =>
      EdgeInsets.symmetric(vertical: size);
}
