import 'package:flutter/foundation.dart';

/// Service for generating and handling deep links.
///
/// Creates shareable links for quests, profiles, challenges, and
/// invites. Handles incoming links by parsing them into route paths.
/// Supports deferred deep links for unauthenticated users.
abstract final class DeepLinkService {
  /// The base URL for all deep links.
  static const String baseUrl = 'https://sidequestapp.com';

  /// The Android package name for Dynamic Links.
  static const String androidPackage = 'com.surgestudios.sidequest';

  /// The iOS bundle ID for Dynamic Links.
  static const String iosBundleId = 'com.surgestudios.sidequest';

  // ---------------------------------------------------------------------------
  // Link Generation
  // ---------------------------------------------------------------------------

  /// Generates a deep link URL for a quest.
  static String questLink(String questId) => '$baseUrl/quest/$questId';

  /// Generates a deep link URL for a user profile by user ID.
  static String profileLink(String userId) => '$baseUrl/profile/$userId';

  /// Generates a deep link URL for a user profile by username.
  static String userLink(String username) => '$baseUrl/user/$username';

  /// Generates a deep link URL for a challenge.
  static String challengeLink(String challengeId) =>
      '$baseUrl/challenge/$challengeId';

  /// Generates a personal invite link with optional referral tracking.
  static String inviteLink({String? referrerId}) {
    const base = '$baseUrl/invite';
    return referrerId != null ? '$base?ref=$referrerId' : base;
  }

  /// The invite message text including the link.
  static String inviteMessage({String? referrerId}) =>
      'Join me on SideQuest! Stop scrolling, start doing. '
      '${inviteLink(referrerId: referrerId)}';

  // ---------------------------------------------------------------------------
  // Link Parsing
  // ---------------------------------------------------------------------------

  /// Parses a deep link URI and returns the route path, or null if invalid.
  ///
  /// Supports:
  /// - /quest/:questId → /quest/:questId
  /// - /profile/:userId → /profile/:userId
  /// - /user/:username → /profile/:username (alias)
  /// - /challenge/:challengeId → /challenge/:challengeId (quest detail)
  /// - /invite → / (home screen)
  static String? parseLink(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.isEmpty) return null;

    final type = segments.first;
    final id = segments.length >= 2 ? segments[1] : null;

    return switch (type) {
      'quest' when id != null => '/quest/$id',
      'profile' when id != null => '/profile/$id',
      'user' when id != null => '/profile/$id',
      'challenge' when id != null => '/quest/$id',
      'invite' => '/',
      _ => null,
    };
  }

  /// Extracts the referrer ID from an invite link's query parameters.
  static String? extractReferrer(Uri uri) =>
      uri.queryParameters['ref'];
}

/// Manages deferred deep links for unauthenticated users.
///
/// Stores a pending link when the user isn't authenticated, then
/// provides it for navigation after auth completes.
class DeferredDeepLinkHandler {
  /// The pending link to navigate to after authentication.
  String? _pendingRoute;

  /// Whether there is a pending deferred link.
  bool get hasPending => _pendingRoute != null;

  /// The pending route path, if any.
  String? get pendingRoute => _pendingRoute;

  /// Stores a link to be handled after authentication.
  void store(String route) {
    _pendingRoute = route;
    debugPrint('DeferredDeepLink: stored $route');
  }

  /// Consumes and returns the pending route, clearing it.
  ///
  /// Returns null if no pending route exists.
  String? consume() {
    final route = _pendingRoute;
    _pendingRoute = null;
    return route;
  }

  /// Handles an incoming link URI.
  ///
  /// If [isAuthenticated] is true, returns the parsed route for
  /// immediate navigation. Otherwise stores it as deferred.
  String? handleIncoming(Uri uri, {required bool isAuthenticated}) {
    final route = DeepLinkService.parseLink(uri);
    if (route == null) return null;

    if (isAuthenticated) return route;

    store(route);
    return null;
  }
}
