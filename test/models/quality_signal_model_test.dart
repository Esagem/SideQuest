import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/quality_signal_model.dart';

void main() {
  final now = DateTime(2026);
  final json = {
    'questId': 'q1',
    'userId': 'u1',
    'signal': 'worthIt',
    'createdAt': now.toIso8601String(),
  };

  test('fromJson → toJson round-trip', () {
    final model = QualitySignalModel.fromJson(json);
    final roundTrip = QualitySignalModel.fromJson(model.toJson());
    expect(roundTrip.signal, QualitySignalType.worthIt);
    expect(roundTrip, model);
  });
}
