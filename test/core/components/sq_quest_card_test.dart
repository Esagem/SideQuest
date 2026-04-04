import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_quest_card.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  const quest = SQQuestCardData(
    title: 'Climb a Mountain',
    category: 'travel',
    intents: ['growth', 'challenge'],
    difficulty: 'Hard',
    completionCount: 42,
  );

  Widget wrap(Widget child, {bool dark = false}) => MaterialApp(
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  testWidgets('renders quest title', (tester) async {
    await tester.pumpWidget(wrap(const SQQuestCard(quest: quest)));
    expect(find.text('Climb a Mountain'), findsOneWidget);
  });

  testWidgets('renders category chip', (tester) async {
    await tester.pumpWidget(wrap(const SQQuestCard(quest: quest)));
    expect(find.text('travel'), findsOneWidget);
  });

  testWidgets('renders intent chips', (tester) async {
    await tester.pumpWidget(wrap(const SQQuestCard(quest: quest)));
    expect(find.text('growth'), findsOneWidget);
    expect(find.text('challenge'), findsOneWidget);
  });

  testWidgets('renders completion count', (tester) async {
    await tester.pumpWidget(wrap(const SQQuestCard(quest: quest)));
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('responds to tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(
      SQQuestCard(quest: quest, onTap: () => tapped = true),
    ),);
    await tester.tap(find.text('Climb a Mountain'));
    expect(tapped, isTrue);
  });

  testWidgets('shows add button when enabled', (tester) async {
    var added = false;
    await tester.pumpWidget(wrap(
      SQQuestCard(
        quest: quest,
        showAddButton: true,
        onAddToList: () => added = true,
      ),
    ),);
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    expect(added, isTrue);
  });

  testWidgets('renders in dark theme', (tester) async {
    await tester.pumpWidget(wrap(
      const SQQuestCard(quest: quest),
      dark: true,
    ),);
    expect(find.text('Climb a Mountain'), findsOneWidget);
  });
}
