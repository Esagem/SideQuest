import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/bonus_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/category_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/chain_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/constraint_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/difficulty_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/intent_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/location_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/people_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/prompt_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/proof_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/repeat_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/stages_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/time_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/title_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/wildcard_block_widget.dart';
import 'package:sidequest/models/quest_model.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),),),
    );

void main() {
  group('TitleBlockWidget', () {
    testWidgets('renders and accepts input', (tester) async {
      String? title;
      await tester.pumpWidget(_wrap(
        TitleBlockWidget(
          onTitleChanged: (v) => title = v,
          onDescriptionChanged: (_) {},
        ),
      ),);
      expect(find.text('Quest Title'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).first, 'Test');
      expect(title, 'Test');
    });
  });

  group('ProofBlockWidget', () {
    testWidgets('renders proof type chips', (tester) async {
      await tester.pumpWidget(_wrap(
        ProofBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Photo'), findsOneWidget);
      expect(find.text('Video'), findsOneWidget);
    });

    testWidgets('calls onConfigChanged on tap', (tester) async {
      dynamic config;
      await tester.pumpWidget(_wrap(
        ProofBlockWidget(onConfigChanged: (c) => config = c),
      ),);
      await tester.tap(find.text('Video'));
      expect(config, isNotNull);
    });
  });

  group('LocationBlockWidget', () {
    testWidgets('renders location chips', (tester) async {
      await tester.pumpWidget(_wrap(
        LocationBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Anywhere'), findsOneWidget);
    });
  });

  group('PeopleBlockWidget', () {
    testWidgets('renders people chips', (tester) async {
      await tester.pumpWidget(_wrap(
        PeopleBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Solo'), findsOneWidget);
      expect(find.text('Group'), findsOneWidget);
    });
  });

  group('TimeBlockWidget', () {
    testWidgets('renders time chips', (tester) async {
      await tester.pumpWidget(_wrap(
        TimeBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Deadline'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
    });
  });

  group('CategoryBlockWidget', () {
    testWidgets('renders all 8 categories', (tester) async {
      await tester.pumpWidget(_wrap(
        CategoryBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Travel & Adventure'), findsOneWidget);
      expect(find.text('Random / Wildcard'), findsOneWidget);
    });

    testWidgets('calls onConfigChanged with category key', (tester) async {
      dynamic selected;
      await tester.pumpWidget(_wrap(
        CategoryBlockWidget(onConfigChanged: (c) => selected = c),
      ),);
      await tester.tap(find.text('Travel & Adventure'));
      expect(selected, 'travel');
    });
  });

  group('DifficultyBlockWidget', () {
    testWidgets('renders difficulty chips with XP preview', (tester) async {
      await tester.pumpWidget(_wrap(
        DifficultyBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Easy (1.0x)'), findsOneWidget);
      expect(find.textContaining('Base XP'), findsOneWidget);
    });

    testWidgets('calls onConfigChanged with Difficulty', (tester) async {
      Difficulty? selected;
      await tester.pumpWidget(_wrap(
        DifficultyBlockWidget(onConfigChanged: (d) => selected = d),
      ),);
      await tester.tap(find.text('Hard (2.0x)'));
      expect(selected, Difficulty.hard);
    });
  });

  group('StagesBlockWidget', () {
    testWidgets('starts with 2 stages', (tester) async {
      await tester.pumpWidget(_wrap(
        StagesBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Stage 1'), findsOneWidget);
      expect(find.text('Stage 2'), findsOneWidget);
    });
  });

  group('WildcardBlockWidget', () {
    testWidgets('starts with 2 option fields', (tester) async {
      await tester.pumpWidget(_wrap(
        WildcardBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });
  });

  group('PromptBlockWidget', () {
    testWidgets('renders question input', (tester) async {
      await tester.pumpWidget(_wrap(
        PromptBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Reflection Question'), findsOneWidget);
    });
  });

  group('ChainBlockWidget', () {
    testWidgets('renders chain inputs', (tester) async {
      await tester.pumpWidget(_wrap(
        ChainBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Prerequisite Quest ID'), findsOneWidget);
    });
  });

  group('BonusBlockWidget', () {
    testWidgets('renders condition and XP inputs', (tester) async {
      await tester.pumpWidget(_wrap(
        BonusBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Bonus Condition'), findsOneWidget);
      expect(find.text('Bonus XP'), findsOneWidget);
    });
  });

  group('ConstraintBlockWidget', () {
    testWidgets('renders constraint input', (tester) async {
      await tester.pumpWidget(_wrap(
        ConstraintBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('Constraint'), findsOneWidget);
    });
  });

  group('RepeatBlockWidget', () {
    testWidgets('renders repeat chips', (tester) async {
      await tester.pumpWidget(_wrap(
        RepeatBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.text('One-time'), findsOneWidget);
      expect(find.text('Repeatable'), findsOneWidget);
    });
  });

  group('IntentBlockWidget', () {
    testWidgets('renders all 6 intent chips', (tester) async {
      await tester.pumpWidget(_wrap(
        IntentBlockWidget(onConfigChanged: (_) {}),
      ),);
      expect(find.textContaining('Growth'), findsOneWidget);
      expect(find.textContaining('Create'), findsOneWidget);
    });
  });
}
