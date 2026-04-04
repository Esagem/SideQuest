import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// The main shell with bottom navigation bar wrapping tab routes.
///
/// Contains 5 tabs: Home, Explore, Create (+), Activity, Profile.
/// The center "+" button is a Sunset Orange elevated circle.
class MainShell extends StatelessWidget {
  /// Creates a [MainShell].
  const MainShell({required this.child, super.key});

  /// The child route widget displayed above the bottom nav.
  final Widget child;

  static const _tabs = [
    ('/', Icons.home_outlined, Icons.home, 'Home'),
    ('/explore', Icons.explore_outlined, Icons.explore, 'Explore'),
    // Placeholder for center button
    ('/builder', Icons.add, Icons.add, 'Create'),
    ('/activity', Icons.notifications_outlined, Icons.notifications, 'Activity'),
    ('/profile', Icons.person_outlined, Icons.person, 'Profile'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/explore') return 1;
    if (location == '/activity') return 3;
    if (location == '/profile') return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    if (index == 2) {
      // Center button navigates to builder (full screen, exits shell)
      context.push('/builder');
      return;
    }
    final path = _tabs[index].$1;
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIdx = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomAppBar(
        color: isDark ? AppColors.deepNavy : AppColors.navy,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < _tabs.length; i++)
              if (i == 2)
                _CenterButton(onTap: () => _onTap(context, i))
              else
                _NavItem(
                  icon: i == currentIdx ? _tabs[i].$3 : _tabs[i].$2,
                  label: _tabs[i].$4,
                  isSelected: i == currentIdx,
                  onTap: () => _onTap(context, i),
                ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: AppSpacing.xxl * 1.2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.sunsetOrange
                    : AppColors.softGray,
                size: AppSpacing.lg,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppSpacing.sm,
                  color: isSelected
                      ? AppColors.sunsetOrange
                      : AppColors.softGray,
                ),
              ),
            ],
          ),
        ),
      );
}

class _CenterButton extends StatelessWidget {
  const _CenterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: AppSpacing.xxl + AppSpacing.xs,
          height: AppSpacing.xxl + AppSpacing.xs,
          decoration: const BoxDecoration(
            color: AppColors.sunsetOrange,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add,
            color: AppColors.white,
            size: AppSpacing.xl,
          ),
        ),
      );
}
