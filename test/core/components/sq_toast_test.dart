import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: child,
      );

  testWidgets('success toast shows message', (tester) async {
    await tester.pumpWidget(wrap(
      Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => SQToast.success(context, 'Quest done!'),
            child: const Text('Show'),
          ),
        ),
      ),
    ),);
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();
    expect(find.text('Quest done!'), findsOneWidget);
  });

  testWidgets('error toast shows message', (tester) async {
    await tester.pumpWidget(wrap(
      Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => SQToast.error(context, 'Failed!'),
            child: const Text('Show'),
          ),
        ),
      ),
    ),);
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();
    expect(find.text('Failed!'), findsOneWidget);
  });
}
