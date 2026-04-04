import 'package:flutter/material.dart';

/// Root widget for the SideQuest application.
///
/// Configures [MaterialApp] with theming, routing, and global providers.
class SideQuestApp extends StatelessWidget {
  /// Creates a [SideQuestApp].
  const SideQuestApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'SideQuest',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B2A4A)),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: Center(
            child: Text('SideQuest'),
          ),
        ),
      );
}
