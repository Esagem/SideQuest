import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/quest_detail/screens/quest_detail_screen.dart';
import 'package:sidequest/models/blocks/block_config.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/providers/quest_providers.dart';

void main() {
  final testQuest = QuestModel(
    id: 'q1',
    creatorId: 'u1',
    type: QuestType.public,
    title: 'Climb Everest',
    description: 'The ultimate challenge.',
    category: 'travel',
    difficulty: Difficulty.legendary,
    visibility: QuestVisibility.public,
    intent: const ['growth', 'challenge'],
    blocks: const QuestBlocks(proof: ProofBlock(type: ProofType.photo)),
    addedCount: 42,
    completedCount: 7,
    worthItCount: 5,
    needsWorkCount: 1,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  Widget wrap({QuestModel? quest}) => ProviderScope(
        overrides: [
          questByIdProvider('q1').overrideWith(
            (ref) => Stream.value(quest),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const QuestDetailScreen(questId: 'q1'),
        ),
      );

  testWidgets('shows loading initially', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        questByIdProvider('q1').overrideWith(
          // Never emits — stays in loading state
          (ref) => const Stream<QuestModel?>.empty(),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const QuestDetailScreen(questId: 'q1'),
      ),
    ),);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows quest not found for null', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('Quest not found'), findsOneWidget);
  });

  testWidgets('renders quest title', (tester) async {
    await tester.pumpWidget(wrap(quest: testQuest));
    await tester.pumpAndSettle();
    expect(find.text('Climb Everest'), findsOneWidget);
  });

  testWidgets('renders quest description', (tester) async {
    await tester.pumpWidget(wrap(quest: testQuest));
    await tester.pumpAndSettle();
    expect(find.text('The ultimate challenge.'), findsOneWidget);
  });

  testWidgets('renders category chip', (tester) async {
    await tester.pumpWidget(wrap(quest: testQuest));
    await tester.pumpAndSettle();
    expect(find.text('travel'), findsOneWidget);
  });

  testWidgets('renders stats', (tester) async {
    await tester.pumpWidget(wrap(quest: testQuest));
    await tester.pumpAndSettle();
    expect(find.text('42 added'), findsOneWidget);
    expect(find.text('7 completed'), findsOneWidget);
  });

  testWidgets('renders action buttons', (tester) async {
    await tester.pumpWidget(wrap(quest: testQuest));
    await tester.pumpAndSettle();
    expect(find.text('Add to My List'), findsOneWidget);
    expect(find.text('Challenge a Friend'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
  });

  testWidgets('renders quality signal bar', (tester) async {
    await tester.pumpWidget(wrap(quest: testQuest));
    await tester.pumpAndSettle();
    expect(find.text('How was this quest?'), findsOneWidget);
  });
}
