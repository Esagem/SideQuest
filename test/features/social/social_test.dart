import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/social/screens/challenge_flow_screen.dart';
import 'package:sidequest/features/social/screens/friend_search_screen.dart';
import 'package:sidequest/features/social/widgets/friend_list.dart';
import 'package:sidequest/features/social/widgets/friend_request_card.dart';
import 'package:sidequest/models/user_model.dart';
import 'package:sidequest/services/contact_sync_service.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: child),
    );

void main() {
  group('FriendSearchScreen', () {
    testWidgets('renders Find Friends title', (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const FriendSearchScreen(),
        ),
      ),);
      expect(find.text('Find Friends'), findsOneWidget);
    });

    testWidgets('shows search input and button', (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const FriendSearchScreen(),
        ),
      ),);
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('shows pending requests section', (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const FriendSearchScreen(),
        ),
      ),);
      expect(find.text('Pending Requests'), findsOneWidget);
    });

    testWidgets('shows contact sync button', (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const FriendSearchScreen(),
        ),
      ),);
      expect(
        find.text('Find friends from your contacts'),
        findsOneWidget,
      );
    });
  });

  group('FriendRequestCard', () {
    testWidgets('renders name and username', (tester) async {
      await tester.pumpWidget(_wrap(
        SingleChildScrollView(
          child: FriendRequestCard(
            displayName: 'Alice',
            username: 'alice',
            onAccept: () {},
            onDecline: () {},
          ),
        ),
      ),);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('@alice'), findsOneWidget);
    });

    testWidgets('has Accept and Decline buttons', (tester) async {
      await tester.pumpWidget(_wrap(
        SingleChildScrollView(
          child: FriendRequestCard(
            displayName: 'Alice',
            username: 'alice',
            onAccept: () {},
            onDecline: () {},
          ),
        ),
      ),);
      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
    });

    testWidgets('Accept calls onAccept', (tester) async {
      var accepted = false;
      await tester.pumpWidget(_wrap(
        SingleChildScrollView(
          child: FriendRequestCard(
            displayName: 'Alice',
            username: 'alice',
            onAccept: () => accepted = true,
            onDecline: () {},
          ),
        ),
      ),);
      await tester.tap(find.text('Accept'));
      expect(accepted, isTrue);
    });
  });

  group('FriendList', () {
    testWidgets('shows empty message when no friends', (tester) async {
      await tester.pumpWidget(_wrap(
        const FriendList(friends: []),
      ),);
      expect(
        find.text('No friends yet. Search for people to connect with!'),
        findsOneWidget,
      );
    });

    testWidgets('renders friend names', (tester) async {
      final friends = [
        UserModel(
          uid: 'u1',
          email: 'a@b.com',
          displayName: 'Alice',
          username: 'alice',
          dateOfBirth: DateTime(2000),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
        UserModel(
          uid: 'u2',
          email: 'b@c.com',
          displayName: 'Bob',
          username: 'bob',
          dateOfBirth: DateTime(2000),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ];
      await tester.pumpWidget(_wrap(FriendList(friends: friends)));
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });
  });

  group('ChallengeFlowScreen', () {
    testWidgets('renders Challenge title', (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ChallengeFlowScreen(questId: 'q1'),
        ),
      ),);
      expect(find.text('Challenge a Friend'), findsOneWidget);
    });

    testWidgets('has Send Challenge button', (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ChallengeFlowScreen(questId: 'q1'),
        ),
      ),);
      expect(find.text('Send Challenge ⚡'), findsOneWidget);
    });
  });

  group('ContactSyncService', () {
    test('normalizePhone strips formatting', () {
      expect(ContactSyncService.normalizePhone('+1 (555) 123-4567'),
          '+15551234567',);
      expect(ContactSyncService.normalizePhone('555.123.4567'),
          '5551234567',);
    });
  });
}
