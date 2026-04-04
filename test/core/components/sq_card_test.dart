import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_card.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  Widget wrap(Widget child, {bool dark = false}) => MaterialApp(
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        home: Scaffold(body: child),
      );

  testWidgets('renders child content', (tester) async {
    await tester.pumpWidget(wrap(
      const SQCard(child: Text('Content')),
    ),);
    expect(find.text('Content'), findsOneWidget);
  });

  testWidgets('responds to tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(
      SQCard(onTap: () => tapped = true, child: const Text('Tap me')),
    ),);
    await tester.tap(find.text('Tap me'));
    expect(tapped, isTrue);
  });

  testWidgets('renders with category accent', (tester) async {
    await tester.pumpWidget(wrap(
      const SQCard(categoryAccent: 'travel', child: Text('Quest')),
    ),);
    expect(find.text('Quest'), findsOneWidget);
  });

  testWidgets('renders in dark theme', (tester) async {
    await tester.pumpWidget(wrap(
      const SQCard(child: Text('Dark')),
      dark: true,
    ),);
    expect(find.text('Dark'), findsOneWidget);
  });
}
