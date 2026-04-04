import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/activity/screens/activity_screen.dart';
import 'package:sidequest/features/activity/widgets/activity_card.dart';
import 'package:sidequest/features/activity/widgets/reaction_bar.dart';
import 'package:sidequest/features/activity/widgets/spot_check_prompt.dart';
import 'package:sidequest/models/activity_model.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

final _questCompleted = ActivityModel(
  id: 'a1',
  userId: 'u1',
  type: ActivityType.questCompleted,
  questId: 'q1',
  metadata: const {'xp': 200},
  createdAt: DateTime.now().subtract(const Duration(hours: 2)),
);

final _badgeEarned = ActivityModel(
  id: 'a2',
  userId: 'u1',
  type: ActivityType.badgeEarned,
  metadata: const {'badgeId': 'first_quest'},
  createdAt: DateTime.now().subtract(const Duration(days: 1)),
);

final _streakMilestone = ActivityModel(
  id: 'a3',
  userId: 'u1',
  type: ActivityType.streakMilestone,
  metadata: const {'streak': 12},
  createdAt: DateTime.now(),
);

void main() {
  group('ActivityScreen', () {
    testWidgets('shows Activity title', (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ActivityScreen(),
        ),
      ),);
      await tester.pumpAndSettle();
      expect(find.text('Activity'), findsOneWidget);
    });

    testWidgets('shows empty state when no activities', (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ActivityScreen(),
        ),
      ),);
      await tester.pumpAndSettle();
      expect(find.text('No activity yet'), findsOneWidget);
    });
  });

  group('ActivityCard', () {
    testWidgets('quest completed shows XP', (tester) async {
      await tester.pumpWidget(_wrap(
        ActivityCard(
          activity: _questCompleted,
          displayName: 'Alice',
        ),
      ),);
      expect(find.text('Completed a quest! 🎉'), findsOneWidget);
      expect(find.text('+200 XP'), findsOneWidget);
    });

    testWidgets('badge earned shows badge icon', (tester) async {
      await tester.pumpWidget(_wrap(
        ActivityCard(
          activity: _badgeEarned,
          displayName: 'Alice',
        ),
      ),);
      expect(find.text('Earned a new badge! 🏅'), findsOneWidget);
    });

    testWidgets('streak milestone shows count', (tester) async {
      await tester.pumpWidget(_wrap(
        ActivityCard(
          activity: _streakMilestone,
          displayName: 'Alice',
        ),
      ),);
      expect(find.text('🔥 12 week streak!'), findsOneWidget);
    });

    testWidgets('shows display name', (tester) async {
      await tester.pumpWidget(_wrap(
        ActivityCard(
          activity: _questCompleted,
          displayName: 'Alice',
        ),
      ),);
      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('shows time ago', (tester) async {
      await tester.pumpWidget(_wrap(
        ActivityCard(
          activity: _questCompleted,
          displayName: 'Alice',
        ),
      ),);
      expect(find.text('2h ago'), findsOneWidget);
    });
  });

  group('ReactionBar', () {
    testWidgets('renders all 6 preset emojis', (tester) async {
      await tester.pumpWidget(_wrap(
        ReactionBar(
          reactions: const {},
          userReaction: null,
          onReact: (_) {},
        ),
      ),);
      for (final emoji in ReactionBar.presets) {
        expect(find.text(emoji), findsOneWidget);
      }
    });

    testWidgets('shows reaction count when > 0', (tester) async {
      await tester.pumpWidget(_wrap(
        ReactionBar(
          reactions: const {'🔥': 5},
          userReaction: null,
          onReact: (_) {},
        ),
      ),);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('calls onReact with emoji when tapped', (tester) async {
      String? reacted;
      await tester.pumpWidget(_wrap(
        ReactionBar(
          reactions: const {},
          userReaction: null,
          onReact: (e) => reacted = e,
        ),
      ),);
      await tester.tap(find.text('🔥'));
      expect(reacted, '🔥');
    });

    testWidgets('calls onReact with null when removing', (tester) async {
      String? reacted = '🔥';
      await tester.pumpWidget(_wrap(
        ReactionBar(
          reactions: const {'🔥': 1},
          userReaction: '🔥',
          onReact: (e) => reacted = e,
        ),
      ),);
      await tester.tap(find.text('🔥'));
      expect(reacted, isNull);
    });
  });

  group('SpotCheckPrompt', () {
    testWidgets('shows Legit and Hmm buttons', (tester) async {
      await tester.pumpWidget(_wrap(
        SpotCheckPrompt(
          onLegit: () {},
          onHmm: () {},
        ),
      ),);
      expect(find.text('Legit?'), findsOneWidget);
      expect(find.text('Legit ✓'), findsOneWidget);
      expect(find.text('Hmm... 🤔'), findsOneWidget);
    });

    testWidgets('calls onLegit when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        SpotCheckPrompt(
          onLegit: () => tapped = true,
          onHmm: () {},
        ),
      ),);
      await tester.tap(find.text('Legit ✓'));
      expect(tapped, isTrue);
    });

    testWidgets('shows thanks after responding', (tester) async {
      await tester.pumpWidget(_wrap(
        SpotCheckPrompt(
          onLegit: () {},
          onHmm: () {},
          hasResponded: true,
        ),
      ),);
      expect(find.text('Thanks for checking!'), findsOneWidget);
      expect(find.text('Legit ✓'), findsNothing);
    });

    testWidgets('calls onHmm when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        SpotCheckPrompt(
          onLegit: () {},
          onHmm: () => tapped = true,
        ),
      ),);
      await tester.tap(find.text('Hmm... 🤔'));
      expect(tapped, isTrue);
    });
  });
}
