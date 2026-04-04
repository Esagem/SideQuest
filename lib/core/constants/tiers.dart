import 'package:flutter/material.dart';

/// User progression tiers based on total XP.
///
/// Each tier has a display label, minimum XP threshold, and icon.
/// Use [Tier.fromXp] to determine the correct tier for a given XP value.
enum Tier {
  /// Starting tier — 0 XP.
  novice('Novice', 0, Icons.eco_outlined),

  /// Second tier — 500 XP.
  explorer('Explorer', 500, Icons.explore_outlined),

  /// Third tier — 2,000 XP.
  adventurer('Adventurer', 2000, Icons.hiking),

  /// Fourth tier — 5,000 XP.
  trailblazer('Trailblazer', 5000, Icons.local_fire_department),

  /// Highest tier — 15,000 XP.
  legend('Legend', 15000, Icons.star);

  const Tier(this.label, this.minXp, this.icon);

  /// Human-readable tier label.
  final String label;

  /// Minimum XP required to reach this tier.
  final int minXp;

  /// The icon representing this tier.
  final IconData icon;

  /// Returns the [Tier] for the given total [xp].
  static Tier fromXp(int xp) {
    if (xp >= Tier.legend.minXp) return Tier.legend;
    if (xp >= Tier.trailblazer.minXp) return Tier.trailblazer;
    if (xp >= Tier.adventurer.minXp) return Tier.adventurer;
    if (xp >= Tier.explorer.minXp) return Tier.explorer;
    return Tier.novice;
  }
}
