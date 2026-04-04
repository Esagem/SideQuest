/// Service for generating and handling Firebase Dynamic Links.
///
/// Creates deep links for quests that work across platforms and
/// handle deferred deep links for new users.
abstract final class DeepLinkService {
  /// The base URL for deep links.
  static const String baseUrl = 'https://sidequestapp.com';

  /// Generates a deep link URL for a quest.
  static String questLink(String questId) => '$baseUrl/quest/$questId';

  /// Generates a deep link URL for a user profile.
  static String profileLink(String userId) => '$baseUrl/profile/$userId';

  /// Parses a deep link and returns the route path, or null if invalid.
  ///
  /// Supports:
  /// - /quest/:questId → navigates to quest detail
  /// - /profile/:userId → navigates to friend profile
  static String? parseLink(Uri uri) {
    final pathSegments = uri.pathSegments;
    if (pathSegments.length < 2) return null;

    final type = pathSegments[0];
    final id = pathSegments[1];

    return switch (type) {
      'quest' => '/quest/$id',
      'profile' => '/profile/$id',
      _ => null,
    };
  }
}
