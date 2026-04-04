import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  Widget wrap(Widget child, {bool dark = false}) => MaterialApp(
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        home: Scaffold(body: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),),
      );

  testWidgets('renders with label and hint', (tester) async {
    await tester.pumpWidget(wrap(
      const SQInput(label: 'Username', hint: 'Enter username'),
    ),);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Enter username'), findsOneWidget);
  });

  testWidgets('accepts text input', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(wrap(
      SQInput(controller: controller, hint: 'Type'),
    ),);
    await tester.enterText(find.byType(TextFormField), 'hello');
    expect(controller.text, 'hello');
  });

  testWidgets('shows error text', (tester) async {
    await tester.pumpWidget(wrap(
      const SQInput(errorText: 'Required field'),
    ),);
    expect(find.text('Required field'), findsOneWidget);
  });

  testWidgets('renders in dark theme', (tester) async {
    await tester.pumpWidget(wrap(
      const SQInput(hint: 'Dark input'),
      dark: true,
    ),);
    expect(find.text('Dark input'), findsOneWidget);
  });
}
