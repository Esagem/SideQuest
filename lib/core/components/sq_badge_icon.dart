import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';


/// Displays a badge icon by mapping badge IDs to icons and colors.
///
/// Used in profile badge showcases, trophy cases, and quest completion
/// awards. Falls back to a generic star icon for unrecognized badge IDs.
class SQBadgeIcon extends StatelessWidget {
  /// Creates an [SQBadgeIcon].
  const SQBadgeIcon({
    required this.badgeId,
    this.size = 32,
    super.key,
  });

  /// The unique badge identifier used to look up the icon and color.
  final String badgeId;

  /// The icon size in logical pixels.
  final double size;

  static const Map<String, _BadgeData> _badges = {
    'first_quest': _BadgeData(Icons.flag_rounded, AppColors.oceanTeal),
    'streak_7': _BadgeData(Icons.local_fire_department, AppColors.sunsetOrange),
    'streak_30': _BadgeData(Icons.local_fire_department, AppColors.emberRed),
    'social_butterfly':
        _BadgeData(Icons.people_rounded, AppColors.warmYellow),
    'explorer': _BadgeData(Icons.explore_rounded, AppColors.navy),
    'creator': _BadgeData(Icons.brush_rounded, AppColors.intentCreate),
    'challenger': _BadgeData(Icons.bolt_rounded, AppColors.emberRed),
    'completionist':
        _BadgeData(Icons.check_circle_rounded, AppColors.oceanTeal),
  };

  @override
  Widget build(BuildContext context) {
    final data =
        _badges[badgeId] ?? const _BadgeData(Icons.star_rounded, AppColors.warmYellow);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: data.color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        data.icon,
        size: size * 0.6,
        color: data.color,
      ),
    );
  }
}

class _BadgeData {
  const _BadgeData(this.icon, this.color);

  final IconData icon;
  final Color color;
}
