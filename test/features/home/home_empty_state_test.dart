import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/home/widgets/home_empty_state.dart';

void main() {
  Widget wrap() => MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(body: HomeEmptyState()),
      );

  testWidgets('renders empty state message', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.text('Your quest list is empty'), findsOneWidget);
    expect(
      find.text('What have you always wanted to do?'),
      findsOneWidget,
    );
  });

  testWidgets('renders CTA button', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.text('Create Your First Quest'), findsOneWidget);
  });

  testWidgets('renders explore link', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.text('Or explore popular quests'), findsOneWidget);
  });
}
