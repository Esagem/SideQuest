import 'package:flutter_test/flutter_test.dart';

/// Username validation rules from spec.md:
/// - 3-20 characters
/// - Only lowercase letters, numbers, underscores
/// - Must start with a letter
bool isValidUsername(String username) {
  if (username.length < 3 || username.length > 20) return false;
  return RegExp(r'^[a-z][a-z0-9_]{2,19}$').hasMatch(username);
}

void main() {
  group('username validation', () {
    test('accepts valid usernames', () {
      expect(isValidUsername('alice'), isTrue);
      expect(isValidUsername('alice_123'), isTrue);
      expect(isValidUsername('a_b'), isTrue);
      expect(isValidUsername('user_name_long'), isTrue);
    });

    test('rejects too short', () {
      expect(isValidUsername('ab'), isFalse);
    });

    test('rejects too long', () {
      expect(isValidUsername('a' * 21), isFalse);
    });

    test('rejects starting with number', () {
      expect(isValidUsername('1alice'), isFalse);
    });

    test('rejects starting with underscore', () {
      expect(isValidUsername('_alice'), isFalse);
    });

    test('rejects uppercase', () {
      expect(isValidUsername('Alice'), isFalse);
    });

    test('rejects special characters', () {
      expect(isValidUsername('alice!'), isFalse);
      expect(isValidUsername('alice@bob'), isFalse);
    });

    test('rejects empty string', () {
      expect(isValidUsername(''), isFalse);
    });
  });
}
