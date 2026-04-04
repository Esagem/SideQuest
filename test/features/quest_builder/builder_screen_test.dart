import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/quest_builder/screens/builder_screen.dart';

void main() {
  Widget wrap() => ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const BuilderScreen(),
        ),
      );

  testWidgets('renders Create Quest title', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.text('Create Quest'), findsOneWidget);
  });

  testWidgets('renders Publish button', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.text('Publish'), findsOneWidget);
  });

  testWidgets('renders block tray with Core label', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.text('Core'), findsOneWidget);
  });

  testWidgets('renders preview card', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.text('Preview'), findsOneWidget);
  });
}
