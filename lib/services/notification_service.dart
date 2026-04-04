import 'package:flutter/foundation.dart';

/// Types of push notifications the app can send.
enum NotificationType {
  /// A friend request was received.
  friendRequest,

  /// A challenge was received.
  challengeReceived,

  /// A friend completed a quest.
  friendQuestCompleted,

  /// Streak reminder on day 6 with no completion.
  streakReminder,

  /// A new badge was earned.
  badgeEarned,

  /// Leaderboard rank changed.
  leaderboardChange,
}

/// User notification preferences — which types are enabled.
class NotificationPreferences {
  /// Creates [NotificationPreferences] with all types enabled by default.
  const NotificationPreferences({
    this.friendRequest = true,
    this.challengeReceived = true,
    this.friendQuestCompleted = true,
    this.streakReminder = true,
    this.badgeEarned = true,
    this.leaderboardChange = true,
  });

  /// Creates from a Firestore-compatible map.
  factory NotificationPreferences.fromMap(Map<String, dynamic> map) =>
      NotificationPreferences(
        friendRequest: map['friendRequest'] as bool? ?? true,
        challengeReceived: map['challengeReceived'] as bool? ?? true,
        friendQuestCompleted: map['friendQuestCompleted'] as bool? ?? true,
        streakReminder: map['streakReminder'] as bool? ?? true,
        badgeEarned: map['badgeEarned'] as bool? ?? true,
        leaderboardChange: map['leaderboardChange'] as bool? ?? true,
      );

  /// Whether friend request notifications are enabled.
  final bool friendRequest;

  /// Whether challenge received notifications are enabled.
  final bool challengeReceived;

  /// Whether friend quest completion notifications are enabled.
  final bool friendQuestCompleted;

  /// Whether streak reminder notifications are enabled.
  final bool streakReminder;

  /// Whether badge earned notifications are enabled.
  final bool badgeEarned;

  /// Whether leaderboard change notifications are enabled.
  final bool leaderboardChange;

  /// Whether a specific [type] is enabled.
  bool isEnabled(NotificationType type) => switch (type) {
        NotificationType.friendRequest => friendRequest,
        NotificationType.challengeReceived => challengeReceived,
        NotificationType.friendQuestCompleted => friendQuestCompleted,
        NotificationType.streakReminder => streakReminder,
        NotificationType.badgeEarned => badgeEarned,
        NotificationType.leaderboardChange => leaderboardChange,
      };

  /// Converts to a Firestore-compatible map.
  Map<String, dynamic> toMap() => {
        'friendRequest': friendRequest,
        'challengeReceived': challengeReceived,
        'friendQuestCompleted': friendQuestCompleted,
        'streakReminder': streakReminder,
        'badgeEarned': badgeEarned,
        'leaderboardChange': leaderboardChange,
      };

  /// Creates a copy with the given field changed.
  NotificationPreferences copyWith({
    bool? friendRequest,
    bool? challengeReceived,
    bool? friendQuestCompleted,
    bool? streakReminder,
    bool? badgeEarned,
    bool? leaderboardChange,
  }) =>
      NotificationPreferences(
        friendRequest: friendRequest ?? this.friendRequest,
        challengeReceived: challengeReceived ?? this.challengeReceived,
        friendQuestCompleted:
            friendQuestCompleted ?? this.friendQuestCompleted,
        streakReminder: streakReminder ?? this.streakReminder,
        badgeEarned: badgeEarned ?? this.badgeEarned,
        leaderboardChange: leaderboardChange ?? this.leaderboardChange,
      );
}

/// Service for managing push notifications via Firebase Cloud Messaging.
///
/// Handles FCM initialization, permission requests, token management,
/// and routing notification taps to the correct screens.
class NotificationService {
  /// The current FCM token, or null if not yet obtained.
  String? _fcmToken;

  /// The current FCM token.
  String? get fcmToken => _fcmToken;

  /// Initializes FCM: requests permission, gets token, sets up handlers.
  Future<void> initialize() async {
    // TODO(notifications): Initialize with firebase_messaging
    // 1. Request notification permission
    // 2. Get FCM token
    // 3. Set up onMessage (foreground)
    // 4. Set up onMessageOpenedApp (background tap)
    // 5. Check getInitialMessage (terminated tap)
    debugPrint('NotificationService: initialized (placeholder)');
  }

  /// Stores the FCM token for the given [userId].
  Future<void> storeToken({
    required String userId,
    required String token,
  }) async {
    _fcmToken = token;
    // TODO(notifications): Save to user document
    debugPrint('NotificationService: stored token for $userId');
  }

  /// Parses a notification payload and returns the route to navigate to.
  ///
  /// Returns null if the payload doesn't contain routing data.
  static String? parseRoute(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final targetId = data['targetId'] as String?;

    if (type == null) return null;

    return switch (type) {
      'friend_request' => '/friends/search',
      'challenge_received' when targetId != null => '/quest/$targetId',
      'friend_quest_completed' when targetId != null => '/quest/$targetId',
      'streak_reminder' => '/',
      'badge_earned' => '/profile',
      'leaderboard_change' => '/leaderboard',
      _ => null,
    };
  }

  /// Generates the notification body text for a given trigger.
  static String messageBody({
    required NotificationType type,
    String? senderName,
    String? questTitle,
    String? badgeName,
    int? rank,
  }) =>
      switch (type) {
        NotificationType.friendRequest =>
          '$senderName sent you a friend request',
        NotificationType.challengeReceived =>
          '$senderName challenged you: $questTitle',
        NotificationType.friendQuestCompleted =>
          '$senderName just completed: $questTitle',
        NotificationType.streakReminder =>
          'Your streak is on fire 🔥 Keep it going this week!',
        NotificationType.badgeEarned =>
          'You earned a new badge: $badgeName!',
        NotificationType.leaderboardChange =>
          'You moved up to #$rank on the weekly leaderboard!',
      };
}
