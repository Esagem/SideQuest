import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/quest_detail/widgets/stage_progress_tracker.dart';
import 'package:sidequest/models/blocks/stages_block.dart';
import 'package:sidequest/models/user_quest_model.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

void main() {
  const stages = [
    StageItem(id: 's1', title: 'Plan route', xp: 50),
    StageItem(id: 's2', title: 'Start hiking', xp: 75),
    StageItem(id: 's3', title: 'Reach summit', xp: 100),
  ];

  testWidgets('renders all stage titles', (tester) async {
    await tester.pumpWidget(_wrap(
      const StageProgressTracker(stages: stages, progress: []),
    ),);
    expect(find.text('Plan route'), findsOneWidget);
    expect(find.text('Start hiking'), findsOneWidget);
    expect(find.text('Reach summit'), findsOneWidget);
  });

  testWidgets('shows XP for each stage', (tester) async {
    await tester.pumpWidget(_wrap(
      const StageProgressTracker(stages: stages, progress: []),
    ),);
    expect(find.text('50 XP'), findsOneWidget);
    expect(find.text('75 XP'), findsOneWidget);
    expect(find.text('100 XP'), findsOneWidget);
  });

  testWidgets('shows Complete Stage button for active stage', (tester) async {
    const progress = [
      StageProgress(stageId: 's1', status: StageStatus.completed),
      StageProgress(stageId: 's2', status: StageStatus.active),
      StageProgress(stageId: 's3', status: StageStatus.locked),
    ];
    await tester.pumpWidget(_wrap(
      StageProgressTracker(
        stages: stages,
        progress: progress,
        onCompleteStage: (_) {},
      ),
    ),);
    expect(find.text('Complete Stage'), findsOneWidget);
  });

  testWidgets('shows check icon for completed stages', (tester) async {
    const progress = [
      StageProgress(stageId: 's1', status: StageStatus.completed),
      StageProgress(stageId: 's2', status: StageStatus.locked),
      StageProgress(stageId: 's3', status: StageStatus.locked),
    ];
    await tester.pumpWidget(_wrap(
      const StageProgressTracker(stages: stages, progress: progress),
    ),);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
