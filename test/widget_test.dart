import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/app.dart';

void main() {
  testWidgets('SideQuestApp renders', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SideQuestApp()),
    );
    // App should render — shows welcome screen for unauthenticated user
    await tester.pumpAndSettle();
    expect(find.textContaining('SideQuest'), findsWidgets);
  });
}
