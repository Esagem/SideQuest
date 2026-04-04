import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_theme.dart';

/// Root widget for the SideQuest application.
///
/// Configures [MaterialApp] with light and dark themes built from
/// the SideQuest design system tokens, and responds to the system
/// brightness setting.
class SideQuestApp extends StatelessWidget {
  /// Creates a [SideQuestApp].
  const SideQuestApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'SideQuest',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const Scaffold(
          body: Center(
            child: Text('SideQuest'),
          ),
        ),
      );
}
