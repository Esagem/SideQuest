import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/blocks/block_config.dart';

void main() {
  final json = {
    'proof': {'type': 'photo'},
    'location': {'type': 'city', 'value': 'NYC'},
    'people': {'type': 'group', 'minCount': 3},
  };

  test('QuestBlocks fromJson → toJson round-trip', () {
    final model = QuestBlocks.fromJson(json);
    final encoded = jsonEncode(model.toJson());
    final decoded = jsonDecode(encoded) as Map<String, dynamic>;
    final roundTrip = QuestBlocks.fromJson(decoded);
    expect(roundTrip.proof.type.name, 'photo');
    expect(roundTrip.location?.value, 'NYC');
    expect(roundTrip.people?.minCount, 3);
    expect(roundTrip, model);
  });
}
