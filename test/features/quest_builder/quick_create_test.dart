import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/quest_builder/screens/quick_create_screen.dart';

void main() {
  Widget wrap() => ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const QuickCreateScreen(),
        ),
      );

  testWidgets('renders first step — title input', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.text('What do you want to do?'), findsOneWidget);
  });

  testWidgets('Next button disabled when title is empty', (tester) async {
    await tester.pumpWidget(wrap());
    // Find and check the Next button
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('progress indicator is shown', (tester) async {
    await tester.pumpWidget(wrap());
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('shows switch to builder link', (tester) async {
    await tester.pumpWidget(wrap());
    expect(
      find.text('Want more options? Switch to Builder'),
      findsOneWidget,
    );
  });
}
