/// Client-side keyword filter that pre-checks text before publishing.
///
/// Performs a local blocklist scan and optionally calls the
/// keywordFilter Cloud Function for server-side validation.
abstract final class KeywordFilterService {
  /// Client-side blocklist of prohibited terms.
  static const List<String> blocklist = [
    'spam',
    'scam',
    'illegal',
  ];

  /// Scans [text] against the client-side blocklist.
  ///
  /// Returns a list of flagged words found in the text, or empty
  /// if the text passes.
  static List<String> scan(String text) {
    final lower = text.toLowerCase();
    return blocklist.where(lower.contains).toList();
  }

  /// Whether the [text] passes the client-side filter.
  static bool passes(String text) => scan(text).isEmpty;
}
