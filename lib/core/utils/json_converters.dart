import 'dart:convert';

/// Deep-converts a Freezed `toJson()` output to a pure
/// `Map<String, dynamic>` with no Freezed object references.
///
/// This is necessary because Freezed's `toJson()` may leave nested
/// model objects as their Freezed types rather than raw Maps, which
/// breaks Firestore's value validation.
Map<String, dynamic> deepToJson(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;
