import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/settings/widgets/settings_tile.dart';
import 'package:sidequest/providers/auth_providers.dart';
import 'package:sidequest/providers/theme_providers.dart';

/// The settings screen with theme toggle, moderation policy,
/// blocked users, sign out, and delete account.
class SettingsScreen extends ConsumerWidget {
  /// Creates a [SettingsScreen].
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: AppSpacing.sm),
          // Appearance
          SettingsTile(
            title: 'Appearance',
            icon: Icons.palette,
            subtitle: themeMode.name,
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: const SizedBox.shrink(),
              items: ThemeMode.values
                  .map((m) => DropdownMenuItem(
                        value: m,
                        child: Text(m.name),
                      ),)
                  .toList(),
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).state = mode;
                }
              },
            ),
          ),
          const Divider(),
          // Blocked Users
          SettingsTile(
            title: 'Blocked Users',
            icon: Icons.block,
            onTap: () {
              // TODO(settings): Navigate to blocked users list
              SQToast.success(context, 'Blocked users coming soon.');
            },
          ),
          // Moderation Policy
          SettingsTile(
            title: 'Community Guidelines',
            icon: Icons.policy,
            onTap: () => context.push('/settings/moderation-policy'),
          ),
          const Divider(),
          // Sign out
          SettingsTile(
            title: 'Sign Out',
            icon: Icons.logout,
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go('/auth/welcome');
            },
          ),
          // Delete account
          SettingsTile(
            title: 'Delete Account',
            icon: Icons.delete_forever,
            isDestructive: true,
            onTap: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action is permanent. All your data will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authRepositoryProvider).deleteAccount();
              if (context.mounted) context.go('/auth/welcome');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
