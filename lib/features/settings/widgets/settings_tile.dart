import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A single settings list tile with icon, title, optional subtitle,
/// and chevron or trailing widget.
class SettingsTile extends StatelessWidget {
  /// Creates a [SettingsTile].
  const SettingsTile({
    required this.title,
    required this.icon,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.isDestructive = false,
    super.key,
  });

  /// The tile title.
  final String title;

  /// Leading icon.
  final IconData icon;

  /// Optional subtitle below the title.
  final String? subtitle;

  /// Called when the tile is tapped.
  final VoidCallback? onTap;

  /// Optional trailing widget (defaults to chevron).
  final Widget? trailing;

  /// Whether to use destructive (red) styling.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.emberRed : null;

    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.softGray),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
            color: AppColors.softGray,
            size: AppSpacing.lg,
          ),
      onTap: onTap,
    );
  }
}
