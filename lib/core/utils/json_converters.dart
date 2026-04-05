import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Deep-converts a Freezed `toJson()` output to a pure
/// `Map<String, dynamic>` with no Freezed object references.
///
/// This is necessary because Freezed's `toJson()` may leave nested
/// model objects as their Freezed types rather than raw Maps, which
/// breaks Firestore's value validation.
Map<String, dynamic> deepToJson(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

/// Recursively converts all Firestore [Timestamp]s in [map] to
/// ISO-8601 strings so that `json_serializable`-generated `fromJson`
/// methods can deserialize [DateTime] fields correctly.
Map<String, dynamic> convertTimestamps(Map<String, dynamic> map) =>
    map.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, convertTimestamps(value));
      } else if (value is List) {
        return MapEntry(key, _convertList(value));
      }
      return MapEntry(key, value);
    });

List<dynamic> _convertList(List<dynamic> list) => list.map((item) {
      if (item is Timestamp) return item.toDate().toIso8601String();
      if (item is Map<String, dynamic>) return convertTimestamps(item);
      if (item is List) return _convertList(item);
      return item;
    }).toList();
