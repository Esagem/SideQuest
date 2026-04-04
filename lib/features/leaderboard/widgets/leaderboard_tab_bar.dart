import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A tab bar for switching between leaderboard types.
///
/// Tabs: Weekly (default), Friends, Category, Global.
class LeaderboardTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [LeaderboardTabBar].
  const LeaderboardTabBar({required this.controller, super.key});

  /// The tab controller.
  final TabController controller;

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.xxl);

  @override
  Widget build(BuildContext context) => TabBar(
        controller: controller,
        labelColor: AppColors.sunsetOrange,
        unselectedLabelColor: AppColors.softGray,
        indicatorColor: AppColors.sunsetOrange,
        tabs: const [
          Tab(text: 'Weekly'),
          Tab(text: 'Friends'),
          Tab(text: 'Category'),
          Tab(text: 'Global'),
        ],
      );
}
