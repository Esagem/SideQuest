import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A donut chart showing the user's intent breakdown.
///
/// Renders a custom-painted donut with colored segments for each
/// intent type, plus a legend below.
class IntentBreakdownChart extends StatelessWidget {
  /// Creates an [IntentBreakdownChart].
  const IntentBreakdownChart({
    required this.intentStats,
    super.key,
  });

  /// Map of intent name to completion count.
  final Map<String, int> intentStats;

  static const _intentColors = {
    'growth': AppColors.intentGrowth,
    'connection': AppColors.intentConnection,
    'fun': AppColors.intentFun,
    'challenge': AppColors.intentChallenge,
    'explore': AppColors.intentExplore,
    'create': AppColors.intentCreate,
  };

  int get _total => intentStats.values.fold(0, (a, b) => a + b);

  String get _dominantIntent {
    if (intentStats.isEmpty) return 'Explorer';
    final sorted = intentStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return switch (sorted.first.key) {
      'growth' => 'Growth Seeker',
      'connection' => 'Connector',
      'fun' => 'Fun Lover',
      'challenge' => 'Challenger',
      'explore' => 'Explorer',
      'create' => 'Creator',
      _ => 'Quester',
    };
  }

  @override
  Widget build(BuildContext context) {
    final total = _total;
    if (total == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'What kind of quester are you?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          _dominantIntent,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.sunsetOrange,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: AppSpacing.xxl * 3,
          child: CustomPaint(
            size: Size.infinite,
            painter: _DonutPainter(
              segments: intentStats.entries
                  .where((e) => e.value > 0)
                  .map((e) => _Segment(
                        value: e.value / total,
                        color: _intentColors[e.key] ?? AppColors.softGray,
                      ),)
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Legend
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xxs,
          children: intentStats.entries
              .where((e) => e.value > 0)
              .map(
                (e) => _LegendItem(
                  label: e.key,
                  count: e.value,
                  color: _intentColors[e.key] ?? AppColors.softGray,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _Segment {
  const _Segment({required this.value, required this.color});
  final double value;
  final Color color;
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.segments});

  final List<_Segment> segments;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 20.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    var startAngle = -math.pi / 2;
    for (final segment in segments) {
      final sweepAngle = segment.value * 2 * math.pi;
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      segments != oldDelegate.segments;
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpacing.sm,
            height: AppSpacing.sm,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            '$label ($count)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
}
