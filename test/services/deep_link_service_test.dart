import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/services/deep_link_service.dart';

void main() {
  group('DeepLinkService link generation', () {
    test('questLink', () {
      expect(
        DeepLinkService.questLink('q123'),
        'https://sidequestapp.com/quest/q123',
      );
    });

    test('profileLink', () {
      expect(
        DeepLinkService.profileLink('u456'),
        'https://sidequestapp.com/profile/u456',
      );
    });

    test('userLink', () {
      expect(
        DeepLinkService.userLink('alice'),
        'https://sidequestapp.com/user/alice',
      );
    });

    test('challengeLink', () {
      expect(
        DeepLinkService.challengeLink('c789'),
        'https://sidequestapp.com/challenge/c789',
      );
    });

    test('inviteLink without referrer', () {
      expect(
        DeepLinkService.inviteLink(),
        'https://sidequestapp.com/invite',
      );
    });

    test('inviteLink with referrer', () {
      expect(
        DeepLinkService.inviteLink(referrerId: 'u1'),
        'https://sidequestapp.com/invite?ref=u1',
      );
    });

    test('inviteMessage contains link', () {
      final msg = DeepLinkService.inviteMessage(referrerId: 'u1');
      expect(msg, contains('sidequestapp.com/invite'));
      expect(msg, contains('ref=u1'));
    });
  });

  group('DeepLinkService parseLink', () {
    test('parses quest link', () {
      final uri = Uri.parse('https://sidequestapp.com/quest/q123');
      expect(DeepLinkService.parseLink(uri), '/quest/q123');
    });

    test('parses profile link', () {
      final uri = Uri.parse('https://sidequestapp.com/profile/u456');
      expect(DeepLinkService.parseLink(uri), '/profile/u456');
    });

    test('parses user link as profile', () {
      final uri = Uri.parse('https://sidequestapp.com/user/alice');
      expect(DeepLinkService.parseLink(uri), '/profile/alice');
    });

    test('parses challenge link as quest', () {
      final uri = Uri.parse('https://sidequestapp.com/challenge/c789');
      expect(DeepLinkService.parseLink(uri), '/quest/c789');
    });

    test('parses invite link as home', () {
      final uri = Uri.parse('https://sidequestapp.com/invite');
      expect(DeepLinkService.parseLink(uri), '/');
    });

    test('returns null for unknown type', () {
      final uri = Uri.parse('https://sidequestapp.com/unknown/123');
      expect(DeepLinkService.parseLink(uri), isNull);
    });

    test('returns null for empty path', () {
      final uri = Uri.parse('https://sidequestapp.com');
      expect(DeepLinkService.parseLink(uri), isNull);
    });

    test('extractReferrer returns ref param', () {
      final uri = Uri.parse('https://sidequestapp.com/invite?ref=u1');
      expect(DeepLinkService.extractReferrer(uri), 'u1');
    });

    test('extractReferrer returns null when missing', () {
      final uri = Uri.parse('https://sidequestapp.com/invite');
      expect(DeepLinkService.extractReferrer(uri), isNull);
    });
  });

  group('DeferredDeepLinkHandler', () {
    late DeferredDeepLinkHandler handler;

    setUp(() {
      handler = DeferredDeepLinkHandler();
    });

    test('initially has no pending route', () {
      expect(handler.hasPending, isFalse);
      expect(handler.pendingRoute, isNull);
    });

    test('store sets pending route', () {
      handler.store('/quest/q1');
      expect(handler.hasPending, isTrue);
      expect(handler.pendingRoute, '/quest/q1');
    });

    test('consume returns and clears pending route', () {
      handler.store('/quest/q1');
      final route = handler.consume();
      expect(route, '/quest/q1');
      expect(handler.hasPending, isFalse);
    });

    test('consume returns null when no pending', () {
      expect(handler.consume(), isNull);
    });

    test('handleIncoming routes immediately when authenticated', () {
      final uri = Uri.parse('https://sidequestapp.com/quest/q1');
      final route = handler.handleIncoming(uri, isAuthenticated: true);
      expect(route, '/quest/q1');
      expect(handler.hasPending, isFalse);
    });

    test('handleIncoming defers when not authenticated', () {
      final uri = Uri.parse('https://sidequestapp.com/quest/q1');
      final route = handler.handleIncoming(uri, isAuthenticated: false);
      expect(route, isNull);
      expect(handler.hasPending, isTrue);
      expect(handler.pendingRoute, '/quest/q1');
    });

    test('handleIncoming returns null for invalid link', () {
      final uri = Uri.parse('https://sidequestapp.com/bad');
      final route = handler.handleIncoming(uri, isAuthenticated: true);
      expect(route, isNull);
    });
  });
}
