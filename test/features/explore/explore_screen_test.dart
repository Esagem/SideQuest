import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/explore/screens/explore_screen.dart';
import 'package:sidequest/features/explore/widgets/category_filter_bar.dart';
import 'package:sidequest/features/explore/widgets/explore_feed.dart';
import 'package:sidequest/features/explore/widgets/intent_filter_bar.dart';
import 'package:sidequest/features/explore/widgets/quest_search_bar.dart';
import 'package:sidequest/features/explore/widgets/trending_section.dart';
import 'package:sidequest/models/blocks/block_config.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/providers/quest_providers.dart';

void main() {
  final testQuests = [
    QuestModel(
      id: 'q1',
      creatorId: 'u1',
      type: QuestType.public,
      title: 'Climb a Mountain',
      description: '',
      category: 'travel',
      difficulty: Difficulty.hard,
      visibility: QuestVisibility.public,
      intent: const ['growth'],
      addedCount: 42,
      completedCount: 7,
      blocks: const QuestBlocks(proof: ProofBlock(type: ProofType.photo)),
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    ),
  ];

  Widget wrapScreen({List<QuestModel>? quests}) => ProviderScope(
        overrides: [
          publicQuestsProvider.overrideWith(
            (ref) => Stream.value(quests ?? []),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ExploreScreen(),
        ),
      );

  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: child),
      );

  group('ExploreScreen', () {
    testWidgets('shows Explore title', (tester) async {
      await tester.pumpWidget(wrapScreen());
      expect(find.text('Explore'), findsOneWidget);
    });

    testWidgets('shows empty message when no quests', (tester) async {
      await tester.pumpWidget(wrapScreen());
      await tester.pumpAndSettle();
      expect(find.text('No quests found'), findsOneWidget);
    });

    testWidgets('renders quest cards with data', (tester) async {
      await tester.pumpWidget(wrapScreen(quests: testQuests));
      await tester.pumpAndSettle();
      expect(find.text('Climb a Mountain'), findsWidgets);
    });

    testWidgets('shows category filter chips', (tester) async {
      await tester.pumpWidget(wrapScreen());
      await tester.pumpAndSettle();
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Travel & Adventure'), findsOneWidget);
    });

    testWidgets('shows search bar in integrated screen', (tester) async {
      await tester.pumpWidget(wrapScreen());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });

  group('QuestSearchBar', () {
    testWidgets('renders search icon', (tester) async {
      await tester.pumpWidget(wrap(
        QuestSearchBar(onSearch: (_) {}, onClear: () {}),
      ),);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('calls onSearch after text input', (tester) async {
      String? query;
      await tester.pumpWidget(wrap(
        QuestSearchBar(onSearch: (q) => query = q, onClear: () {}),
      ),);
      await tester.enterText(find.byType(TextField), 'climb');
      await tester.pump(const Duration(milliseconds: 350));
      expect(query, 'climb');
    });
  });

  group('CategoryFilterBar', () {
    testWidgets('renders All and category chips', (tester) async {
      await tester.pumpWidget(wrap(
        CategoryFilterBar(selected: null, onSelected: (_) {}),
      ),);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Travel & Adventure'), findsOneWidget);
    });

    testWidgets('calls onSelected when tapped', (tester) async {
      String? selected;
      await tester.pumpWidget(wrap(
        CategoryFilterBar(
          selected: null,
          onSelected: (v) => selected = v,
        ),
      ),);
      await tester.tap(find.text('Travel & Adventure'));
      expect(selected, 'travel');
    });
  });

  group('IntentFilterBar', () {
    testWidgets('renders intent chips', (tester) async {
      await tester.pumpWidget(wrap(
        IntentFilterBar(selected: const {}, onToggled: (_) {}),
      ),);
      expect(find.textContaining('Growth'), findsOneWidget);
      expect(find.textContaining('Fun'), findsOneWidget);
    });
  });

  group('TrendingSection', () {
    testWidgets('renders trending title with quests', (tester) async {
      await tester.pumpWidget(wrap(
        SingleChildScrollView(
          child: TrendingSection(
            quests: testQuests,
            onTap: (_) {},
            onAdd: (_) {},
          ),
        ),
      ),);
      expect(find.text('Trending'), findsOneWidget);
    });

    testWidgets('empty when no quests', (tester) async {
      await tester.pumpWidget(wrap(
        TrendingSection(
          quests: const [],
          onTap: (_) {},
          onAdd: (_) {},
        ),
      ),);
      expect(find.text('Trending'), findsNothing);
    });
  });

  group('ExploreFeed', () {
    testWidgets('renders quest cards', (tester) async {
      await tester.pumpWidget(wrap(
        ExploreFeed(
          quests: testQuests,
          onTap: (_) {},
          onAdd: (_) {},
        ),
      ),);
      expect(find.text('Climb a Mountain'), findsOneWidget);
    });
  });
}
