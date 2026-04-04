import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_block.freezed.dart';
part 'location_block.g.dart';

/// The type of location constraint.
enum LocationType {
  /// A specific named place.
  specific,

  /// A city or region.
  city,

  /// A category of places (e.g. "coffee shop").
  category,

  /// No location constraint.
  anywhere,
}

/// Configuration for the location constraint block.
@freezed
class LocationBlock with _$LocationBlock {
  /// Creates a [LocationBlock].
  const factory LocationBlock({
    required LocationType type,
    String? value,
    double? lat,
    double? lng,
  }) = _LocationBlock;

  /// Creates a [LocationBlock] from a JSON map.
  factory LocationBlock.fromJson(Map<String, dynamic> json) =>
      _$LocationBlockFromJson(json);
}
