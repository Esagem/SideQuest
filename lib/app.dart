import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/providers/theme_providers.dart';
import 'package:sidequest/router/app_router.dart';

/// Root widget for the SideQuest application.
///
/// Configures [MaterialApp.router] with light and dark themes,
/// GoRouter navigation, and Riverpod state management.
class SideQuestApp extends ConsumerWidget {
  /// Creates a [SideQuestApp].
  const SideQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'SideQuest',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
