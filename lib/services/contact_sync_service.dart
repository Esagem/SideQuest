import 'package:flutter/foundation.dart';

/// Service for discovering friends from the user's device contacts.
///
/// Requests contact permission, extracts emails/phone numbers,
/// and matches them against Firestore users.
abstract final class ContactSyncService {
  /// Extracts email addresses and phone numbers from device contacts.
  ///
  /// Returns a list of contact identifiers (emails and normalized phones).
  /// Returns empty list if permission is denied.
  static Future<List<String>> getContactIdentifiers() async {
    // TODO(contacts): Implement with contacts_service + permission_handler
    // 1. Request Contacts permission
    // 2. Fetch all contacts
    // 3. Extract emails and phone numbers
    // 4. Normalize phone numbers (strip formatting)
    debugPrint('ContactSyncService: contacts not yet wired');
    return [];
  }

  /// Normalizes a phone number by stripping non-digit characters.
  static String normalizePhone(String phone) =>
      phone.replaceAll(RegExp(r'[^\d+]'), '');
}
