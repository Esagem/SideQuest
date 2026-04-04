import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/services/notification_service.dart';

void main() {
  group('NotificationService.parseRoute', () {
    test('friend_request routes to search', () {
      expect(
        NotificationService.parseRoute({'type': 'friend_request'}),
        '/friends/search',
      );
    });

    test('challenge_received routes to quest', () {
      expect(
        NotificationService.parseRoute({
          'type': 'challenge_received',
          'targetId': 'q1',
        }),
        '/quest/q1',
      );
    });

    test('friend_quest_completed routes to quest', () {
      expect(
        NotificationService.parseRoute({
          'type': 'friend_quest_completed',
          'targetId': 'q2',
        }),
        '/quest/q2',
      );
    });

    test('streak_reminder routes to home', () {
      expect(
        NotificationService.parseRoute({'type': 'streak_reminder'}),
        '/',
      );
    });

    test('badge_earned routes to profile', () {
      expect(
        NotificationService.parseRoute({'type': 'badge_earned'}),
        '/profile',
      );
    });

    test('leaderboard_change routes to leaderboard', () {
      expect(
        NotificationService.parseRoute({'type': 'leaderboard_change'}),
        '/leaderboard',
      );
    });

    test('unknown type returns null', () {
      expect(
        NotificationService.parseRoute({'type': 'unknown'}),
        isNull,
      );
    });

    test('missing type returns null', () {
      expect(NotificationService.parseRoute({}), isNull);
    });
  });

  group('NotificationService.messageBody', () {
    test('friend request message', () {
      final msg = NotificationService.messageBody(
        type: NotificationType.friendRequest,
        senderName: 'Alice',
      );
      expect(msg, 'Alice sent you a friend request');
    });

    test('challenge message includes quest title', () {
      final msg = NotificationService.messageBody(
        type: NotificationType.challengeReceived,
        senderName: 'Bob',
        questTitle: 'Climb Everest',
      );
      expect(msg, 'Bob challenged you: Climb Everest');
    });

    test('streak reminder is encouraging', () {
      final msg = NotificationService.messageBody(
        type: NotificationType.streakReminder,
      );
      expect(msg, contains('🔥'));
      expect(msg, contains('Keep it going'));
    });

    test('badge earned includes name', () {
      final msg = NotificationService.messageBody(
        type: NotificationType.badgeEarned,
        badgeName: 'Globetrotter',
      );
      expect(msg, 'You earned a new badge: Globetrotter!');
    });

    test('leaderboard change includes rank', () {
      final msg = NotificationService.messageBody(
        type: NotificationType.leaderboardChange,
        rank: 5,
      );
      expect(msg, 'You moved up to #5 on the weekly leaderboard!');
    });
  });

  group('NotificationPreferences', () {
    test('defaults to all enabled', () {
      const prefs = NotificationPreferences();
      for (final type in NotificationType.values) {
        expect(prefs.isEnabled(type), isTrue);
      }
    });

    test('fromMap parses correctly', () {
      final prefs = NotificationPreferences.fromMap(const {
        'friendRequest': false,
        'streakReminder': false,
      });
      expect(prefs.isEnabled(NotificationType.friendRequest), isFalse);
      expect(prefs.isEnabled(NotificationType.streakReminder), isFalse);
      expect(prefs.isEnabled(NotificationType.badgeEarned), isTrue);
    });

    test('toMap round-trips', () {
      const prefs = NotificationPreferences(
        friendRequest: false,
        leaderboardChange: false,
      );
      final map = prefs.toMap();
      final restored = NotificationPreferences.fromMap(map);
      expect(
        restored.isEnabled(NotificationType.friendRequest),
        isFalse,
      );
      expect(
        restored.isEnabled(NotificationType.leaderboardChange),
        isFalse,
      );
      expect(
        restored.isEnabled(NotificationType.challengeReceived),
        isTrue,
      );
    });

    test('copyWith overrides specific field', () {
      const prefs = NotificationPreferences();
      final updated = prefs.copyWith(streakReminder: false);
      expect(updated.isEnabled(NotificationType.streakReminder), isFalse);
      expect(updated.isEnabled(NotificationType.friendRequest), isTrue);
    });
  });

  group('NotificationService token', () {
    test('fcmToken is initially null', () {
      final service = NotificationService();
      expect(service.fcmToken, isNull);
    });

    test('storeToken updates fcmToken', () async {
      final service = NotificationService();
      await service.storeToken(userId: 'u1', token: 'test-token');
      expect(service.fcmToken, 'test-token');
    });
  });
}
