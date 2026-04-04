import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/home/screens/home_screen.dart';
import 'package:sidequest/features/home/widgets/home_empty_state.dart';
import 'package:sidequest/models/user_quest_model.dart';
import 'package:sidequest/providers/user_quest_providers.dart';

void main() {
  Widget wrap({List<Override> overrides = const []}) => ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const HomeScreen(),
        ),
      );

  testWidgets('shows loading indicator initially', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty state when no quests', (tester) async {
    await tester.pumpWidget(wrap(
      overrides: [
        activeQuestsProvider.overrideWith(
          (ref) => Stream.value(<UserQuestModel>[]),
        ),
        completedQuestsProvider.overrideWith(
          (ref) => Stream.value(<UserQuestModel>[]),
        ),
      ],
    ),);
    await tester.pumpAndSettle();
    expect(find.byType(HomeEmptyState), findsOneWidget);
    expect(find.text('Your quest list is empty'), findsOneWidget);
    expect(find.text('Create Your First Quest'), findsOneWidget);
  });

  testWidgets('shows filter bar with Active and All chips', (tester) async {
    await tester.pumpWidget(wrap(
      overrides: [
        activeQuestsProvider.overrideWith(
          (ref) => Stream.value(<UserQuestModel>[]),
        ),
        completedQuestsProvider.overrideWith(
          (ref) => Stream.value(<UserQuestModel>[]),
        ),
      ],
    ),);
    await tester.pumpAndSettle();
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
  });

  testWidgets('toggles to Completed when status chip tapped', (tester) async {
    await tester.pumpWidget(wrap(
      overrides: [
        activeQuestsProvider.overrideWith(
          (ref) => Stream.value(<UserQuestModel>[]),
        ),
        completedQuestsProvider.overrideWith(
          (ref) => Stream.value(<UserQuestModel>[]),
        ),
      ],
    ),);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Active'));
    await tester.pumpAndSettle();
    expect(find.text('Completed'), findsOneWidget);
  });

  testWidgets('shows My Quests title', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.text('My Quests'), findsOneWidget);
  });

  testWidgets('shows add button in app bar', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
