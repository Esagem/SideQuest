import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/home/widgets/quest_card_home.dart';
import 'package:sidequest/models/blocks/block_config.dart';
import 'package:sidequest/models/blocks/location_block.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/models/user_quest_model.dart';

void main() {
  final quest = QuestModel(
    id: 'q1',
    creatorId: 'u1',
    type: QuestType.public,
    title: 'Climb a Mountain',
    description: 'Reach the summit.',
    category: 'travel',
    difficulty: Difficulty.hard,
    visibility: QuestVisibility.public,
    intent: const ['growth', 'challenge'],
    blocks: const QuestBlocks(
      proof: ProofBlock(type: ProofType.photo),
      location: LocationBlock(type: LocationType.specific, value: 'Alps'),
    ),
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  final userQuest = UserQuestModel(
    id: 'uq1',
    questId: 'q1',
    status: UserQuestStatus.active,
    addedAt: DateTime(2026),
    sortOrder: 0,
  );

  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  testWidgets('renders quest title', (tester) async {
    await tester.pumpWidget(wrap(
      QuestCardHome(quest: quest, userQuest: userQuest),
    ),);
    expect(find.text('Climb a Mountain'), findsOneWidget);
  });

  testWidgets('renders category chip', (tester) async {
    await tester.pumpWidget(wrap(
      QuestCardHome(quest: quest, userQuest: userQuest),
    ),);
    expect(find.text('travel'), findsOneWidget);
  });

  testWidgets('renders intent chips', (tester) async {
    await tester.pumpWidget(wrap(
      QuestCardHome(quest: quest, userQuest: userQuest),
    ),);
    expect(find.text('growth'), findsOneWidget);
    expect(find.text('challenge'), findsOneWidget);
  });

  testWidgets('renders difficulty chip', (tester) async {
    await tester.pumpWidget(wrap(
      QuestCardHome(quest: quest, userQuest: userQuest),
    ),);
    expect(find.text('hard'), findsOneWidget);
  });

  testWidgets('renders block summary icon for location', (tester) async {
    await tester.pumpWidget(wrap(
      QuestCardHome(quest: quest, userQuest: userQuest),
    ),);
    expect(find.text('📍'), findsOneWidget);
  });

  testWidgets('responds to tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(
      QuestCardHome(
        quest: quest,
        userQuest: userQuest,
        onTap: () => tapped = true,
      ),
    ),);
    await tester.tap(find.text('Climb a Mountain'));
    expect(tapped, isTrue);
  });
}
