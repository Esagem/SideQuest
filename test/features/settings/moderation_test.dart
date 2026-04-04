import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/settings/screens/moderation_policy_screen.dart';
import 'package:sidequest/features/settings/screens/report_screen.dart';
import 'package:sidequest/features/settings/screens/settings_screen.dart';
import 'package:sidequest/models/user_model.dart';
import 'package:sidequest/repositories/user_repository.dart';
import 'package:sidequest/services/block_service.dart';
import 'package:sidequest/services/keyword_filter_service.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      home: child,
    );

void main() {
  group('ReportScreen', () {
    testWidgets('renders reason chips', (tester) async {
      await tester.pumpWidget(_wrap(const ProviderScope(
        child: ReportScreen(targetType: 'quest', targetId: 'q1'),
      ),),);
      expect(find.text('Dangerous'), findsOneWidget);
      expect(find.text('Inappropriate'), findsOneWidget);
      expect(find.text('Spam'), findsOneWidget);
      expect(find.text('Harassment'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });

    testWidgets('shows Submit Report button', (tester) async {
      await tester.pumpWidget(_wrap(const ProviderScope(
        child: ReportScreen(targetType: 'quest', targetId: 'q1'),
      ),),);
      expect(find.text('Submit Report'), findsWidgets);
    });

    testWidgets('shows details input', (tester) async {
      await tester.pumpWidget(_wrap(const ProviderScope(
        child: ReportScreen(targetType: 'quest', targetId: 'q1'),
      ),),);
      expect(find.text('Additional details (optional)'), findsOneWidget);
    });
  });

  group('SettingsScreen', () {
    testWidgets('renders Settings title', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProviderScope(child: SettingsScreen()),
      ),);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows key settings tiles', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProviderScope(child: SettingsScreen()),
      ),);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Blocked Users'), findsOneWidget);
      expect(find.text('Community Guidelines'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
      expect(find.text('Delete Account'), findsOneWidget);
    });
  });

  group('ModerationPolicyScreen', () {
    testWidgets('renders title and visible sections', (tester) async {
      await tester.pumpWidget(_wrap(const ModerationPolicyScreen()));
      expect(find.text('Community Guidelines'), findsOneWidget);
      expect(find.text('What is SideQuest?'), findsOneWidget);
    });

    testWidgets('can scroll to lower sections', (tester) async {
      await tester.pumpWidget(_wrap(const ModerationPolicyScreen()));
      await tester.scrollUntilVisible(
        find.text('Contact'),
        AppSpacing.xxl,
      );
      expect(find.text('Contact'), findsOneWidget);
    });
  });

  group('BlockService', () {
    late FakeFirebaseFirestore firestore;
    late UserRepository userRepo;
    late BlockService blockService;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      userRepo = UserRepository(firestore);
      blockService = BlockService(userRepo);
    });

    test('blockUser adds to blockedUsers list', () async {
      await userRepo.create(UserModel(
        uid: 'u1',
        email: 'a@b.com',
        displayName: 'Alice',
        username: 'alice',
        dateOfBirth: DateTime(2000),
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),);
      await blockService.blockUser(
        currentUserId: 'u1',
        blockedUserId: 'u2',
      );
      final doc = await firestore.collection('users').doc('u1').get();
      final blocked = (doc.data()!['blockedUsers'] as List).cast<String>();
      expect(blocked, contains('u2'));
    });

    test('unblockUser removes from blockedUsers list', () async {
      await userRepo.create(UserModel(
        uid: 'u1',
        email: 'a@b.com',
        displayName: 'Alice',
        username: 'alice',
        dateOfBirth: DateTime(2000),
        blockedUsers: const ['u2'],
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),);
      await blockService.unblockUser(
        currentUserId: 'u1',
        blockedUserId: 'u2',
      );
      final doc = await firestore.collection('users').doc('u1').get();
      final blocked = (doc.data()!['blockedUsers'] as List).cast<String>();
      expect(blocked, isNot(contains('u2')));
    });

    test('isBlocked returns true for blocked user', () {
      final user = UserModel(
        uid: 'u1',
        email: 'a@b.com',
        displayName: 'Alice',
        username: 'alice',
        dateOfBirth: DateTime(2000),
        blockedUsers: const ['u2'],
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      expect(BlockService.isBlocked(user, 'u2'), isTrue);
      expect(BlockService.isBlocked(user, 'u3'), isFalse);
    });
  });

  group('KeywordFilterService', () {
    test('passes clean text', () {
      expect(KeywordFilterService.passes('Climb a mountain'), isTrue);
    });

    test('flags blocklisted terms', () {
      expect(KeywordFilterService.passes('This is spam'), isFalse);
      expect(KeywordFilterService.scan('This is spam'), contains('spam'));
    });

    test('flags scam text', () {
      expect(KeywordFilterService.passes('Free scam offer'), isFalse);
    });

    test('is case-insensitive', () {
      expect(KeywordFilterService.passes('SPAM content'), isFalse);
    });

    test('returns all flagged words', () {
      final flagged = KeywordFilterService.scan('spam and illegal');
      expect(flagged, containsAll(['spam', 'illegal']));
    });
  });
}
