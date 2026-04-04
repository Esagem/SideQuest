import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:sidequest/features/leaderboard/widgets/leaderboard_entry.dart';
import 'package:sidequest/features/leaderboard/widgets/leaderboard_list.dart';
import 'package:sidequest/models/leaderboard_entry_model.dart';

void main() {
  final entries = [
    const LeaderboardEntryModel(
      rank: 1,
      userId: 'u1',
      displayName: 'Alice',
      username: 'alice',
      tier: 'legend',
      xp: 20000,
      questsCompleted: 100,
      badgeShowcase: ['first_quest'],
    ),
    const LeaderboardEntryModel(
      rank: 2,
      userId: 'u2',
      displayName: 'Bob',
      username: 'bob',
      tier: 'trailblazer',
      xp: 8000,
      questsCompleted: 50,
    ),
    const LeaderboardEntryModel(
      rank: 3,
      userId: 'u3',
      displayName: 'Charlie',
      username: 'charlie',
      tier: 'adventurer',
      xp: 3000,
      questsCompleted: 25,
    ),
    const LeaderboardEntryModel(
      rank: 4,
      userId: 'u4',
      displayName: 'Dana',
      username: 'dana',
      tier: 'explorer',
      xp: 800,
      questsCompleted: 10,
    ),
  ];

  Widget wrapWidget(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: child),
      );

  Widget wrapScreen() => ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LeaderboardScreen(),
        ),
      );

  group('LeaderboardScreen', () {
    testWidgets('renders Leaderboard title', (tester) async {
      await tester.pumpWidget(wrapScreen());
      await tester.pumpAndSettle();
      expect(find.text('Leaderboard'), findsOneWidget);
    });

    testWidgets('renders all 4 tabs', (tester) async {
      await tester.pumpWidget(wrapScreen());
      await tester.pumpAndSettle();
      expect(find.text('Weekly'), findsOneWidget);
      expect(find.text('Friends'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Global'), findsOneWidget);
    });

    testWidgets('Weekly is the default tab', (tester) async {
      await tester.pumpWidget(wrapScreen());
      await tester.pumpAndSettle();
      // Weekly tab should be selected (first tab)
      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller?.index, 0);
    });
  });

  group('LeaderboardEntry', () {
    testWidgets('renders rank, name, and XP', (tester) async {
      await tester.pumpWidget(wrapWidget(
        LeaderboardEntry(entry: entries[0]),
      ),);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('20000'), findsOneWidget);
    });

    testWidgets('top 3 have colored rank circles', (tester) async {
      await tester.pumpWidget(wrapWidget(
        Column(
          children: [
            LeaderboardEntry(entry: entries[0]),
            LeaderboardEntry(entry: entries[1]),
            LeaderboardEntry(entry: entries[2]),
          ],
        ),
      ),);
      // Top 3 should have CircleAvatar for rank
      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('rank 4+ shows plain text', (tester) async {
      await tester.pumpWidget(wrapWidget(
        LeaderboardEntry(entry: entries[3]),
      ),);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('Dana'), findsOneWidget);
    });

    testWidgets('current user is highlighted with (You)', (tester) async {
      await tester.pumpWidget(wrapWidget(
        LeaderboardEntry(
          entry: entries[0],
          isCurrentUser: true,
        ),
      ),);
      expect(find.text('(You)'), findsOneWidget);
    });

    testWidgets('shows username', (tester) async {
      await tester.pumpWidget(wrapWidget(
        LeaderboardEntry(entry: entries[0]),
      ),);
      expect(find.text('@alice'), findsOneWidget);
    });
  });

  group('LeaderboardList', () {
    testWidgets('renders all entries', (tester) async {
      await tester.pumpWidget(wrapWidget(
        LeaderboardList(entries: entries),
      ),);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Charlie'), findsOneWidget);
      expect(find.text('Dana'), findsOneWidget);
    });

    testWidgets('shows empty message when no entries', (tester) async {
      await tester.pumpWidget(wrapWidget(
        const LeaderboardList(entries: []),
      ),);
      expect(find.text('No rankings yet.'), findsOneWidget);
    });

    testWidgets('highlights current user', (tester) async {
      await tester.pumpWidget(wrapWidget(
        LeaderboardList(entries: entries, currentUserId: 'u2'),
      ),);
      expect(find.text('(You)'), findsOneWidget);
    });
  });

  group('Friends tab', () {
    testWidgets('shows empty state when < 3 friends', (tester) async {
      await tester.pumpWidget(wrapScreen());
      await tester.pumpAndSettle();
      // Tap Friends tab
      await tester.tap(find.text('Friends'));
      await tester.pumpAndSettle();
      expect(find.text('Add more friends to see your ranking!'), findsOneWidget);
    });
  });

  group('Category tab', () {
    testWidgets('shows category chips', (tester) async {
      await tester.pumpWidget(wrapScreen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Category'));
      await tester.pumpAndSettle();
      expect(find.text('Travel & Adventure'), findsOneWidget);
    });
  });
}
