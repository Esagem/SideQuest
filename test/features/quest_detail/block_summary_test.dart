import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/quest_detail/widgets/block_summary.dart';
import 'package:sidequest/models/blocks/block_config.dart';
import 'package:sidequest/models/blocks/bonus_block.dart';
import 'package:sidequest/models/blocks/constraint_block.dart';
import 'package:sidequest/models/blocks/location_block.dart';
import 'package:sidequest/models/blocks/people_block.dart';
import 'package:sidequest/models/blocks/prompt_block.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/blocks/stages_block.dart';
import 'package:sidequest/models/blocks/wildcard_block.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

void main() {
  testWidgets('renders proof block', (tester) async {
    await tester.pumpWidget(_wrap(
      const BlockSummary(
        blocks: QuestBlocks(proof: ProofBlock(type: ProofType.photo)),
      ),
    ),);
    expect(find.text('📸'), findsOneWidget);
    expect(find.text('photo'), findsOneWidget);
  });

  testWidgets('renders location block', (tester) async {
    await tester.pumpWidget(_wrap(
      const BlockSummary(
        blocks: QuestBlocks(
          proof: ProofBlock(type: ProofType.photo),
          location: LocationBlock(type: LocationType.city, value: 'NYC'),
        ),
      ),
    ),);
    expect(find.text('📍'), findsOneWidget);
    expect(find.text('NYC'), findsOneWidget);
  });

  testWidgets('renders people block with count', (tester) async {
    await tester.pumpWidget(_wrap(
      const BlockSummary(
        blocks: QuestBlocks(
          proof: ProofBlock(type: ProofType.photo),
          people: PeopleBlock(type: PeopleType.group, minCount: 3),
        ),
      ),
    ),);
    expect(find.text('👥'), findsOneWidget);
    expect(find.text('group (3+)'), findsOneWidget);
  });

  testWidgets('renders stages count', (tester) async {
    await tester.pumpWidget(_wrap(
      const BlockSummary(
        blocks: QuestBlocks(
          proof: ProofBlock(type: ProofType.photo),
          stages: StagesBlock(items: [
            StageItem(id: 's1', title: 'A', xp: 50),
            StageItem(id: 's2', title: 'B', xp: 50),
          ],),
        ),
      ),
    ),);
    expect(find.text('🪜'), findsOneWidget);
    expect(find.text('2 stages'), findsOneWidget);
  });

  testWidgets('renders wildcard options count', (tester) async {
    await tester.pumpWidget(_wrap(
      const BlockSummary(
        blocks: QuestBlocks(
          proof: ProofBlock(type: ProofType.photo),
          wildcard: WildcardBlock(options: ['a', 'b', 'c']),
        ),
      ),
    ),);
    expect(find.text('🎲'), findsOneWidget);
    expect(find.text('3 options'), findsOneWidget);
  });

  testWidgets('renders prompt question', (tester) async {
    await tester.pumpWidget(_wrap(
      const BlockSummary(
        blocks: QuestBlocks(
          proof: ProofBlock(type: ProofType.photo),
          prompt: PromptBlock(question: 'How did it feel?'),
        ),
      ),
    ),);
    expect(find.text('💬'), findsOneWidget);
    expect(find.text('How did it feel?'), findsOneWidget);
  });

  testWidgets('renders bonus with XP', (tester) async {
    await tester.pumpWidget(_wrap(
      const BlockSummary(
        blocks: QuestBlocks(
          proof: ProofBlock(type: ProofType.photo),
          bonus: BonusBlock(condition: 'Under 5 min', xpBonus: 50),
        ),
      ),
    ),);
    expect(find.text('🏅'), findsOneWidget);
    expect(find.text('Under 5 min (+50 XP)'), findsOneWidget);
  });

  testWidgets('renders constraint text', (tester) async {
    await tester.pumpWidget(_wrap(
      const BlockSummary(
        blocks: QuestBlocks(
          proof: ProofBlock(type: ProofType.photo),
          constraint: ConstraintBlock(text: 'No phone'),
        ),
      ),
    ),);
    expect(find.text('🚫'), findsOneWidget);
    expect(find.text('No phone'), findsOneWidget);
  });
}
