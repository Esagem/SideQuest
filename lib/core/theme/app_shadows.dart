import 'package:flutter/material.dart';

/// Box shadow definitions for the SideQuest design system.
///
/// Three elevation levels: [card] for resting surfaces, [elevated] for
/// modals and raised elements, and [button] for interactive controls.
abstract final class AppShadows {
  /// Card shadow — subtle resting elevation.
  ///
  /// `offset(0, 2)`, blur 8, rgba(0, 0, 0, 0.08).
  static const BoxShadow card = BoxShadow(
    offset: Offset(0, 2),
    blurRadius: 8,
    color: Color(0x14000000), // rgba(0,0,0,0.08)
  );

  /// Elevated shadow — modals, popovers, raised surfaces.
  ///
  /// `offset(0, 4)`, blur 16, rgba(0, 0, 0, 0.12).
  static const BoxShadow elevated = BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 16,
    color: Color(0x1F000000), // rgba(0,0,0,0.12)
  );

  /// Button shadow — subtle depth on interactive controls.
  ///
  /// `offset(0, 2)`, blur 4, rgba(0, 0, 0, 0.1).
  static const BoxShadow button = BoxShadow(
    offset: Offset(0, 2),
    blurRadius: 4,
    color: Color(0x1A000000), // rgba(0,0,0,0.1)
  );

  /// Convenience list containing only the [card] shadow.
  static const List<BoxShadow> cardShadow = [card];

  /// Convenience list containing only the [elevated] shadow.
  static const List<BoxShadow> elevatedShadow = [elevated];

  /// Convenience list containing only the [button] shadow.
  static const List<BoxShadow> buttonShadow = [button];
}
