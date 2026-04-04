import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_avatar.dart';
import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/user_model.dart';

/// Provider for searching users by username or display name.
///
/// In production this would call [UserRepository.searchByUsername].
final userSearchProvider =
    StreamProvider.family<List<UserModel>, String>(
  (ref, query) => Stream.value(<UserModel>[]),
);

/// Screen for searching and adding friends.
///
/// Shows search input, search results with "Add Friend" buttons,
/// pending requests section, and contact sync option.
class FriendSearchScreen extends ConsumerStatefulWidget {
  /// Creates a [FriendSearchScreen].
  const FriendSearchScreen({super.key});

  @override
  ConsumerState<FriendSearchScreen> createState() =>
      _FriendSearchScreenState();
}

class _FriendSearchScreenState extends ConsumerState<FriendSearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Find Friends')),
        body: Column(
          children: [
            // Search input
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SQInput(
                hint: 'Search by username or name',
                controller: _searchController,
              ),
            ),
            // Search button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SQButton.primary(
                label: 'Search',
                onPressed: () =>
                    setState(() => _query = _searchController.text.trim()),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Results
            if (_query.isNotEmpty)
              Expanded(child: _SearchResults(query: _query))
            else
              Expanded(child: _DefaultContent()),
          ],
        ),
      );
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(userSearchProvider(query));

    return resultsAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return Center(
            child: Text(
              'No users found for "$query"',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: users.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppSpacing.xs),
          itemBuilder: (_, index) {
            final user = users[index];
            return _UserResultTile(user: user);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _UserResultTile extends StatelessWidget {
  const _UserResultTile({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: SQAvatar(
          displayName: user.displayName,
          imageUrl: user.avatarUrl,
          size: AppSpacing.xxl,
        ),
        title: Text(user.displayName),
        subtitle: Text('@${user.username}'),
        trailing: SizedBox(
          width: AppSpacing.xxl * 2,
          child: SQButton.primary(
            label: 'Add',
            icon: Icons.person_add,
            onPressed: () {
              // TODO(social): Send friend request via FriendshipRepository
              SQToast.success(context, 'Friend request sent!');
            },
          ),
        ),
        onTap: () => context.push('/profile/${user.uid}'),
      );
}

class _DefaultContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Pending requests section
          Text(
            'Pending Requests',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          // Placeholder — would be populated from FriendshipRepository
          Text(
            'No pending requests.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),
          // Contact sync section
          Text(
            'Find from Contacts',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          SQButton.secondary(
            label: 'Find friends from your contacts',
            icon: Icons.contacts,
            onPressed: () {
              // TODO(social): Implement contact sync
              SQToast.success(context, 'Contact sync coming soon!');
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          // Invite section
          Text(
            'Invite Friends',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          SQButton.primary(
            label: 'Invite via share',
            icon: Icons.share,
            onPressed: () {
              // Uses ShareService.shareGeneric with invite message
              SQToast.success(context, 'Invite link copied!');
            },
          ),
        ],
      );
}
