import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/core/theme/app_typography.dart';

/// The welcome/landing screen shown to unauthenticated users.
///
/// Displays the app logo, tagline, and navigation to sign up or log in.
class WelcomeScreen extends StatelessWidget {
  /// Creates a [WelcomeScreen].
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                const Icon(
                  Icons.explore_rounded,
                  size: AppSpacing.xxl * 2,
                  color: AppColors.sunsetOrange,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'SideQuest',
                  style: AppTypography.hero.copyWith(
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Stop scrolling. Start doing.',
                  style: AppTypography.body.copyWith(
                    color: AppColors.softGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 3),
                SQButton.primary(
                  label: 'Get Started',
                  onPressed: () => context.go('/auth/signup'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => context.go('/auth/login'),
                  child: Text(
                    'Already have an account? Log in',
                    style: AppTypography.body.copyWith(
                      color: AppColors.sunsetOrange,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      );
}
