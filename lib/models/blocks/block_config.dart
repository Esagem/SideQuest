import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:sidequest/models/blocks/bonus_block.dart';
import 'package:sidequest/models/blocks/chain_block.dart';
import 'package:sidequest/models/blocks/constraint_block.dart';
import 'package:sidequest/models/blocks/intent_block.dart';
import 'package:sidequest/models/blocks/location_block.dart';
import 'package:sidequest/models/blocks/people_block.dart';
import 'package:sidequest/models/blocks/prompt_block.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/blocks/repeat_block.dart';
import 'package:sidequest/models/blocks/stages_block.dart';
import 'package:sidequest/models/blocks/time_block.dart';
import 'package:sidequest/models/blocks/wildcard_block.dart';

part 'block_config.freezed.dart';
part 'block_config.g.dart';

/// The complete set of block configurations for a quest.
///
/// Only [proof] is required. All other blocks are optional and
/// correspond to the modular block types in the quest builder.
@freezed
class QuestBlocks with _$QuestBlocks {
  /// Creates a [QuestBlocks].
  const factory QuestBlocks({
    required ProofBlock proof,
    LocationBlock? location,
    PeopleBlock? people,
    TimeBlock? time,
    WildcardBlock? wildcard,
    PromptBlock? prompt,
    ChainBlock? chain,
    BonusBlock? bonus,
    ConstraintBlock? constraint,
    RepeatBlock? repeat,
    StagesBlock? stages,
    IntentBlock? intentBlock,
  }) = _QuestBlocks;

  /// Creates a [QuestBlocks] from a JSON map.
  factory QuestBlocks.fromJson(Map<String, dynamic> json) =>
      _$QuestBlocksFromJson(json);
}
