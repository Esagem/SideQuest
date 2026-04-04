import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/app.dart';

void main() {
  testWidgets('SideQuestApp renders', (tester) async {
    await tester.pumpWidget(const SideQuestApp());
    expect(find.text('SideQuest'), findsOneWidget);
  });
}
