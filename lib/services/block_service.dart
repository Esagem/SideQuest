import 'package:sidequest/models/user_model.dart';
import 'package:sidequest/repositories/user_repository.dart';

/// Service for blocking and unblocking users.
///
/// Manages the blockedUsers list on the current user's profile.
/// Blocked user content is filtered client-side using [isBlocked].
class BlockService {
  /// Creates a [BlockService].
  BlockService(this._userRepository);

  final UserRepository _userRepository;

  /// Blocks a user by adding their ID to the blocker's blockedUsers list.
  Future<void> blockUser({
    required String currentUserId,
    required String blockedUserId,
  }) async {
    final user = await _userRepository.getById(currentUserId);
    if (user == null) return;
    final updated = [...user.blockedUsers, blockedUserId];
    await _userRepository.update(currentUserId, {
      'blockedUsers': updated,
    });
  }

  /// Unblocks a user by removing their ID from the blockedUsers list.
  Future<void> unblockUser({
    required String currentUserId,
    required String blockedUserId,
  }) async {
    final user = await _userRepository.getById(currentUserId);
    if (user == null) return;
    final updated = user.blockedUsers
        .where((id) => id != blockedUserId)
        .toList();
    await _userRepository.update(currentUserId, {
      'blockedUsers': updated,
    });
  }

  /// Checks whether [targetUserId] is blocked by the current user.
  static bool isBlocked(UserModel currentUser, String targetUserId) =>
      currentUser.blockedUsers.contains(targetUserId);
}
