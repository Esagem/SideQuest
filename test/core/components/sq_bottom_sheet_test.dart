import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_bottom_sheet.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  Widget wrap({bool dark = false}) => MaterialApp(
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SQBottomSheet.show<void>(
                context,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Sheet Content'),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

  testWidgets('shows bottom sheet with content', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Sheet Content'), findsOneWidget);
  });

  testWidgets('renders in dark theme', (tester) async {
    await tester.pumpWidget(wrap(dark: true));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Sheet Content'), findsOneWidget);
  });
}
