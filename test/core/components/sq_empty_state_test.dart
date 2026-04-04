import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_empty_state.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: child),
      );

  testWidgets('renders title and message', (tester) async {
    await tester.pumpWidget(wrap(
      const SQEmptyState(
        title: 'No Quests',
        message: 'Start your adventure!',
      ),
    ),);
    expect(find.text('No Quests'), findsOneWidget);
    expect(find.text('Start your adventure!'), findsOneWidget);
  });

  testWidgets('shows CTA button when label provided', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(
      SQEmptyState(
        title: 'Empty',
        message: 'Nothing here.',
        ctaLabel: 'Create',
        onCta: () => tapped = true,
      ),
    ),);
    expect(find.text('Create'), findsOneWidget);
    await tester.tap(find.text('Create'));
    expect(tapped, isTrue);
  });

  testWidgets('hides CTA when label is null', (tester) async {
    await tester.pumpWidget(wrap(
      const SQEmptyState(title: 'Empty', message: 'Nothing.'),
    ),);
    expect(find.byType(ElevatedButton), findsNothing);
  });
}
