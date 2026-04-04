import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/profile/screens/profile_screen.dart';
import 'package:sidequest/features/profile/widgets/badge_showcase.dart';
import 'package:sidequest/features/profile/widgets/intent_breakdown_chart.dart';
import 'package:sidequest/features/profile/widgets/profile_stats.dart';
import 'package:sidequest/models/user_model.dart';
import 'package:sidequest/providers/user_providers.dart';

void main() {
  final testUser = UserModel(
    uid: 'u1',
    email: 'a@b.com',
    displayName: 'Alice Quester',
    username: 'alice',
    bio: 'Adventure seeker.',
    dateOfBirth: DateTime(2000),
    xp: 1500,
    tier: 'adventurer',
    currentStreak: 12,
    longestStreak: 20,
    questsCompleted: 35,
    friendCount: 8,
    badges: const ['first_quest', 'streak_7', 'globetrotter'],
    badgeShowcase: const ['first_quest', 'streak_7', 'globetrotter'],
    intentStats: const {'growth': 15, 'fun': 10, 'challenge': 5},
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  Widget wrap({UserModel? user}) => ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(
            (ref) => Stream.value(user ?? testUser),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileScreen(),
        ),
      );

  Widget wrapWidget(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  group('ProfileScreen', () {
    testWidgets('shows Profile title', (tester) async {
      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('shows display name', (tester) async {
      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();
      expect(find.text('Alice Quester'), findsOneWidget);
    });

    testWidgets('shows username', (tester) async {
      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();
      expect(find.text('@alice'), findsOneWidget);
    });

    testWidgets('shows bio', (tester) async {
      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();
      expect(find.text('Adventure seeker.'), findsOneWidget);
    });

    testWidgets('shows settings icon', (tester) async {
      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('shows Edit Profile button', (tester) async {
      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();
      expect(find.text('Edit Profile'), findsOneWidget);
    });
  });

  group('BadgeShowcase', () {
    testWidgets('renders up to 3 badges', (tester) async {
      await tester.pumpWidget(wrapWidget(
        const BadgeShowcase(
          badgeIds: ['first_quest', 'streak_7', 'globetrotter'],
        ),
      ),);
      expect(find.byType(BadgeShowcase), findsOneWidget);
    });

    testWidgets('empty when no badges', (tester) async {
      await tester.pumpWidget(wrapWidget(
        const BadgeShowcase(badgeIds: []),
      ),);
      expect(find.byType(BadgeShowcase), findsOneWidget);
    });
  });

  group('ProfileStats', () {
    testWidgets('shows all stat values', (tester) async {
      await tester.pumpWidget(wrapWidget(
        const ProfileStats(
          questsCompleted: 35,
          friendCount: 8,
          challengesSent: 5,
        ),
      ),);
      expect(find.text('35'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });
  });

  group('IntentBreakdownChart', () {
    testWidgets('renders chart and personality label', (tester) async {
      await tester.pumpWidget(wrapWidget(
        const IntentBreakdownChart(
          intentStats: {'growth': 15, 'fun': 10, 'challenge': 5},
        ),
      ),);
      expect(find.text('What kind of quester are you?'), findsOneWidget);
      expect(find.text('Growth Seeker'), findsOneWidget);
    });

    testWidgets('shows legend items', (tester) async {
      await tester.pumpWidget(wrapWidget(
        const IntentBreakdownChart(
          intentStats: {'growth': 15, 'fun': 10},
        ),
      ),);
      expect(find.text('growth (15)'), findsOneWidget);
      expect(find.text('fun (10)'), findsOneWidget);
    });

    testWidgets('hidden when empty', (tester) async {
      await tester.pumpWidget(wrapWidget(
        const IntentBreakdownChart(intentStats: {}),
      ),);
      expect(
        find.text('What kind of quester are you?'),
        findsNothing,
      );
    });
  });
}
