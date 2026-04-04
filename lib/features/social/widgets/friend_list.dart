import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_avatar.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/user_model.dart';

/// A scrollable list of friends with swipe-to-remove support.
class FriendList extends StatelessWidget {
  /// Creates a [FriendList].
  const FriendList({
    required this.friends,
    this.onRemove,
    super.key,
  });

  /// The list of friend user models.
  final List<UserModel> friends;

  /// Called with the user ID when a friend is swiped to remove.
  final void Function(String userId)? onRemove;

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return Center(
        child: Text(
          'No friends yet. Search for people to connect with!',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: friends.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final friend = friends[index];
        return Dismissible(
          key: ValueKey(friend.uid),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            color: AppColors.emberRed,
            child: const Icon(
              Icons.person_remove,
              color: AppColors.white,
            ),
          ),
          confirmDismiss: (_) => _confirmRemove(context, friend.displayName),
          onDismissed: (_) => onRemove?.call(friend.uid),
          child: ListTile(
            leading: SQAvatar(
              displayName: friend.displayName,
              imageUrl: friend.avatarUrl,
              size: AppSpacing.xxl,
            ),
            title: Text(friend.displayName),
            subtitle: Text('@${friend.username}'),
            onTap: () => context.push('/profile/${friend.uid}'),
          ),
        );
      },
    );
  }

  Future<bool> _confirmRemove(BuildContext context, String name) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Friend'),
        content: Text('Remove $name from your friends?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
